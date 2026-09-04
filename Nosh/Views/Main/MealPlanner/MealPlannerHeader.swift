import SwiftUI
//header component for mealplanner page
struct MealPlannerHeader: View {
    @Binding var selectedTab: String
    @ObservedObject var viewModel: MealPlannerViewModel
    var underlineNamespace: Namespace.ID
    @Binding var showingDatePicker: Bool
    let onDateChange: (Date) -> Void
    var onGenerateAIMealPlan: () -> Void
    
    @State private var isGenerating = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }

    var body: some View {
        VStack(spacing: 8) {
            // MARK: - Title and AI Button
            HStack(alignment: .center) {
                Text("Schedule")
                    .font(.largeTitle.bold())
                    .transition(.opacity)

                Spacer()
                
                // AI Generate Button
                Button {
                    isGenerating = true
                    onGenerateAIMealPlan()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isGenerating = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        if isGenerating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("secondaryAccent")))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "sparkles")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundColor(Color("secondaryAccent"))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color("primaryAccent"))
                    .cornerRadius(16)
                }
                .disabled(isGenerating)
            }
            .padding(.top, 0)
            .transition(.opacity)

            // MARK: - Date Display Button (Replaces Search Bar)
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(Color("primaryAccent"))
                    
                    Text(dateFormatter.string(from: viewModel.selectedDate))
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("primaryText"))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color("secondaryText"))
                }
                .padding(12)
                .background(Color("secondaryButton").opacity(0.5))
                .cornerRadius(10)
            }
            .padding(.top, 8)

            // MARK: - Tabs (Synced with viewModel)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(viewModel.tabs) { tab in
                        VStack(spacing: 2) {
                            Button {
                                selectedTab = tab.key
                                viewModel.selectTab(tab)
                            } label: {
                                Text(tab.label)
                                    .fontWeight(selectedTab == tab.key ? .semibold : .regular)
                                    .foregroundColor(selectedTab == tab.key ? .primary : .secondary)
                                    .padding(.top, 10)
                            }

                            Capsule()
                                .frame(height: 3)
                                .foregroundColor(selectedTab == tab.key ? Color("primaryAccent") : .clear)
                                .matchedGeometryEffect(id: "underline", in: underlineNamespace, isSource: selectedTab == tab.key)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding()
        .background(Color("primaryCard"))
        .onChange(of: viewModel.selectedTabKey) { _, newTab in
            selectedTab = newTab
        }
    }
}
