import SwiftUI

struct Nosh: View {
    @State private var selectedCategory: String? = "Full Meal"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    CategorySelector(selectedCategory: $selectedCategory)
                    PortionSizeSelector(portionSize: $portionSize)
                    TimeToCookSlider(timeToCook: $timeToCook)
                    DifficultySelector(selectedDifficulty: $selectedDifficulty)
                    CookNowButton()
                }
                .padding(.top)
                .padding(.bottom, 100) // Extra bottom spacing like original
            }
            .navigationTitle("Nosh")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("hi")
                        .opacity(1) // Invisible but still occupies space
                }
            }
            .background(Color("primaryBackground"))
        }
    }
}
