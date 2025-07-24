import SwiftUI
import FirebaseAuth

struct UserSignIn: View {
    @StateObject var viewModel = UserSignInViewModel()
    var switchToSignUp: () -> Void
    @State private var showReportSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 195/255, green: 255/255, blue: 0),
                    Color(red: 64/255, green: 162/255, blue: 0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 24) {
                    VStack(spacing: 10) {
                        Text("Welcome Back!")
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

                    FieldContainer(
                        isError: viewModel.errorMessage == "Please enter a valid email.",
                        errorMessage: viewModel.errorMessage == "Please enter a valid email." ? viewModel.errorMessage : nil
                    ) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            TextField("Email", text: $viewModel.email)
                                .foregroundColor(Color("primaryText"))
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                        }
                    }

                    FieldContainer(
                        isError: viewModel.errorMessage == "Password cannot be empty.",
                        errorMessage: viewModel.errorMessage == "Password cannot be empty." ? viewModel.errorMessage : nil
                    ) {
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            if viewModel.showPassword {
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                            }
                            Button(action: {
                                viewModel.showPassword.toggle()
                            }) {
                                Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(Color("primaryText"))
                    }

                    CTAButton(title: "Sign In") {
                        Task {
                            await viewModel.signInUser()
                        }
                    }

                    HStack(spacing: 16) {
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(Color("primaryText"))
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color("secondaryButton"))
                                .cornerRadius(8)
                        }

                        Button(action: {
                            showReportSheet = true
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

                    DividerWithText(text: "Or Sign In with")
                    SocialIconsRow()
                }
                .padding()
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
                .cornerRadius(20)
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showReportSheet) {
            ReportProblemSheetView()
        }
        .navigationBarHidden(true)
    }
}

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

struct FieldContainer<Content: View>: View {
    let isError: Bool
    let errorMessage: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            content()
                .padding()
                .background(Color("secondaryButton"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isError ? Color.red : Color.clear, lineWidth: 2)
                )
                .cornerRadius(12)
            if let msg = errorMessage, isError {
                Text(msg)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}

struct SocialIconsRow: View {
    var body: some View {
        HStack(spacing: 16) {
            SocialIconBox(assetImage: "googleIcon")
            SocialIconBox(systemImage: "apple.logo")
            SocialIconBox(systemImage: "phone.fill")
        }
    }
}
