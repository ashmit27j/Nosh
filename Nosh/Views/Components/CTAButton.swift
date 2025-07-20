//
//  CTAButton.swift
//  Nosh
//
//  Created by MacBook on 20/07/25.
//


import SwiftUI

struct CTAButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .bold()
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("primaryAccent"))
                .cornerRadius(10)
        }
    }
}
