//
//  OnboardingView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/6/25.
//

import SwiftUI

struct OnboardingView: View {
    private let images = ["splash 1", "splash 2", "splash 3"]
    @State private var currentPage = 0
    @State private var showLoginSignup = false // Renamed to reflect new destination
    @State private var timer: Timer?
    
    var body: some View {
        Group {
            if showLoginSignup {
                LoginSignupView() // Changed to your LoginSignupView
                    .transition(.opacity)
            } else {
                TabView(selection: $currentPage) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .onChange(of: currentPage) { newValue in
                    resetTimer(for: newValue)
                }
                .onAppear {
                    startTimerIfNeeded()
                }
            }
        }
    }
    
    private func resetTimer(for page: Int) {
        timer?.invalidate()
        if page == images.count - 1 {
            startTimerIfNeeded()
        }
    }
    
    private func startTimerIfNeeded() {
        guard currentPage == images.count - 1 else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            DispatchQueue.main.async {
                withAnimation {
                    showLoginSignup = true // Updated to match new state variable
                }
            }
        }
    }
}
