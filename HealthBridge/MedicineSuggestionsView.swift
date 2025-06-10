//
//  MedicineSuggestionsView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//


import SwiftUI

struct MedicineSuggestionsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Medicine Suggestions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.tealBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ForEach(medicineSuggestions) { suggestion in
                    MedicineSuggestionCard(suggestion: suggestion)
                }
            }
            .padding(.top)
        }
        .background(Color.lightGray.ignoresSafeArea())
        .navigationTitle("Medicines")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MedicineSuggestionCard: View {
    let suggestion: MedicineSuggestion

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: suggestion.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(suggestion.color)
                        .cornerRadius(10)

                    VStack(alignment: .leading) {
                        Text(suggestion.category)
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        Text(suggestion.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Recommended:")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    ForEach(suggestion.medicines, id: \.self) { medicine in
                        HStack {
                            Image(systemName: "pills.fill")
                                .foregroundColor(.customPink)
                            Text(medicine)
                                .font(.body)
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}


struct MedicineSuggestion: Identifiable {
    let id = UUID()
    let category: String
    let icon: String
    let color: Color
    let description: String
    let medicines: [String]
}

let medicineSuggestions: [MedicineSuggestion] = [
    MedicineSuggestion(
        category: "Pain Relief",
        icon: "cross.case.fill",
        color: .red,
        description: "For headache, joint pain, and general body aches.",
        medicines: ["Tylenol (Acetaminophen)", "Advil (Ibuprofen)", "Aleve (Naproxen)"]
    ),
    MedicineSuggestion(
        category: "Cold & Flu",
        icon: "thermometer.medium",
        color: .blue,
        description: "Helps with fever, cough, and nasal congestion.",
        medicines: ["DayQuil", "NyQuil", "Sudafed", "Mucinex"]
    ),
    MedicineSuggestion(
        category: "Digestive Health",
        icon: "leaf.circle.fill",
        color: .green,
        description: "For nausea, gas, and indigestion relief.",
        medicines: ["Pepto-Bismol", "Tums", "Imodium", "Gas-X"]
    ),
    MedicineSuggestion(
        category: "Allergies",
        icon: "wind",
        color: .purple,
        description: "For seasonal or contact allergies.",
        medicines: ["Zyrtec", "Claritin", "Benadryl", "Allegra"]
    )
]

