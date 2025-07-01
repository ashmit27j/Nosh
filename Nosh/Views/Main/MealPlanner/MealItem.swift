//
//  MealItem.swift
//  Nosh
//
//  Created by MacBook on 01/07/25.
//

import Foundation
struct MealItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var imageName: String
    var cookTime: Int
    var servingSize: Int
    var isAvailableInPantry: Bool
}
