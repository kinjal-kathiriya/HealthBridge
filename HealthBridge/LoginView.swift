//
//  LoginView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya on 5/7/25.
//

//  LoginView.swift
//  HealthBridge

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    let tealBlue = Color(red: 0.0, green: 0.59, blue: 0.65)
    let pink = Color(red: 0.91, green: 0.12, blue: 0.39)
    let white = Color.white
    let lightGray = Color(white: 0.95)

    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @FocusState private var focusedField: Field?
    @State private var isAuthenticated = false
    @State private var showSymptomScreen = false

    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @StateObject private var userManager = UserManager.shared

    enum Field {
        case email, password
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
                VStack(spacing: 20) {
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
                    }

                    VStack(spacing: 20) {
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

                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                            .padding()
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .password ? pink : tealBlue, lineWidth: 4)
                                    .background(lightGray.cornerRadius(10))
                            )
                            .submitLabel(.done)
                            .onSubmit { handleLogin() }

                        Toggle("Remember me", isOn: $rememberMe)
                            .toggleStyle(SwitchToggleStyle(tint: pink))
                            .foregroundColor(white)
                            .font(.subheadline.weight(.bold))
                            .padding(.top, -5)
                    }
                    .padding(.horizontal, 30)

                    Button(action: handleLogin) {
                        Text("Login")
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

                    VStack(spacing: 20) {
                        HStack {
                            VStack { Divider().background(white) }
                            Text("OR")
                                .foregroundColor(white)
                                .font(.subheadline.weight(.bold))
                                .padding(.horizontal, 10)
                            VStack { Divider().background(white) }
                        }

                        HStack(spacing: 20) {
                            Button(action: handleAppleSignIn) {
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
                        Button("Forgot Password?") {
                            showForgotPasswordAlert()
                        }
                        .foregroundColor(white)
                        .font(.subheadline.weight(.bold))

                        Spacer()

                        Button("Create Account") {
                            showAlert(title: "Navigation Removed", message: "This would navigate to SignUpView in original app.")
                        }
                        .foregroundColor(tealBlue)
                        .font(.subheadline.weight(.bold))
                    }
                    .padding(.horizontal, 30)

                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
                .padding(.vertical, 40)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            focusedField = nil
        }
        .fullScreenCover(isPresented: $showSymptomScreen) {
            HealthDetectionView()
        }
    }

    private func handleLogin() {
        guard !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address")
            return
        }

        guard !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password")
            return
        }

        if userManager.validateLogin(email: email, password: password) {
            if let user = userManager.getUser(by: email) {
                print("Welcome back, \(user.fullName)!")
            }

            focusedField = nil
            isAuthenticated = true
            showSymptomScreen = true
        } else {
            if userManager.userExists(email: email) {
                showAlert(title: "Invalid Password", message: "The password you entered is incorrect. Please try again.")
            } else {
                showAlert(title: "Account Not Found", message: "No account found with this email address. Please create an account first or check your email.")
            }
        }
    }

    private func showForgotPasswordAlert() {
        guard !email.isEmpty else {
            showAlert(title: "Enter Email", message: "Please enter your email address first, then tap 'Forgot Password?'")
            return
        }

        if userManager.userExists(email: email) {
            showAlert(title: "Password Reset", message: "Password reset functionality will be available in the next update.")
        } else {
            showAlert(title: "Account Not Found", message: "No account found with this email address.")
        }
    }

    private func handleAppleSignIn() {
        showAlert(title: "Coming Soon", message: "Apple Sign In will be available in the next update")
    }

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
