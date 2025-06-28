//
//  HomeButtons.swift
//  Nosh
//
//  Created by MacBook on 29/06/25.
//

import SwiftUI

// MARK: - Home Buttons Section
struct HomeButtons: View {
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {}) {
                Label("Recipes", systemImage: "book")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Button(action: {}) {
                Label("AI Chef", systemImage: "person.crop.square.filled.and.at.rectangle")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
