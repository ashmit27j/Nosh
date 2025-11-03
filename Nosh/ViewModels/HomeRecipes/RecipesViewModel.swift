//
//  RecipesViewModel.swift
//  Nosh
//
//  Created by MacBook on 02/11/25.
//


import SwiftUI
import FirebaseFirestore

class RecipesViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading = false
    
    func fetchMeals(categories: [String]) {
        isLoading = true
        
        let db = Firestore.firestore()
        
        db.collection("recipes")
            .whereField("category", in: categories)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("Error fetching meals: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.meals = []
                        return
                    }
                    
                    self.meals = documents.compactMap { doc in
                        try? doc.data(as: Meal.self)
                    }
                    
                    print("✅ Fetched \(self.meals.count) meals for categories: \(categories)")
                }
            }
    }
}
