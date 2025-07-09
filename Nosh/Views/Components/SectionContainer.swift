//
//  SectionContainer.swift
//  Nosh
//
//  Created by MacBook on 09/07/25.
//


import SwiftUI

struct SectionContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding()
        .background(Color("primaryCard"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
