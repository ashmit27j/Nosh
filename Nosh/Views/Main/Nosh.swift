import SwiftUI

struct Nosh: View {
    @State private var selectedCategory: String? = "Full Meal"
    @State private var portionSize: Int = 1
    @State private var timeToCook: Double = 45
    @State private var selectedDifficulty: String? = "Beginner"

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Scrollable content behind the header
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Add top spacer equal to header height to avoid overlap
                        Color.clear.frame(height: 72)

                        CategorySelector(selectedCategory: $selectedCategory)
                        PortionSizeSelector(portionSize: $portionSize)
                        TimeToCookSlider(timeToCook: $timeToCook)
                        DifficultySelector(selectedDifficulty: $selectedDifficulty)
                        CookNowButton()
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 56)
                }
                .background(Color("primaryBackground"))
                .ignoresSafeArea(edges: .top)
                NoshHeader
            }
        }
    }
}

private var NoshHeader: some View {
    // MARK: - Title and Calendar Button
    HStack(alignment: .center) {
        Text("Nosh")
            .font(.largeTitle.bold())
            .transition(.opacity)

        Spacer()

        Button {
            print("AI Schedule generator tapped")
        } label: {
            HStack(spacing: 8) {
                Image("cookIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color("secondaryAccent"))
                
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color("primaryAccent"))
            .cornerRadius(16)
        }
    }
    .padding(.horizontal)
    .padding(.vertical, 20)
    .frame(maxWidth: .infinity, alignment: .top)
    .background(Color("primaryCard"))
}
