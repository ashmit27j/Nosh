import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class MealPlannerViewModel: ObservableObject {
    // MARK: - Firestore Properties
    @Published var selectedDate: Date = Date() {
        didSet {
            // When date changes, update the week tabs
            updateWeekForSelectedDate()
            loadMealPlan(for: selectedDate)
        }
    }
    @Published var currentDayPlan: DayMealPlan?
    @Published var mealTimes: MealTimes = .default
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Legacy Properties (PRESERVED)
    @Published var items: [String: [String: [Meal]]] = [:]
    @Published var tabs: [String] = []
    @Published var selectedTab: String = ""
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        setupWeekTabs()
        initializeWeekMeals()
        loadMealTimes()
        loadMealPlan(for: selectedDate)
        loadWeekMealPlans()
    }
    
    deinit {
        listener?.remove()
    }
    
    // MARK: - Setup Week Tabs (Based on Selected Date)
    private func setupWeekTabs() {
        updateWeekForSelectedDate()
    }
    
    // Update week tabs based on selected date
    // MARK: - Setup Week Tabs (Based on Selected Date) - FIXED
    private func updateWeekForSelectedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let calendar = Calendar.current
        
        // Get the start of the week (Monday) for the selected date
        let startOfWeek = getStartOfWeek(for: selectedDate, calendar: calendar)
        
        // Generate tabs for the week (Monday to Sunday)
        tabs = (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
            return dateFormatter.string(from: date)
        }
        
        // Update selected tab to match selected date
        selectedTab = dateFormatter.string(from: selectedDate)
        
        // Initialize meals for this week
        initializeWeekMeals()
        
        // Load week meal plans from Firestore
        loadWeekMealPlans()
    }

    func initializeWeekMeals() {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        // Get the start of the week (Monday) for the selected date
        let startOfWeek = getStartOfWeek(for: selectedDate, calendar: calendar)
        
        // Initialize empty meals for all 7 days of the week
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                let dayString = dateFormatter.string(from: date)
                
                // Create empty structure for each day if not exists
                if items[dayString] == nil {
                    items[dayString] = [
                        "breakfast": [],
                        "lunch": [],
                        "dinner": []
                    ]
                }
            }
        }
    }

    // MARK: - Load Week Meal Plans from Firestore - FIXED
    func loadWeekMealPlans() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        // Get the start of the week (Monday) for the selected date
        let startOfWeek = getStartOfWeek(for: selectedDate, calendar: calendar)
        
        // Load meal plans for all 7 days of the week
        for offset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) {
                let dateString = dateToString(date)
                let dayString = dateFormatter.string(from: date)
                
                db.collection("users")
                    .document(userId)
                    .collection("mealPlanner")
                    .document(dateString)
                    .getDocument { [weak self] snapshot, error in
                        guard let self = self else { return }
                        
                        if let snapshot = snapshot, snapshot.exists {
                            do {
                                let dayPlan = try snapshot.data(as: DayMealPlan.self)
                                
                                Task { @MainActor in
                                    self.items[dayString] = [
                                        "breakfast": dayPlan.breakfast,
                                        "lunch": dayPlan.lunch,
                                        "dinner": dayPlan.dinner
                                    ]
                                }
                            } catch {
                                print("Error decoding day plan: \(error)")
                            }
                        } else {
                            // Initialize empty for this day
                            Task { @MainActor in
                                if self.items[dayString] == nil {
                                    self.items[dayString] = [
                                        "breakfast": [],
                                        "lunch": [],
                                        "dinner": []
                                    ]
                                }
                            }
                        }
                    }
            }
        }
    }

    // MARK: - Helper Functions - FIXED

    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // NEW: Get start of week (Monday) for any date
    private func getStartOfWeek(for date: Date, calendar: Calendar) -> Date {
        // Get the weekday (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        let weekday = calendar.component(.weekday, from: date)
        
        // Calculate days to subtract to get to Monday
        // If Sunday (1), subtract 6 days
        // If Monday (2), subtract 0 days
        // If Tuesday (3), subtract 1 day, etc.
        let daysToSubtract = weekday == 1 ? 6 : weekday - 2
        
        // Get Monday of this week
        let monday = calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
        
        // Set time to midnight
        return calendar.startOfDay(for: monday)
    }

    // Made public so MealPlannerHeader can access it - FIXED
    func dateFromDayString(_ dayString: String) -> Date? {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        // Get the start of the week (Monday) for the selected date
        let startOfWeek = getStartOfWeek(for: selectedDate, calendar: calendar)
        
        // Find the date in the current week that matches the day string
        for offset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
            if dateFormatter.string(from: date) == dayString {
                return date
            }
        }
        
        return nil
    }

    
    
    // MARK: - Firebase Operations
    
    func loadMealTimes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading meal times: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let breakfastTimestamp = data["breakfastTime"] as? Timestamp,
               let lunchTimestamp = data["lunchTime"] as? Timestamp,
               let dinnerTimestamp = data["dinnerTime"] as? Timestamp {
                
                Task { @MainActor in
                    self.mealTimes = MealTimes(
                        breakfastTime: breakfastTimestamp.dateValue(),
                        lunchTime: lunchTimestamp.dateValue(),
                        dinnerTime: dinnerTimestamp.dateValue()
                    )
                }
            }
        }
    }
    
    func saveMealTimes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "breakfastTime": Timestamp(date: mealTimes.breakfastTime),
            "lunchTime": Timestamp(date: mealTimes.lunchTime),
            "dinnerTime": Timestamp(date: mealTimes.dinnerTime)
        ]
        
        db.collection("users").document(userId).setData(data, merge: true) { error in
            if let error = error {
                print("Error saving meal times: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMealPlan(for date: Date) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        let dateString = dateToString(date)
        
        listener?.remove()
        
        listener = db.collection("users")
            .document(userId)
            .collection("mealPlanner")
            .document(dateString)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                Task { @MainActor in
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    if let snapshot = snapshot, snapshot.exists {
                        do {
                            self.currentDayPlan = try snapshot.data(as: DayMealPlan.self)
                            self.updateLegacyItems()
                        } catch {
                            print("Error decoding meal plan: \(error.localizedDescription)")
                            self.createEmptyMealPlan(for: date)
                        }
                    } else {
                        self.createEmptyMealPlan(for: date)
                    }
                }
            }
    }
    
    private func createEmptyMealPlan(for date: Date) {
        currentDayPlan = DayMealPlan(
            date: date,
            breakfast: [],
            lunch: [],
            dinner: []
        )
        updateLegacyItems()
    }
    
    // Update legacy items structure for existing UI
    private func updateLegacyItems() {
        guard let plan = currentDayPlan else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let dayString = dateFormatter.string(from: plan.date)
        
        items[dayString] = [
            "breakfast": plan.breakfast,
            "lunch": plan.lunch,
            "dinner": plan.dinner
        ]
    }
    
    func addMeal(to day: String, type mealType: String, meal: Meal) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let date = dateFromDayString(day) ?? selectedDate
        let dateString = dateToString(date)
        
        print("📅 Adding meal to date: \(dateString), day: \(day), type: \(mealType)")
        
        let mealField: String
        switch mealType.lowercased() {
        case "breakfast":
            mealField = "breakfast"
        case "lunch":
            mealField = "lunch"
        case "dinner":
            mealField = "dinner"
        default:
            return
        }
        
        // Get existing meals first
        db.collection("users")
            .document(userId)
            .collection("mealPlanner")
            .document(dateString)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                var existingMeals: [Meal] = []
                
                if let snapshot = snapshot, snapshot.exists,
                   let data = snapshot.data(),
                   let mealsData = data[mealField] as? [[String: Any]] {
                    existingMeals = mealsData.compactMap { dict in
                        try? Firestore.Decoder().decode(Meal.self, from: dict)
                    }
                }
                
                // Add new meal to existing meals
                existingMeals.append(meal)
                
                do {
                    let mealsData = try existingMeals.map { try Firestore.Encoder().encode($0) }
                    
                    self.db.collection("users")
                        .document(userId)
                        .collection("mealPlanner")
                        .document(dateString)
                        .setData([
                            "date": Timestamp(date: date),
                            mealField: mealsData
                        ], merge: true) { error in
                            if let error = error {
                                print("❌ Error adding meal: \(error.localizedDescription)")
                            } else {
                                print("✅ Meal added successfully!")
                                // Reload the week to reflect changes
                                Task { @MainActor in
                                    self.loadWeekMealPlans()
                                }
                            }
                        }
                } catch {
                    print("❌ Encoding error: \(error)")
                }
            }
    }
    
    func removeMeal(from day: String, type mealType: String, meal: Meal) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let date = dateFromDayString(day) ?? selectedDate
        let dateString = dateToString(date)
        
        let mealField: String
        switch mealType.lowercased() {
        case "breakfast":
            mealField = "breakfast"
        case "lunch":
            mealField = "lunch"
        case "dinner":
            mealField = "dinner"
        default:
            return
        }
        
        // Get existing meals and remove the specified one
        db.collection("users")
            .document(userId)
            .collection("mealPlanner")
            .document(dateString)
            .getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let snapshot = snapshot, snapshot.exists,
                   let data = snapshot.data(),
                   let mealsData = data[mealField] as? [[String: Any]] {
                    
                    var existingMeals = mealsData.compactMap { dict -> Meal? in
                        try? Firestore.Decoder().decode(Meal.self, from: dict)
                    }
                    
                    // Remove the meal with matching id
                    existingMeals.removeAll { $0.id == meal.id }
                    
                    do {
                        let updatedMealsData = try existingMeals.map { try Firestore.Encoder().encode($0) }
                        
                        self.db.collection("users")
                            .document(userId)
                            .collection("mealPlanner")
                            .document(dateString)
                            .updateData([mealField: updatedMealsData]) { error in
                                if let error = error {
                                    print("Error removing meal: \(error.localizedDescription)")
                                } else {
                                    // Reload the week to reflect changes
                                    Task { @MainActor in
                                        self.loadWeekMealPlans()
                                    }
                                }
                            }
                    } catch {
                        print("Encoding error: \(error)")
                    }
                }
            }
    }
    
    func changeDate(to newDate: Date) {
        selectedDate = newDate
        // Week tabs will auto-update via didSet
    }
    
    func updateMealTime(_ newTime: Date, for mealType: MealType) {
        switch mealType {
        case .breakfast:
            mealTimes.breakfastTime = newTime
        case .lunch:
            mealTimes.lunchTime = newTime
        case .dinner:
            mealTimes.dinnerTime = newTime
        }
        saveMealTimes()
    }
    
    // MARK: - Search Function
    func searchMeals(query: String) async throws -> [Meal] {
        let snapshot = try await db.collection("recipes")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThan: query + "\u{f8ff}")
            .limit(to: 20)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: Meal.self)
        }
    }
    
    // MARK: - Fetch Random Meal
    func fetchRandomMeal(completion: @escaping (Meal?) -> Void) {
        db.collection("recipes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching random meal: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(nil)
                return
            }
            
            let randomDocument = documents.randomElement()
            let meal = try? randomDocument?.data(as: Meal.self)
            
            DispatchQueue.main.async {
                completion(meal)
            }
        }
    }
    
    // MARK: - AI Meal Plan Generation
    func generateAIMealPlan() async throws {
        print("Generating AI meal plan...")
    }
    
}
