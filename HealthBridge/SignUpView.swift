//
//  SignUpView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya on 5/8/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    let tealBlue = Color(red: 0.0, green: 0.59, blue: 0.65)
    let pink = Color(red: 0.91, green: 0.12, blue: 0.39)
    let white = Color.white
    let lightGray = Color(white: 0.95)

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @FocusState private var focusedField: Field?
    @State private var isAuthenticated = false

    @State private var showPassword = false
    @State private var showConfirmPassword = false

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var showLogin = false

    @State private var appleSignInDelegates: SignInWithAppleDelegates? = nil
    @StateObject private var userManager = UserManager.shared

    enum Field: Hashable {
        case fullName, email, password, confirmPassword
    }

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))

            ScrollView {
                VStack(spacing: 15) {
                    Spacer()

                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(white)
                            .shadow(radius: 5)

                        Text("HealthBridge")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(white)
                            .shadow(radius: 3)

                        Text("Create your account")
                            .font(.title3)
                            .foregroundColor(white)
                            .padding(.top, 5)
                    }

                    VStack(spacing: 20) {
                        TextField("Full Name", text: $fullName)
                            .focused($focusedField, equals: .fullName)
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .fullName ? pink : tealBlue, lineWidth: 4)
                                    .background(lightGray.cornerRadius(10))
                            )
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }

                        TextField("Email", text: $email)
                            .focused($focusedField, equals: .email)
                            .padding()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .email ? pink : tealBlue, lineWidth: 4)
                                    .background(lightGray.cornerRadius(10))
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }

                        ZStack(alignment: .trailing) {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .focused($focusedField, equals: .password)
                            } else {
                                SecureField("Password", text: $password)
                                    .focused($focusedField, equals: .password)
                            }

                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedField == .password ? pink : tealBlue, lineWidth: 4)
                                .background(lightGray.cornerRadius(10))
                        )
                        .submitLabel(.next)
                        .onSubmit { focusedField = .confirmPassword }

                        ZStack(alignment: .trailing) {
                            if showConfirmPassword {
                                TextField("Confirm Password", text: $confirmPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                            } else {
                                SecureField("Confirm Password", text: $confirmPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                            }

                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedField == .confirmPassword ? pink : tealBlue, lineWidth: 4)
                                .background(lightGray.cornerRadius(10))
                        )
                        .submitLabel(.done)

                        HStack {
                            Button(action: {
                                agreeToTerms.toggle()
                            }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(agreeToTerms ? pink : white)
                                    .font(.title2)
                            }

                            HStack {
                                Text("I agree to the")
                                    .foregroundColor(white)
                                Button("Terms & Conditions") {
                                    // Show terms sheet
                                }
                                .foregroundColor(tealBlue)
                            }
                            .font(.subheadline.weight(.bold))
                        }
                    }
                    .padding(.horizontal, 30)

                    Button(action: handleSignup) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(pink)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(white, lineWidth: 4)
                            )
                            .shadow(radius: 20)
                    }
                    .padding(.horizontal, 30)

                    VStack(spacing: 15) {
                        HStack {
                            VStack { Divider().background(white) }
                            Text("OR")
                                .foregroundColor(white)
                                .font(.subheadline.weight(.bold))
                                .padding(.horizontal, 10)
                            VStack { Divider().background(white) }
                        }

                        HStack(spacing: 20) {
                            Button(action: performAppleSignIn) {
                                Image(systemName: "applelogo")
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(white)
                                    .foregroundColor(.black)
                                    .clipShape(Circle())
                            }

                            Button(action: handleGoogleSignIn) {
                                Image("google")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                                    .background(white)
                                    .clipShape(Circle())
                            }

                            Button(action: handleFacebookSignIn) {
                                Image("facebook")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                                    .background(white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)

                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(white)
                            .font(.subheadline.weight(.bold))

                        Button(action: {
                            showLogin = true
                        }) {
                            Text("Login")
                                .foregroundColor(tealBlue)
                                .font(.subheadline.weight(.bold))
                        }
                    }

                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
                .padding(.vertical, 10)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            focusedField = nil
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }

    private func performAppleSignIn() { }
    private func handleAppleSignInSuccess(userIdentifier: String, fullName: PersonNameComponents?, email: String?) { }
    private func handleSignup() { }
    private func clearForm() { }
    private func handleGoogleSignIn() {
        showAlert(title: "Coming Soon", message: "Google Sign In will be available in the next update")
    }
    private func handleFacebookSignIn() {
        showAlert(title: "Coming Soon", message: "Facebook Sign In will be available in the next update")
    }
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
