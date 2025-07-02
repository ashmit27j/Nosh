import SwiftUI
struct PortionSizeSelector: View {
    @Binding var portionSize: Int

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading) {
                Text("Portion Size")
                    .font(.headline)
                Text("Select the number of people to cook for")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Spacer(minLength: 0)
                HStack {
                    Button(action: {
                        if portionSize > 1 { portionSize -= 1 }
                    }) {
                        Image(systemName: "minus")
                            .frameModifier()
                    }

                    Spacer()
                    Text("\(portionSize)")
                        .font(.title2)
                    Spacer()

                    Button(action: {
                        portionSize += 1
                    }) {
                        Image(systemName: "plus")
                            .frameModifier()
                            
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("secondaryAccent"))
//                            .frameModifier()
                    }
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                Spacer(minLength: 0)
            }
        }
    }
}

extension Image {
    func frameModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .frame(width: 50, height: 50)
            .background(Color("primaryAccent"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
