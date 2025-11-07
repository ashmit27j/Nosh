import SwiftUI
import Foundation

struct MealPlanner: View {
    @State private var selectedTab = "Mon"
    @State private var showCollapsedTitle = false
    @State private var showingDatePicker = false

    @Namespace private var underlineNamespace
    @ObservedObject var viewModel: MealPlannerViewModel

    let onGotoPantry: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MealPlannerHeader(
                    selectedTab: $selectedTab,
                    viewModel: viewModel,
                    underlineNamespace: underlineNamespace,
                    showingDatePicker: $showingDatePicker,
                    onDateChange: { newDate in
                        viewModel.changeDate(to: newDate)
                    },
                    onGenerateAIMealPlan: {
                        generateAIMealPlan()
                    }
                )

                MealListView(
                    viewModel: viewModel,
                    selectedTab: selectedTab,
                    onGotoPantry: onGotoPantry
                )
                .padding(.top, 10)
                .padding(.bottom, 0)
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showCollapsedTitle = offset < -20
                    }
                }
                Spacer(minLength: 80)
            }
            .background(Color("primaryBackground"))
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $viewModel.selectedDate) { newDate in
                    viewModel.changeDate(to: newDate)
                    showingDatePicker = false
                }
            }
            .onAppear {
                selectedTab = viewModel.selectedTab
            }
            .onChange(of: viewModel.selectedTab) { newTab in
                selectedTab = newTab
            }
        }
    }

    private func generateAIMealPlan() {
        Task {
            do {
                try await viewModel.generateAIMealPlan()
            } catch {
                print("❌ Error generating meal plan: \(error)")
            }
        }
    }
}


struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
                
                Button(action: {
                    onDateSelected(selectedDate)
                }) {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primaryAccent"))
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Select Any Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
