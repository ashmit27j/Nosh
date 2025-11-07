////
////  groceryPreferencesView.swift
////  Nosh
////
////  Created by MacBook on 21/07/25.
////
//
//import SwiftUI
//
//struct groceryPreferencesView: View {
//    @State private var dietaryPreference = "Both"
//    @State private var maxCookTime = 60.0
//    @State private var defaultServings = 2.0
//    @State private var skillLevel = "Beginner"
//    @State private var excludedIngredients: [String] = []
//    @State private var showingAddIngredient = false
//    @State private var newIngredient = ""
//    
//    let dietaryOptions = ["Vegetarian", "Non-Vegetarian", "Both"]
//    let skillLevels = ["Beginner", "Intermediate", "Advanced"]
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                // Dietary Preferences Section
//                Section {
//                    Picker("Food Preference", selection: $dietaryPreference) {
//                        ForEach(dietaryOptions, id: \.self) { option in
//                            Text(option).tag(option)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                } header: {
//                    Label("Dietary Preference", systemImage: "leaf.fill")
//                } footer: {
//                    Text("Filter recipes based on your dietary needs")
//                }
//                
//                // Cooking Preferences Section
//                Section {
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text("Max Cook Time")
//                            Spacer()
//                            Text("\(Int(maxCookTime)) min")
//                                .foregroundColor(.accentColor)
//                                .fontWeight(.semibold)
//                        }
//                        
//                        Slider(value: $maxCookTime, in: 15...120, step: 5)
//                            .accentColor(.accentColor)
//                    }
//                    
//                    Stepper(value: $defaultServings, in: 1...10, step: 1) {
//                        HStack {
//                            Text("Default Servings")
//                            Spacer()
//                            Text("\(Int(defaultServings))")
//                                .foregroundColor(.accentColor)
//                                .fontWeight(.semibold)
//                        }
//                    }
//                    
//                    Picker("Skill Level", selection: $skillLevel) {
//                        ForEach(skillLevels, id: \.self) { level in
//                            Text(level).tag(level)
//                        }
//                    }
//                } header: {
//                    Label("Cooking Preferences", systemImage: "flame.fill")
//                }
//                
//                // Excluded Ingredients Section
//                Section {
//                    if excludedIngredients.isEmpty {
//                        Text("No excluded ingredients")
//                            .foregroundColor(.secondary)
//                            .font(.subheadline)
//                    } else {
//                        ForEach(excludedIngredients, id: \.self) { ingredient in
//                            HStack {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.red)
//                                Text(ingredient)
//                                Spacer()
//                            }
//                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                Button(role: .destructive) {
//                                    withAnimation {
//                                        excludedIngredients.removeAll { $0 == ingredient }
//                                    }
//                                } label: {
//                                    Label("Delete", systemImage: "trash")
//                                }
//                            }
//                        }
//                    }
//                    
//                    Button(action: { showingAddIngredient = true }) {
//                        Label("Add Ingredient to Exclude", systemImage: "plus.circle.fill")
//                            .foregroundColor(.accentColor)
//                    }
//                } header: {
//                    Label("Excluded Ingredients", systemImage: "allergens")
//                } footer: {
//                    Text("Recipes containing these ingredients will be filtered out")
//                }
//                
//                // Meal Category Preferences
//                Section {
//                    NavigationLink {
//                        MealCategoryPreferencesView()
//                    } label: {
//                        Label("Meal Categories", systemImage: "square.grid.2x2")
//                    }
//                    
//                    NavigationLink {
//                        Text("Cuisine preferences")
//                    } label: {
//                        Label("Cuisine Preferences", systemImage: "globe")
//                    }
//                } header: {
//                    Label("Additional Filters", systemImage: "slider.horizontal.3")
//                }
//            }
//            .navigationTitle("Grocery Preferences")
//            .alert("Add Ingredient", isPresented: $showingAddIngredient) {
//                TextField("Ingredient name", text: $newIngredient)
//                Button("Cancel", role: .cancel) {
//                    newIngredient = ""
//                }
//                Button("Add") {
//                    if !newIngredient.isEmpty {
//                        excludedIngredients.append(newIngredient)
//                        newIngredient = ""
//                    }
//                }
//            } message: {
//                Text("Enter an ingredient you want to exclude from recipes")
//            }
//        }
//    }
//}
//
//struct MealCategoryPreferencesView: View {
//    @State private var categories = [
//        CategoryPreference(name: "Full Meal", isEnabled: true),
//        CategoryPreference(name: "Breakfast", isEnabled: true),
//        CategoryPreference(name: "Lunch", isEnabled: true),
//        CategoryPreference(name: "Dinner", isEnabled: true),
//        CategoryPreference(name: "Snacks", isEnabled: false),
//        CategoryPreference(name: "Desserts", isEnabled: true),
//        CategoryPreference(name: "Beverages", isEnabled: false)
//    ]
//    
//    var body: some View {
//        List {
//            ForEach($categories) { $category in
//                Toggle(isOn: $category.isEnabled) {
//                    HStack {
//                        Image(systemName: categoryIcon(for: category.name))
//                            .foregroundColor(category.isEnabled ? .accentColor : .gray)
//                            .frame(width: 24)
//                        Text(category.name)
//                    }
//                }
//                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
//            }
//        }
//        .navigationTitle("Meal Categories")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//    
//    private func categoryIcon(for name: String) -> String {
//        switch name {
//        case "Full Meal": return "fork.knife"
//        case "Breakfast": return "sun.horizon.fill"
//        case "Lunch": return "sun.max.fill"
//        case "Dinner": return "moon.stars.fill"
//        case "Snacks": return "cup.and.saucer.fill"
//        case "Desserts": return "birthday.cake.fill"
//        case "Beverages": return "mug.fill"
//        default: return "circle.fill"
//        }
//    }
//}
//
//struct CategoryPreference: Identifiable {
//    let id = UUID()
//    var name: String
//    var isEnabled: Bool
//}
//
//#Preview {
//    groceryPreferencesView()
//}
