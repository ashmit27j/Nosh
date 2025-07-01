//
//  MealCard.swift
//  Nosh
//
//  Created by MacBook on 01/07/25.
//


import SwiftUI

struct MealCard: View {
    let meal: MealItem

    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Meal Image
            Image(meal.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(12)

            // MARK: - Meal Info
            VStack(alignment: .leading, spacing: 6) {
                Text(meal.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)

                Text("\(meal.cookTime) mins | \(meal.servingSize) servings")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: - CTA Button
            Button(action: {
                print("Cook now tapped for \(meal.name)")
            }) {
                Image("triangleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(-90))
                    .padding()
                    .foregroundColor(Color("secondaryAccent"))
                    .background(Color("primaryAccent"))
                    .clipShape(Circle()) 
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
