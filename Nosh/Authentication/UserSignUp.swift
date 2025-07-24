import SwiftUI
import FirebaseAuth

struct UserSignUp: View {
    @StateObject var viewModel = UserSignUpViewModel()
    var switchToSignIn: () -> Void
    @State private var showFAQSheet = false
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
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome Aboard!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("primaryText"))

                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(Color("secondaryText"))
                            Button("Sign In", action: switchToSignIn)
                                .foregroundColor(Color("primaryAccent"))
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Email Field
                    FieldContainer(
                        isError: viewModel.errorMessages["email"] != nil,
                        errorMessage: viewModel.errorMessages["email"]
                    ) {
                        HStack {
                            Image(systemName: "envelope").foregroundColor(.gray)
                            TextField("Email", text: $viewModel.email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .foregroundColor(Color("primaryText"))
                        }
                    }


                    // Username Field
                    FieldContainer(
                        isError: viewModel.errorMessages["username"] != nil,
                        errorMessage: viewModel.errorMessages["username"]
                    ) {
                        HStack {
                            Image(systemName: "person.crop.circle").foregroundColor(.gray)
                            TextField("Username", text: $viewModel.username)
                                .autocapitalization(.none)
                                .foregroundColor(Color("primaryText"))
                        }
                    }

                    // Password Field
                    FieldContainer(
                        isError: viewModel.errorMessages["password"] != nil,
                        errorMessage: viewModel.errorMessages["password"]
                    ) {
                        HStack {
                            Image(systemName: "lock").foregroundColor(.gray)
                            if viewModel.showPassword {
                                TextField("Password", text: $viewModel.password)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                            }
                            Button(action: { viewModel.showPassword.toggle() }) {
                                Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(Color("primaryText"))
                    }

                    // Confirm Password Field
                    FieldContainer(
                        isError: viewModel.errorMessages["confirmPassword"] != nil,
                        errorMessage: viewModel.errorMessages["confirmPassword"]
                    ) {
                        HStack {
                            Image(systemName: "lock.rotation").foregroundColor(.gray)
                            if viewModel.showConfirmPassword {
                                TextField("Confirm Password", text: $viewModel.confirmPassword)
                            } else {
                                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            }
                            Button(action: { viewModel.showConfirmPassword.toggle() }) {
                                Image(systemName: viewModel.showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(Color("primaryText"))
                    }


                    // Sign Up Button
                    Button(action: {
                        viewModel.signUpUser()
                    }) {
                        Text("Sign Up")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryAccent"))
                            .cornerRadius(10)
                    }

                    HStack(spacing: 16) {
                        Button("FAQs") { showFAQSheet = true }
                            .bold().font(.subheadline).foregroundColor(Color("primaryText"))
                            .padding(.vertical, 12).frame(maxWidth: .infinity)
                            .background(Color("secondaryButton")).cornerRadius(8)
                        Button("Report A Problem") { showReportSheet = true }
                            .bold().font(.subheadline).foregroundColor(Color("primaryText"))
                            .padding(.vertical, 12).frame(maxWidth: .infinity)
                            .background(Color("secondaryButton")).cornerRadius(8)
                    }

                    DividerWithText(text: "Or Sign Up with")
                    SocialIconsRow()
                }
                .padding()
                .padding(.bottom, 20)
                .background(Color("primaryCard"))
                .cornerRadius(20)
            }
            .padding(0)
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showFAQSheet) {
            FAQSheetView()
        }
        .sheet(isPresented: $showReportSheet) {
            ReportProblemSheetView()
        }
        .navigationBarHidden(true)
    }
}

struct DividerWithText: View {
    let text: String
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
            Text(text)
                .bold()
                .font(.subheadline)
                .foregroundColor(Color("primaryText"))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
}
