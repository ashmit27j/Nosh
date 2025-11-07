//import SwiftUI
//
//struct MealSectionView: View {
//    let title: String
//    let meals: [Meal]
//    let onEditTapped: () -> Void
//    let onAdd: () -> Void
//    let onDelete: (Meal) -> Void
//    let isEditing: Bool
//    
//    @State private var showingTimeEdit = false
//    @State private var mealTime: Date = Date()
//    @State private var selectedMealForViewing: Meal? = nil
//    @StateObject private var viewModel = MealPlannerViewModel()
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                // Meal type and time
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(title)
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(Color("primaryText"))
//                    
//                    // Time button - changes globally for all days
//                    Button(action: {
//                        showingTimeEdit.toggle()
//                    }) {
//                        HStack(spacing: 4) {
//                            Image(systemName: "clock")
//                                .font(.system(size: 12))
//                            Text(timeString(from: getMealTime()))
//                                .font(.system(size: 14, weight: .medium))
//                        }
//                        .foregroundColor(Color("secondaryText"))
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color("secondaryButton").opacity(0.5))
//                        .cornerRadius(6)
//                    }
//                }
//
//                Spacer()
//
//                Button(action: onEditTapped) {
//                    Text(!isEditing ? "Edit" : "Done")
//                        .foregroundColor(Color("primaryAccent"))
//                        .fontWeight(.medium)
//                }
//            }
//
//            Rectangle()
//                .fill(Color("secondaryButton"))
//                .frame(height: 2)
//                .frame(maxWidth: .infinity)
//                .cornerRadius(100)
//
//            // Show meals or placeholder
//            if meals.isEmpty {
//                // Empty placeholder - always visible
//                EmptyMealPlaceholder(mealType: title)
//            } else {
//                ForEach(meals) { meal in
//                    if isEditing {
//                        ZStack(alignment: .trailing) {
//                            MealItemView(meal: meal)
//                            
//                            Button(action: { onDelete(meal) }) {
//                                Image(systemName: "minus.circle.fill")
//                                    .foregroundColor(.red)
//                                    .font(.title2)
//                                    .padding(8)
//                            }
//                            .offset(x: -8, y: 0)
//                        }
//                    } else {
//                        // Tappable meal card - opens in sheet (NO CHEVRON)
//                        Button(action: {
//                            selectedMealForViewing = meal
//                        }) {
//                            MealItemView(meal: meal)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
//            }
//
//            if isEditing {
//                Button(action: onAdd) {
//                    HStack(spacing: 6) {
//                        Image(systemName: "plus.circle.fill")
//                            .foregroundColor(Color("primaryAccent"))
//                        Text("Add \(title) Dish")
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("secondaryText"))
//                    }
//                    .padding(.vertical, 8)
//                }
//            }
//        }
//        .sheet(isPresented: $showingTimeEdit) {
//            TimePickerSheet(
//                selectedTime: Binding(
//                    get: { getMealTime() },
//                    set: { newTime in
//                        updateGlobalMealTime(newTime)
//                    }
//                ),
//                mealType: title
//            ) {
//                showingTimeEdit = false
//            }
//        }
//        .sheet(item: $selectedMealForViewing) { meal in
//            RecipeView(meal: meal)
//        }
//    }
//    
//    // Get the meal time from the global viewModel
//    private func getMealTime() -> Date {
//        switch title.lowercased() {
//        case "breakfast":
//            return viewModel.mealTimes.breakfastTime
//        case "lunch":
//            return viewModel.mealTimes.lunchTime
//        case "dinner":
//            return viewModel.mealTimes.dinnerTime
//        default:
//            return Date()
//        }
//    }
//    
//    // Update meal time globally for all days
//    private func updateGlobalMealTime(_ newTime: Date) {
//        let mealType: MealType
//        switch title.lowercased() {
//        case "breakfast":
//            mealType = .breakfast
//        case "lunch":
//            mealType = .lunch
//        case "dinner":
//            mealType = .dinner
//        default:
//            return
//        }
//        
//        viewModel.updateMealTime(newTime, for: mealType)
//    }
//    
//    private func timeString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
//
//// MARK: - Empty Meal Placeholder
//struct EmptyMealPlaceholder: View {
//    let mealType: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "fork.knife")
//                .font(.system(size: 20))
//                .foregroundColor(Color("secondaryText").opacity(0.5))
//            
//            Text("No \(mealType.lowercased()) planned")
//                .font(.system(size: 15))
//                .foregroundColor(Color("secondaryText").opacity(0.7))
//            
//            Spacer()
//        }
//        .padding(12)
//        .background(Color("secondaryButton").opacity(0.2))
//        .cornerRadius(8)
//    }
//}
//
//// MARK: - Time Picker Sheet
//struct TimePickerSheet: View {
//    @Binding var selectedTime: Date
//    let mealType: String
//    let onTimeSelected: () -> Void
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("This will change \(mealType.lowercased()) time for all days")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("secondaryText"))
//                    .padding()
//                
//                DatePicker(
//                    "Select Time",
//                    selection: $selectedTime,
//                    displayedComponents: [.hourAndMinute]
//                )
//                .datePickerStyle(.wheel)
//                .labelsHidden()
//                .padding()
//                
//                Spacer()
//                
//                Button(action: {
//                    onTimeSelected()
//                    dismiss()
//                }) {
//                    Text("Done")
//                        .font(.system(size: 17, weight: .semibold))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color("primaryAccent"))
//                        .cornerRadius(12)
//                }
//                .padding()
//            }
//            .navigationTitle("Set \(mealType) Time")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct MealSectionView: View {
    let title: String
    let meals: [Meal]
    let onEditTapped: () -> Void
    let onAdd: () -> Void
    let onDelete: (Meal) -> Void
    let isEditing: Bool
    let onGotoPantry: () -> Void      // Pantry trigger closure

    @State private var showingTimeEdit = false
    @State private var mealTime: Date = Date()
    @State private var selectedMealForViewing: Meal? = nil
    @StateObject private var viewModel = MealPlannerViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Meal type and time
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("primaryText"))

                    // Time button - changes globally for all days
                    Button(action: {
                        showingTimeEdit.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(timeString(from: getMealTime()))
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(Color("secondaryText"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("secondaryButton").opacity(0.5))
                        .cornerRadius(6)
                    }
                }

                Spacer()

                Button(action: onEditTapped) {
                    Text(!isEditing ? "Edit" : "Done")
                        .foregroundColor(Color("primaryAccent"))
                        .fontWeight(.medium)
                }
            }

            Rectangle()
                .fill(Color("secondaryButton"))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .cornerRadius(100)

            // Show meals or placeholder
            if meals.isEmpty {
                EmptyMealPlaceholder(mealType: title)
            } else {
                ForEach(meals, id: \.id) { meal in // Always use unique .id accessor!
                    if isEditing {
                        ZStack(alignment: .trailing) {
                            MealItemView(meal: meal)
                            Button(action: { onDelete(meal) }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                    .padding(8)
                            }
                            .offset(x: -8, y: 0)
                        }
                    } else {
                        // Tappable meal card - opens in sheet (NO CHEVRON)
                        Button(action: {
                            selectedMealForViewing = meal
                        }) {
                            MealItemView(meal: meal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }

            if isEditing {
                Button(action: onAdd) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("primaryAccent"))
                        Text("Add \(title) Dish")
                            .fontWeight(.medium)
                            .foregroundColor(Color("secondaryText"))
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .sheet(isPresented: $showingTimeEdit) {
            TimePickerSheet(
                selectedTime: Binding(
                    get: { getMealTime() },
                    set: { newTime in
                        updateGlobalMealTime(newTime)
                    }
                ),
                mealType: title
            ) {
                showingTimeEdit = false
            }
        }
        .sheet(item: $selectedMealForViewing) { meal in
            RecipeView(meal: meal, onGotoPantry: onGotoPantry)
        }
    }

    // Get the meal time from the global viewModel
    private func getMealTime() -> Date {
        switch title.lowercased() {
        case "breakfast":
            return viewModel.mealTimes.breakfastTime
        case "lunch":
            return viewModel.mealTimes.lunchTime
        case "dinner":
            return viewModel.mealTimes.dinnerTime
        default:
            return Date()
        }
    }

    // Update meal time globally for all days
    private func updateGlobalMealTime(_ newTime: Date) {
        let mealType: MealType
        switch title.lowercased() {
        case "breakfast":
            mealType = .breakfast
        case "lunch":
            mealType = .lunch
        case "dinner":
            mealType = .dinner
        default:
            return
        }
        viewModel.updateMealTime(newTime, for: mealType)
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Empty Meal Placeholder
struct EmptyMealPlaceholder: View {
    let mealType: String

    var body: some View {
        HStack {
            Image(systemName: "fork.knife")
                .font(.system(size: 20))
                .foregroundColor(Color("secondaryText").opacity(0.5))
            Text("No \(mealType.lowercased()) planned")
                .font(.system(size: 15))
                .foregroundColor(Color("secondaryText").opacity(0.7))
            Spacer()
        }
        .padding(12)
        .background(Color("secondaryButton").opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - Time Picker Sheet
struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    let mealType: String
    let onTimeSelected: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("This will change \(mealType.lowercased()) time for all days")
                    .font(.system(size: 14))
                    .foregroundColor(Color("secondaryText"))
                    .padding()

                DatePicker(
                    "Select Time",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()

                Spacer()

                Button(action: {
                    onTimeSelected()
                    dismiss()
                }) {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primaryAccent"))
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Set \(mealType) Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


// MARK: - Empty Meal Placeholder
//struct EmptyMealPlaceholder: View {
//    let mealType: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: "fork.knife")
//                .font(.system(size: 20))
//                .foregroundColor(Color("secondaryText").opacity(0.5))
//            Text("No \(mealType.lowercased()) planned")
//                .font(.system(size: 15))
//                .foregroundColor(Color("secondaryText").opacity(0.7))
//            Spacer()
//        }
//        .padding(12)
//        .background(Color("secondaryButton").opacity(0.2))
//        .cornerRadius(8)
//    }
//}

// MARK: - Time Picker Sheet
//struct TimePickerSheet: View {
//    @Binding var selectedTime: Date
//    let mealType: String
//    let onTimeSelected: () -> Void
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("This will change \(mealType.lowercased()) time for all days")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("secondaryText"))
//                    .padding()
//                
//                DatePicker(
//                    "Select Time",
//                    selection: $selectedTime,
//                    displayedComponents: [.hourAndMinute]
//                )
//                .datePickerStyle(.wheel)
//                .labelsHidden()
//                .padding()
//                
//                Spacer()
//                
//                Button(action: {
//                    onTimeSelected()
//                    dismiss()
//                }) {
//                    Text("Done")
//                        .font(.system(size: 17, weight: .semibold))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color("primaryAccent"))
//                        .cornerRadius(12)
//                }
//                .padding()
//            }
//            .navigationTitle("Set \(mealType) Time")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}

