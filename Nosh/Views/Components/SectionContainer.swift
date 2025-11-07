import SwiftUI
//
//struct SectionContainer<Content: View>: View {
//    let content: Content
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            content
//        }
//        .padding()
//        .background(Color("primaryCard"))
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .padding(.horizontal)
//    }
//}


struct SectionContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content

    init(spacing: CGFloat = 12, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        .padding()
        .background(Color("primaryCard"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
