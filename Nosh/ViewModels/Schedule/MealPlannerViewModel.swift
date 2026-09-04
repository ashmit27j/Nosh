import Foundation
import FirebaseFirestore
import FirebaseAuth

/// One day in the week strip.
///
/// `key` is the Firestore document ID (`yyyy-MM-dd`) and the dictionary key used
/// everywhere in this view model. `label` is display only. Keying state by the
/// weekday label instead — as this previously did — gives all time only seven
/// slots, so last Monday and next Monday collide.
struct DayTab: Identifiable, Hashable {
    let key: String
    let label: String
    let date: Date

    var id: String { key }
}

@MainActor
final class MealPlannerViewModel: ObservableObject {

    @Published var selectedDate: Date = Date()
    @Published private(set) var tabs: [DayTab] = []
    @Published var selectedTabKey: String = ""
    @Published private(set) var plans: [String: DayMealPlan] = [:]
    @Published var mealTimes: MealTimes = .default
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var weekListener: ListenerRegistration?

    /// `yyyy-MM-dd` in a fixed locale/calendar so document IDs are stable
    /// regardless of the device's regional settings.
    private static let keyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let labelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        return calendar
    }

    init() {
        rebuildWeek(around: selectedDate)
        loadMealTimes()
    }

    deinit {
        weekListener?.remove()
    }

    // MARK: - Keys

    func dateKey(for date: Date) -> String {
        Self.keyFormatter.string(from: date)
    }

    // MARK: - Week construction

    /// Rebuilds the tab strip and, when the week actually changed, re-subscribes.
    /// This is the single entry point — `init` used to call the setup chain twice,
    /// costing 14 document reads before the first frame.
    private func rebuildWeek(around date: Date) {
        let startOfWeek = self.startOfWeek(for: date)

        let newTabs: [DayTab] = (0..<7).compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else {
                return nil
            }
            return DayTab(
                key: dateKey(for: day),
                label: Self.labelFormatter.string(from: day),
                date: day
            )
        }

        let weekChanged = newTabs.first?.key != tabs.first?.key
        tabs = newTabs
        selectedTabKey = dateKey(for: date)

        if weekChanged {
            subscribeToWeek()
        }
    }

    private func startOfWeek(for date: Date) -> Date {
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear], from: date
        )
        let start = calendar.date(from: components) ?? date
        return calendar.startOfDay(for: start)
    }

    // MARK: - Loading

    /// One range listener over the week instead of seven individual `getDocument`
    /// calls, and it keeps the UI live as the plan changes.
    private func subscribeToWeek() {
        weekListener?.remove()
        weekListener = nil

        guard let userId = Auth.auth().currentUser?.uid,
              let first = tabs.first?.key,
              let last = tabs.last?.key
        else {
            plans = [:]
            return
        }

        isLoading = true

        weekListener = db.collection("users")
            .document(userId)
            .collection("mealPlanner")
            .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: first)
            .whereField(FieldPath.documentID(), isLessThanOrEqualTo: last)
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    self.isLoading = false

                    if let error {
                        self.errorMessage = error.localizedDescription
                        return
                    }

                    var loaded: [String: DayMealPlan] = [:]
                    for document in snapshot?.documents ?? [] {
                        if let plan = DayMealPlan(document: document) {
                            loaded[plan.id] = plan
                        }
                    }
                    self.plans = loaded
                }
            }
    }

    func loadMealTimes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Task { [weak self] in
            guard let self else { return }
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                guard let data = document.data(),
                      let breakfast = data["breakfastTime"] as? Timestamp,
                      let lunch = data["lunchTime"] as? Timestamp,
                      let dinner = data["dinnerTime"] as? Timestamp
                else { return }

                self.mealTimes = MealTimes(
                    breakfastTime: breakfast.dateValue(),
                    lunchTime: lunch.dateValue(),
                    dinnerTime: dinner.dateValue()
                )
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Reading

    func plan(for dayKey: String) -> DayMealPlan? {
        plans[dayKey]
    }

    func meals(for dayKey: String, type: MealType) -> [Meal] {
        plans[dayKey]?[type] ?? []
    }

    func tab(forKey key: String) -> DayTab? {
        tabs.first { $0.key == key }
    }

    // MARK: - Navigation

    func changeDate(to newDate: Date) {
        selectedDate = newDate
        rebuildWeek(around: newDate)
    }

    func selectTab(_ tab: DayTab) {
        changeDate(to: tab.date)
    }

    // MARK: - Meal times

    func updateMealTime(_ newTime: Date, for mealType: MealType) {
        switch mealType {
        case .breakfast: mealTimes.breakfastTime = newTime
        case .lunch:     mealTimes.lunchTime = newTime
        case .dinner:    mealTimes.dinnerTime = newTime
        }
        saveMealTimes()
    }

    private func saveMealTimes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = [
            "breakfastTime": Timestamp(date: mealTimes.breakfastTime),
            "lunchTime": Timestamp(date: mealTimes.lunchTime),
            "dinnerTime": Timestamp(date: mealTimes.dinnerTime)
        ]

        Task { [weak self] in
            do {
                try await self?.db.collection("users").document(userId)
                    .setData(data, merge: true)
            } catch {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Mutating the plan

    /// Adds a meal, skipping it if the same recipe is already in that slot.
    ///
    /// Runs in a transaction: the previous read-modify-write let two quick taps
    /// interleave and lose one of the writes.
    func addMeal(to dayKey: String, type mealType: MealType, meal: Meal) async {
        guard let userId = Auth.auth().currentUser?.uid,
              let day = tab(forKey: dayKey) ?? tab(forKey: selectedTabKey)
        else { return }

        let reference = db.collection("users").document(userId)
            .collection("mealPlanner").document(day.key)

        do {
            _ = try await db.runTransaction { transaction, errorPointer -> Any? in
                let snapshot: DocumentSnapshot
                do {
                    snapshot = try transaction.getDocument(reference)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    return nil
                }

                var existing = Self.decodeMeals(from: snapshot, field: mealType.field)

                // Identity is stable across fetches now, so this actually works.
                guard !existing.contains(where: { $0.id == meal.id }) else { return nil }
                existing.append(meal)

                do {
                    let encoded = try existing.map { try Firestore.Encoder().encode($0) }
                    transaction.setData([
                        "date": Timestamp(date: day.date),
                        mealType.field: encoded
                    ], forDocument: reference, merge: true)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }
                return nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func removeMeal(from dayKey: String, type mealType: MealType, meal: Meal) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let reference = db.collection("users").document(userId)
            .collection("mealPlanner").document(dayKey)

        do {
            _ = try await db.runTransaction { transaction, errorPointer -> Any? in
                let snapshot: DocumentSnapshot
                do {
                    snapshot = try transaction.getDocument(reference)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    return nil
                }

                var existing = Self.decodeMeals(from: snapshot, field: mealType.field)
                existing.removeAll { $0.id == meal.id }

                do {
                    let encoded = try existing.map { try Firestore.Encoder().encode($0) }
                    transaction.updateData([mealType.field: encoded], forDocument: reference)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }
                return nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private nonisolated static func decodeMeals(
        from snapshot: DocumentSnapshot,
        field: String
    ) -> [Meal] {
        guard snapshot.exists,
              let raw = snapshot.data()?[field] as? [[String: Any]]
        else { return [] }

        return raw.compactMap { try? Firestore.Decoder().decode(Meal.self, from: $0) }
    }

    // MARK: - Search & discovery

    func searchMeals(query: String) async throws -> [Meal] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let snapshot = try await db.collection("recipes")
            .whereField("name", isGreaterThanOrEqualTo: trimmed)
            .whereField("name", isLessThan: trimmed + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments()

        return snapshot.documents.compactMap { Meal(document: $0) }
    }

    /// Picks a random recipe without downloading the whole collection.
    ///
    /// Uses a random cursor over document IDs and wraps around when the cursor
    /// lands past the end, so it costs two reads at most instead of one per recipe.
    func fetchRandomMeal() async -> Meal? {
        let cursor = UUID().uuidString
        let collection = db.collection("recipes")

        do {
            let forward = try await collection
                .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: cursor)
                .limit(to: 1)
                .getDocuments()

            if let document = forward.documents.first {
                return Meal(document: document)
            }

            let wrapped = try await collection
                .whereField(FieldPath.documentID(), isLessThan: cursor)
                .limit(to: 1)
                .getDocuments()

            return wrapped.documents.first.flatMap { Meal(document: $0) }
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    /// Fills the selected day with three randomly chosen recipes.
    ///
    /// Named for what it does — the previous `generateAIMealPlan` was declared
    /// `async throws` but neither awaited nor threw, always returned the same
    /// three recipes from `limit(to: 3)`, and wrote with `merge: false`, wiping
    /// anything already planned for that day.
    func fillDayWithSuggestions() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let day = tab(forKey: selectedTabKey)
            ?? DayTab(
                key: dateKey(for: selectedDate),
                label: Self.labelFormatter.string(from: selectedDate),
                date: selectedDate
            )

        isLoading = true
        defer { isLoading = false }

        var picks: [Meal] = []
        for _ in 0..<3 {
            if let meal = await fetchRandomMeal(), !picks.contains(where: { $0.id == meal.id }) {
                picks.append(meal)
            }
        }

        guard picks.count == 3 else {
            errorMessage = "Not enough recipes to build a plan yet."
            return
        }

        do {
            let encoded = try picks.map { try Firestore.Encoder().encode($0) }
            try await db.collection("users").document(userId)
                .collection("mealPlanner").document(day.key)
                .setData([
                    "date": Timestamp(date: day.date),
                    MealType.breakfast.field: [encoded[0]],
                    MealType.lunch.field: [encoded[1]],
                    MealType.dinner.field: [encoded[2]]
                ], merge: true)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Teardown

    /// Called when the user signs out so the listener doesn't keep firing
    /// permission-denied errors against the previous UID.
    func stopListening() {
        weekListener?.remove()
        weekListener = nil
        plans = [:]
    }
}
