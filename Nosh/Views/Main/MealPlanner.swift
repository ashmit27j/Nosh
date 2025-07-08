import SwiftUI
import Foundation

struct MealPlanner: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var selectedTab = "Mon"
    @State private var showCollapsedTitle = false

    @Namespace private var underlineNamespace
    @StateObject var viewModel: MealPlannerViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MealPlannerHeader(
                    searchText: $searchText,
                    isEditing: $isEditing,
                    selectedTab: $selectedTab,
                    tabs: viewModel.tabs,
                    underlineNamespace: underlineNamespace
                )

                MealListView(viewModel: viewModel, selectedTab: selectedTab)
                    .padding(.top, 10)
                    .padding(.bottom, 0)
                    .onPreferenceChange(ScrollOffsetKey.self) { offset in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showCollapsedTitle = offset < -20
                        }
                    }
            }
            .background(Color("primaryBackground"))
        }
//        .navigationBarBackButtonHidden(true) // 🔕 hide default back
//        .navigationBarTitleDisplayMode(.inline) // optional
//        .toolbar(.hidden) // optional: hide entire nav bar if needed
    }
}

