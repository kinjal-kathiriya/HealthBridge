//
//  CategoryBookingSheetView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//


import SwiftUI

struct CategoryBookingSheetView: View {
    let category: HealthCategory
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("Book a Checkup")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.tealBlue)

            Text("You're booking a health checkup for:")
                .font(.body)
                .foregroundColor(.gray)

            Text(category.name)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(category.color)

            Spacer()

            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customPink)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}
