import SwiftUI

struct TimeToCookSlider: View {
    @Binding var timeToCook: Double

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Time to Cook")
                        .font(.headline)
                    Text("Select the amount of preparation time")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    Text("\(Int(timeToCook)) min")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)

                    Slider(value: $timeToCook, in: 10...120, step: 5) // ← Changed to 10-120
                        .accentColor(Color("primaryAccent"))

                    HStack {
                        Text("10")
                        Spacer()
                        Text("120")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
        }
    }
}
