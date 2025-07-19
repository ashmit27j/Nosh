import SwiftUI
import SwiftUI
import FirebaseAuth

struct UserSignIn: View {
    @ObservedObject var viewModel = UserSignInViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color("gradientStart"), Color("gradientEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // MARK: - Card at Bottom
                VStack {
                    Spacer()

                    VStack(spacing: 24) {
                        VStack(spacing: 10) {
                            // MARK: - Header
                            Text("Sign In")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color("primaryText"))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // MARK: - Sign Up Prompt
                            HStack {
                                Text("Don't have an account?")
                                    .foregroundColor(Color("secondaryText"))
                                NavigationLink(destination: UserSignUp()) {
                                    Text("Sign Up")
                                        .foregroundColor(Color("primaryAccent"))
                                        .bold()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // MARK: - Email Field
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

                        // MARK: - Password Field
                        FieldContainer {
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                SecureField("Password", text: $viewModel.password)
                                    .foregroundColor(Color("primaryText"))
                            }
                        }
                        
                        // MARK: - Login Button
                        Button(action: {
                            // Sign-in logic
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
                        
                        HStack(spacing: 20) {
                            // Forgot Password Button
                            Button(action: {
//                                viewModel.sendPasswordReset()
                            }) {
                                Text("Forgot Password?")
                                    .bold()
                                    .font(.subheadline)
                                    .foregroundColor(Color("primaryText"))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity) // Apply inside label
                                    .background(Color("secondaryButton"))
                                    .cornerRadius(8)
                            }

                            // Report a Problem Button
                            Button(action: {
//                                viewModel.sendPasswordReset()
                            }) {
                                Text("Report A Problem")
                                    .bold()
                                    .font(.subheadline)
                                    .foregroundColor(Color("primaryText"))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity) // Apply inside label
                                    .background(Color("secondaryButton"))
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        // MARK: - Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.3))
                            Text("Or Sign In with")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(Color("primaryText"))
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.3))
                        }

                        // MARK: - Social Icons
                        HStack(spacing: 16) {
                            SocialIconBox(assetImage: "googleIcon")
                            SocialIconBox(systemImage: "apple.logo")
                            SocialIconBox(systemImage: "phone.fill")
                        }
                        
                        // Divider
//                        Rectangle()
//                            .frame(height: 1)
//                            .foregroundColor(.gray.opacity(0.3))
//                        
                        

                    }
                    .padding()
                    .padding(.bottom, 20)
                    .background(Color("primaryCard"))
                    .cornerRadius(20)
                }
                .padding(0)
                .ignoresSafeArea()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.49, green: 0.95, blue: 0.20), // light green (similar to the leaf)
                            Color(red: 0.00, green: 0.25, blue: 0.25)  // dark teal background
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                )

            }
            .navigationBarHidden(true)
        }
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
