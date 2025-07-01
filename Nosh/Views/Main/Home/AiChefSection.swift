////import SwiftUI
////// MARK: - AI Chef Section
////
////struct AiChefSection: View {
////    var body: some View {
////        HStack(spacing: 16) {
////            Image("chefImage")
////                .resizable()
////                .scaledToFit()
////                .frame(width: 100, height: 100)
////                .padding(.leading, 4)
////
////            VStack(alignment: .leading, spacing: 8) {
////                Text("Chef Nash")
////                    .font(.headline)
////                    .foregroundColor(.primary)
////
////                Text("Not sure what to cook? Ask your personal chef! ")
////                    .font(.subheadline)
////                    .foregroundColor(.secondary)
////                    .fixedSize(horizontal: false, vertical: true)
////                Spacer(minLength: 2)
////                HStack(spacing: 12) {
////                    Button(action: {}) {
////                        HStack {
////                            Image("cookIcon")
////                                .resizable()
////                                .frame(width: 24, height: 24)
////                                .foregroundColor(.black)
////                            Text("Ask Chef")
////                        }
////                        .frame(maxWidth: .infinity)
////                        .frame(height: 55)
////                        .background(Color("primaryAccent"))
////                        .foregroundColor(.black)
////                        .cornerRadius(14)
////                    }
////
////                    Button(action: {}) {
////                        Image("diceIcon")
////                            .resizable()
////                            .frame(width: 24, height: 24)
////                            .foregroundColor(.black)
////                            
////                    }
////                    .frame(width: 55, height: 55)
////                    .background(Color("primaryAccent"))
////                    .cornerRadius(14)
////                }
////                .frame(maxWidth: .infinity)
////            }
////        }
////        .padding()
////        .background(
////            RoundedRectangle(cornerRadius: 24)
////                .fill(Color(uiColor: .secondarySystemBackground))
//////                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
////        )
////    }
////}
////
////
//import SwiftUI
//
//struct AiChefSection: View {
//    var body: some View {
//        SectionContainer {
//            ZStack(){
//                HStack(spacing: 16) {
//                    Image("chefImage")
//                        .resizable()
//                        .scaledToFit()
//
//                        .frame(maxWidth: 120)
//                        .padding(.leading, 4)
//
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("Chef Nash")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//
//                        Text("Not sure what to cook? Ask your personal chef!")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .fixedSize(horizontal: false, vertical: true)
//
//                        Spacer(minLength: 2)
//
//                        HStack(spacing: 12) {
//                            Button(action: {}) {
//                                HStack {
////                                    Image("cookIcon")
////                                        .resizable()
////                                        .scaledToFit()
////                                        .frame(width: 20, height: 20)
//
//                                    Text("Ask Chef")
//                                        .font(.subheadline)
//                                        .fontWeight(.bold)
//                                    
//                                    Image("triangleIcon")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 20, height: 20)
//                                        .rotationEffect(.degrees(-90))
//                                        .foregroundColor(Color("buttonInner"))
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .frame(height: 55)
//                                .background(Color("primaryAccent"))
//                                .foregroundColor(.black)
//                                .cornerRadius(14)
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                .frame(maxWidth: .infinity)
//                //padding around the entire content inside the card container
//                .padding(0)
//                .background(
//                    RoundedRectangle(cornerRadius: 24)
//                        .fill(Color("primaryCard"))
//                )
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color("primaryCard"))
//        }
//    }
//}

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
                    .foregroundColor(Color("textPrimary"))

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
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("primaryCard"))
        )
        .padding(.horizontal, 20)
    }
}
