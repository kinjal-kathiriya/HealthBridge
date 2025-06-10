//
//  CategoryDetailView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//
import SwiftUI

struct CategoryDetailView: View {
    let category: HealthCategory
    @State private var showBookingSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Category Icon and Title
                VStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(category.color)
                        .clipShape(Circle())
                        .shadow(radius: 8)

                    Text(category.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.tealBlue)

                    Text(category.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Divider()

                // Info Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("What this category covers:")
                        .font(.headline)
                        .foregroundColor(.tealBlue)

                    ForEach(sampleDetails(for: category.name), id: \.self) { point in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(point)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)

                Divider()

                // Booking Button
                VStack(spacing: 12) {
                    Text("Need personalized help?")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Button(action: {
                        showBookingSheet = true
                    }) {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Book a Checkup")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.tealBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .sheet(isPresented: $showBookingSheet) {
                        CategoryBookingSheetView(category: category)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
//        .navigationTitle(category.name)
//        .navigationBarTitleDisplayMode(.inline)
        .background(Color.lightGray.ignoresSafeArea())
    }

    // Sample category-specific details
    private func sampleDetails(for categoryName: String) -> [String] {
        switch categoryName {
        case "Diabetes Check":
            return [
                "Monitor fasting and post-meal blood sugar levels.",
                "Understand HbA1c readings.",
                "Recognize symptoms of low and high sugar."
            ]
        case "Blood Pressure":
            return [
                "Check systolic and diastolic pressure ranges.",
                "Identify signs of hypertension or hypotension.",
                "Monitor stress, salt intake, and hydration."
            ]
        case "Heart Health":
            return [
                "Evaluate heart rate and rhythm abnormalities.",
                "Identify chest pain and other cardiac symptoms.",
                "Track ECG and cholesterol regularly."
            ]
        case "Mental Health":
            return [
                "Understand anxiety, depression, and stress signs.",
                "Use mindfulness and breathing tools.",
                "Access mental health therapy or support."
            ]
        case "General Check":
            return [
                "Track your temperature, pain, and vital signs.",
                "Log regular exercise, sleep, and diet patterns.",
                "Consult a doctor for annual health checkups."
            ]
        default:
            return ["No details available."]
        }
    }
}
