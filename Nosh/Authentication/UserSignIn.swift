import SwiftUI
import FirebaseAuth

struct UserSignIn: View {
    @ObservedObject var viewModel = UserSignInViewModel()
    var switchToSignUp: () -> Void  // <-- Accept closure

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("gradientStart"), Color("gradientEnd")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 24) {
                    VStack(spacing: 10) {
                        Text("Sign In")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("primaryText"))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(Color("secondaryText"))
                            Button(action: {
                                switchToSignUp()
                            }) {
                                Text("Sign Up")
                                    .foregroundColor(Color("primaryAccent"))
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    FieldContainer {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email", text: $viewModel.email)
                                .foregroundColor(Color("primaryText"))
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                    }

                    FieldContainer {
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(Color("primaryText"))
                        }
                    }

                    Button(action: {
                        viewModel.signInUser()
                    }) {
                        Text("Login")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryAccent"))
                            .cornerRadius(10)
                    }

                    // Optional: Forgot Password / Report A Problem...
                }
                .padding()
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
                .cornerRadius(20)
            }
        }
        .navigationBarHidden(true)
    }
}


// MARK: - Social Login Button
struct SocialIconBox: View {
    var systemImage: String? = nil
    var assetImage: String? = nil

    var body: some View {
        Button(action: {
            print("\(systemImage ?? assetImage ?? "") tapped")
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .background(Color.white)
                    .cornerRadius(12)

                Group {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    } else if let assetImage = assetImage {
                        Image(assetImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
                .foregroundColor(.black)
            }
            .frame(height: 75)
        }
        .frame(maxWidth: .infinity)
    }
}


// MARK: - Field Container
struct FieldContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding()
            .background(Color("secondaryButton"))
            .cornerRadius(12)
    }
}

// MARK: - Social Icon Button
struct SocialIconButton: View {
    let imageName: String
    let isSystemImage: Bool

    var body: some View {
        Button(action: {
            print("\(imageName) tapped")
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                if isSystemImage {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 22, height: 22)
                } else {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }
            }
        }
    }
}


//import SwiftUI
//import FirebaseAuth
//
//struct UserSignIn: View {
//    @ObservedObject var viewModel = SignInEmailViewModel()
//    var switchToSignUp: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Sign In").font(.title)
//            
//            TextField("Email", text: $viewModel.email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .autocapitalization(.none)
//
//            SecureField("Password", text: $viewModel.password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//            Button("Sign In") {
//                viewModel.signInUser()
//            }
//
//            Button("Forgot Password?") {
////                viewModel.sendPasswordReset()
//            }
//            .foregroundColor(.blue)
//
//            Button("Don't have an account? Sign Up") {
//                switchToSignUp()
//            }
//            .foregroundColor(.blue)
//        }
//        .padding()
//    }
//}
//
//
//// MARK: - Social Login Button
//struct SocialIconBox: View {
//    var systemImage: String? = nil
//    var assetImage: String? = nil
//
//    var body: some View {
//        Button(action: {
//            print("\(systemImage ?? assetImage ?? "") tapped")
//        }) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    .background(Color.white)
//                    .cornerRadius(12)
//
//                Group {
//                    if let systemImage = systemImage {
//                        Image(systemName: systemImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                    } else if let assetImage = assetImage {
//                        Image(assetImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                    }
//                }
//                .foregroundColor(.black)
//            }
//            .frame(height: 75)
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//
//// MARK: - Field Container
//struct FieldContainer<Content: View>: View {
//    @ViewBuilder let content: () -> Content
//
//    var body: some View {
//        content()
//            .padding()
//            .background(Color("secondaryButton"))
//            .cornerRadius(12)
//    }
//}
//
//// MARK: - Social Icon Button
//struct SocialIconButton: View {
//    let imageName: String
//    let isSystemImage: Bool
//
//    var body: some View {
//        Button(action: {
//            print("\(imageName) tapped")
//        }) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.white)
//                    .frame(width: 50, height: 50)
//                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
//
//                if isSystemImage {
//                    Image(systemName: imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.black)
//                        .frame(width: 22, height: 22)
//                } else {
//                    Image(imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22, height: 22)
//                }
//            }
//        }
//    }
//}
