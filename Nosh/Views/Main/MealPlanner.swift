import SwiftUI

struct MealPlanner: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<30) { i in
                        Text("Item \(i)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}





//#Preview {
//    MealPlanner()
//}

