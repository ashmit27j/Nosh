//
//  Recipe.swift
//  Meal Planner
//
//  Created by MacBook on 19/06/25.
//

import Foundation

// MARK: - Recipe Model
public struct Recipe: Identifiable {
    public let id = UUID()
    public let name: String
    public let type: String
}
