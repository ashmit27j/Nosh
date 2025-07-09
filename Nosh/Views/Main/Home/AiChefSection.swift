import SwiftUI

struct AiChefSection: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("chefImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 120)
                .padding(.leading, 4)

            VStack(alignment: .leading, spacing: 8) {
                Text("Chef Nash")
                    .font(.headline)
                    .foregroundColor(Color("primaryText"))

                Text("Not sure what to cook? Ask your personal chef!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 2)

                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Text("Ask Chef")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("secondaryAccent"))

                            Image("triangleIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(-90))
                                .foregroundColor(Color("secondaryAccent"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(height: 55)
                        .background(Color("primaryAccent"))
                        .foregroundColor(.black)
                        .cornerRadius(14)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("primaryCard"))
        )
//        .padding(.horizontal, 20)
    }
}
