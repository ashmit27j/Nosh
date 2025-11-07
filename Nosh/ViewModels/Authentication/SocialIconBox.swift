//
//  SocialIconBox.swift
//  Nosh
//
//  Created by MacBook on 07/11/25.
//

import SwiftUI

struct SocialIconBox: View {
    var systemImage: String? = nil
    var assetImage: String? = nil
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .background(Color("secondaryButton"))
                    .cornerRadius(12)

                Group {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("primaryText"))
                            .frame(width: 24, height: 24)
                    } else if let assetImage = assetImage {
                        Image(assetImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .frame(height: 75)
        }
        .frame(maxWidth: .infinity)
    }
}
