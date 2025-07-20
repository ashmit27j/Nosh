//
//  RootView.swift
//  Nosh
//
//  Created by MacBook on 20/07/25.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.showSplash {
            SplashScreen()
        } else {
            if appState.isUserSignedIn {
                MainTabView()
            } else {
                AuthFlowView()
            }
        }
    }
}
