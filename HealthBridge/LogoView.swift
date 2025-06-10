//
//  LogoView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/6/25.
//


import SwiftUI

struct LogoView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            // Background
            Color("BrandBlue")
                .ignoresSafeArea()
            
            // Logo and App Name
            VStack(spacing: 20) {
                Image("HealthBridge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
                
                Text("HealthBridge AI")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
        }
        .onAppear {
            // Auto-navigate after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            OnboardingView() // Next screen (replace with LoginView if needed)
        }
    }
}

// Preview Provider
struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .previewDisplayName("Light Mode")
        
        LogoView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}


