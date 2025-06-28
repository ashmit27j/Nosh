//
//  UpcomingMealsSection.swift
//  Nosh
//
//  Created by MacBook on 29/06/25.
//

import SwiftUI

// MARK: - Upcoming Meals Section
struct UpcomingMealsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming meals")
                .font(.title2.bold())

            Text("Here are upcoming meals / No upcoming schedule one")
                .font(.subheadline)
                .foregroundColor(.gray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        UpcomingMealCard(imageName: "pancakes", title: "Item Name")
                            .transition(.scale)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: index)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
