//
//  DiceView.swift
//  Nosh
//
//  Created by MacBook on 09/07/25.
//


import SwiftUI

struct DiceView: View {
    let iconName: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 5)) {
                isPressed = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                action()
            }
        }) {
            ZStack {
                // Background Dice Square
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("primaryAccent"))
                    .frame(width: 140, height: 140)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)

                // NOSH Letters
                VStack {
                    Text("N")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryBackground"))
                    Spacer()
                    Text("S")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryBackground"))
                }
                .frame(height: 100)

                HStack {
                    Text("O")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryBackground"))
                    Spacer()
                    Text("H")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("primaryBackground"))
                }
                .frame(width: 100)

                // Central Icon
                Image(iconName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color("primaryBackground"))
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
