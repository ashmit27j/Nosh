import SwiftUI

struct UserSignUp: View {
    @StateObject private var viewModel = UserSignUpViewModel()
    var switchToSignIn: () -> Void
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
                        // Header
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Welcome Aboard!")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color("primaryText"))

                            HStack {
                                Text("Already have an account?")
                                    .foregroundColor(Color("secondaryText"))
                                
                                Button(action: {
                                    switchToSignIn()  // This comes from AuthFlowView
                                }) {
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
                        
                        // MARK: All the buttons and other options
                        HStack(spacing: 16) {
                            // Forgot Password Button
                            Button(action: {
                                // viewModel.sendPasswordReset()
                            }) {
                                Text("FAQs")
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
                            Text("Or Sign Up with")
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
                }
                .padding(0)
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
        }
    }


