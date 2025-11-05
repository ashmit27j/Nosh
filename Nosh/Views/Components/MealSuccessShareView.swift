//
//  MealSuccessShareView.swift
//  Nosh
//
//  Created by MacBook on 05/11/25.
//

import SwiftUI

struct MealSuccessShareView: View {
    let meal: Meal
    let dismiss: DismissAction
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var showShareSheet = false
    
    // Links
    let noshAppLink = "https://noshapp.com/download"
    var recipeLink: String {
        "https://noshapp.com/recipe/\(meal.id ?? "unknown")"
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Show chef image only if no captured image
                if capturedImage == nil {
                    Image("chefImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 20)
                }
                
                VStack(spacing: 8) {
                    Text("Recipe Completed!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryText"))
                    
                    Text("Great job making \(meal.name)!")
                        .font(.body)
                        .foregroundColor(Color("secondaryText"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Show captured image if available
                if let image = capturedImage {
                    VStack(spacing: 8) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 180)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        
                        Text("Looking delicious! 🍳")
                            .font(.subheadline)
                            .foregroundColor(Color("secondaryText"))
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        if capturedImage == nil {
                            showCamera = true
                        } else {
                            showShareSheet = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: capturedImage == nil ? "camera.fill" : "square.and.arrow.up")
                            Text(capturedImage == nil ? "Share with Photo" : "Share")
                        }
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("primaryAccent"))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Maybe Later")
                            .font(.headline)
                            .foregroundColor(Color("primaryText"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("secondaryButton").opacity(0.3))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 400)
            .background(Color("primaryCard"))
            .cornerRadius(20)
            .padding(20)
        }
        .sheet(isPresented: $showCamera) {
            CameraView(capturedImage: $capturedImage)
        }
        .sheet(isPresented: $showShareSheet) {
            if let img = capturedImage {
                ActivityViewController(activityItems: [createShareMessage(), img], applicationActivities: nil)
            }
        }
    }
    
    private func createShareMessage() -> String {
        """
        Hey, I just made \(meal.name) using Nosh! 🍳

        📝 Ingredients:
        \(meal.ingredients.map { "• \($0)" }.joined(separator: "\n"))

        ⏱️ Time: \(meal.timeToCook)
        📊 Difficulty: \(meal.difficulty.rawValue)
        🍽️ Servings: \(meal.servingSize)
        \(meal.nutritionalContent.isEmpty ? "" : "💪 Nutrition: \(meal.nutritionalContent)")

        Download now: \(noshAppLink)
        View the recipe: \(recipeLink)
        """
    }
}
