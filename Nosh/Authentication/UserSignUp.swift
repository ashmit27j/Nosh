import SwiftUI

struct UserSignUp: View {
    @StateObject private var viewModel = SignUpEmailViewModel()

    var body: some View {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color("gradientStart"), Color("gradientEnd")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sign Up")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color("primaryText"))

                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(Color("secondaryText"))
                                NavigationLink(destination: UserSignIn()) {
                                    Text("Sign In")
                                        .foregroundColor(Color("primaryAccent"))
                                        .bold()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Email Field
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

                        // Password Field
                        FieldContainer {
                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(.gray)
                                SecureField("Password", text: $viewModel.password)
                                    .foregroundColor(Color("primaryText"))
                            }
                        }

                        // Confirm Password Field
                        FieldContainer {
                            HStack {
                                Image(systemName: "lock.rotation")
                                    .foregroundColor(.gray)
                                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                    .foregroundColor(Color("primaryText"))
                            }
                        }

                        // Sign Up Button
                        Button(action: {
                            viewModel.createAccount()
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

                        // Optional: Social login or other buttons (copy from SignIn if needed)
                    }
                    .padding()
                    .padding(.bottom, 20)
                    .background(Color("primaryCard"))
                    .cornerRadius(20)
                }
                .padding(0)
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
        }
    }


