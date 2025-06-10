//
//  LoginSignupView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/7/25.
//

import SwiftUI

struct LoginSignupView: View {
    // Custom color definitions
    let pink = Color(red: 0.91, green: 0.12, blue: 0.39)     // #E91E63
    let tealBlue = Color(red: 0.0, green: 0.59, blue: 0.65)   // #0097A7
    let lightBlue = Color(red: 0.0, green: 0.74, blue: 0.83)  // #00BCD4
    let white = Color.white                                   // #FFFFFF

    // Page switching state
    @State private var showLogin = false
    @State private var showSignup = false

    var body: some View {
        ZStack {
            // 1. Full-screen background
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))

            // 2. Content
            VStack(spacing: 30) {
                Spacer()

                // App logo/title
                Text("HealthBridge")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(white)
                    .shadow(radius: 5)
                    .padding(.bottom, 40)

                // Buttons container
                VStack(spacing: 20) {
                    // Login Button (Pink)
                    Button(action: {
                        showLogin = true
                    }) {
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
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8)

                    // Signup Button (White with Teal border)
                    Button(action: {
                        showSignup = true
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(tealBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(tealBlue, lineWidth: 4)
                            )
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
        .fullScreenCover(isPresented: $showSignup) {
            SignUpView()
        }
    }
}

// Preview
struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}
