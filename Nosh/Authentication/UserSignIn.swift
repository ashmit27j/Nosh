import SwiftUI
import FirebaseAuth

struct UserSignIn: View {
    @ObservedObject var viewModel = UserSignInViewModel()
    var switchToSignUp: () -> Void  // <-- Accept closure

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 195/255, green: 255/255, blue: 0/255),
                    Color(red: 64/255, green: 162/255, blue: 0/255)
                ]),
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
                        Text("Sign In")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryAccent"))
                            .cornerRadius(10)
                    }

                    HStack(spacing: 16) {
                        // Forgot Password Button
                        Button(action: {
                            // viewModel.sendPasswordReset()
                        }) {
                            Text("Forgot Password?")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(Color("primaryText"))
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color("secondaryButton"))
                                .cornerRadius(8)
                        }

                        // Report a Problem Button
                        Button(action: {
                            // viewModel.sendPasswordReset()
                        }) {
                            Text("Report A Problem")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(Color("primaryText"))
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color("secondaryButton"))
                                .cornerRadius(8)
                        }
                    }

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
                }
                .padding()
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
                .cornerRadius(20)
//                .padding(.horizontal)
            }
            //here
            .ignoresSafeArea()
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
                    .background(Color("secondaryButton"))
                    .cornerRadius(12)

                Group {
                    if let systemImage = systemImage {
                        Image(systemName: systemImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("primaryText"))
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
