//
//  ProfileView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//

import SwiftUI

extension Color {
    static let healthLightGray = Color(.systemGray6)
    static let healthTealBlue = Color.teal
    static let healthCustomPink = Color.pink
}

struct HealthCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ProfileView: View {
    @State private var userProfile = UserProfile()
    @State private var showingImagePicker = false
    @State private var showingEditProfile = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image = Image(systemName: "person.circle.fill")
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                profileHeaderSection

                // Quick Stats
                quickStatsSection

                // Health Summary
                healthSummarySection

                // Recent Activity
                recentActivitySection

                // Emergency Contacts
                emergencyContactsSection

                // Health Documents
                healthDocumentsSection
            }
            .padding()
        }
        .background(Color.healthLightGray.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(userProfile: $userProfile)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { _, image in
            if let image = image {
                profileImage = Image(uiImage: image)
            }
        }
    }

    
    private var profileHeaderSection: some View {
        HealthCardView {
            VStack(spacing: 16) {
                // Profile Image
                Button(action: { showingImagePicker = true }) {
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.healthTealBlue, lineWidth: 3)
                        )
                        .overlay(
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.healthTealBlue)
                                        .frame(width: 30, height: 30)
                                )
                                .offset(x: 35, y: 35)
                        )
                }
                
                VStack(spacing: 8) {
                    Text(userProfile.fullName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.healthTealBlue)
                    
                    Text(userProfile.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 16) {
                        Label("\(userProfile.age) years", systemImage: "calendar")
                        Label(userProfile.gender, systemImage: "person")
                        Label(userProfile.bloodType, systemImage: "drop.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.headline)
                .foregroundColor(.healthTealBlue)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                StatCard(title: "Height", value: userProfile.height, icon: "ruler", color: .healthTealBlue)
                StatCard(title: "Weight", value: userProfile.weight, icon: "scalemass", color: .healthCustomPink)
                StatCard(title: "BMI", value: userProfile.bmi, icon: "chart.line.uptrend.xyaxis", color: .green)
            }
        }
    }
    
    private var healthSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Summary")
                .font(.headline)
                .foregroundColor(.healthTealBlue)
                .padding(.horizontal)
            
            HealthCardView {
                VStack(spacing: 16) {
                    // Allergies
                    HealthInfoRow(
                        title: "Allergies",
                        value: userProfile.allergies.isEmpty ? "None reported" : userProfile.allergies.joined(separator: ", "),
                        icon: "exclamationmark.triangle",
                        color: .orange
                    )
                    
                    Divider()
                    
                    // Medications
                    HealthInfoRow(
                        title: "Current Medications",
                        value: userProfile.medications.isEmpty ? "None" : userProfile.medications.joined(separator: ", "),
                        icon: "pills",
                        color: .healthCustomPink
                    )
                    
                    Divider()
                    
                    // Medical Conditions
                    HealthInfoRow(
                        title: "Medical Conditions",
                        value: userProfile.medicalConditions.isEmpty ? "None reported" : userProfile.medicalConditions.joined(separator: ", "),
                        icon: "heart.text.square",
                        color: .red
                    )
                }
                .padding()
            }
        }
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .foregroundColor(.healthTealBlue)
                .padding(.horizontal)
            
            HealthCardView {
                VStack(spacing: 12) {
                    ForEach(userProfile.recentActivities) { activity in
                        ActivityRow(activity: activity)
                        if activity.id != userProfile.recentActivities.last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var emergencyContactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Emergency Contacts")
                    .font(.headline)
                    .foregroundColor(.healthTealBlue)
                Spacer()
                Button("Add") {
                    // Add emergency contact action
                    addEmergencyContact()
                }
                .foregroundColor(.healthCustomPink)
            }
            .padding(.horizontal)
            
            HealthCardView {
                VStack(spacing: 12) {
                    ForEach(userProfile.emergencyContacts) { contact in
                        EmergencyContactRow(contact: contact)
                        if contact.id != userProfile.emergencyContacts.last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private var healthDocumentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Health Documents")
                    .font(.headline)
                    .foregroundColor(.healthTealBlue)
                Spacer()
                Button("Upload") {
                    // Upload document action
                    uploadHealthDocument()
                }
                .foregroundColor(.healthCustomPink)
            }
            .padding(.horizontal)
            
            HealthCardView {
                VStack(spacing: 12) {
                    ForEach(userProfile.healthDocuments) { document in
                        DocumentRow(document: document)
                        if document.id != userProfile.healthDocuments.last?.id {
                            Divider()
                        }
                    }
                }
                .padding()
            }
        }
    }
    

    private func addEmergencyContact() {
        // Placeholder for adding emergency contact
        print("Add emergency contact tapped")
    }
    
    private func uploadHealthDocument() {
        // Placeholder for uploading health document
        print("Upload health document tapped")
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HealthCardView {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

struct HealthInfoRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.healthTealBlue)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct ActivityRow: View {
    let activity: HealthActivity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.icon)
                .foregroundColor(activity.color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(activity.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct EmergencyContactRow: View {
    let contact: EmergencyContact
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.healthCustomPink)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(contact.relationship)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                callEmergencyContact(phone: contact.phone)
            }) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.healthTealBlue)
            }
        }
    }
    
    private func callEmergencyContact(phone: String) {
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url)
        }
    }
}

struct DocumentRow: View {
    let document: HealthDocument
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: document.icon)
                .foregroundColor(.healthTealBlue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(document.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(document.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                openDocument(document)
            }) {
                Image(systemName: "eye")
                    .foregroundColor(.healthCustomPink)
            }
        }
    }
    
    private func openDocument(_ document: HealthDocument) {
        // Placeholder for opening document
        print("Opening document: \(document.name)")
    }
}

struct EditProfileView: View {
    @Binding var userProfile: UserProfile
    @Environment(\.dismiss) private var dismiss
    @State private var editableAllergies: String = ""
    @State private var editableMedications: String = ""
    @State private var editableConditions: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("First Name", text: $userProfile.firstName)
                    TextField("Last Name", text: $userProfile.lastName)
                    TextField("Email", text: $userProfile.email)
                        .keyboardType(.emailAddress)
                    TextField("Age", value: $userProfile.age, format: .number)
                        .keyboardType(.numberPad)
                    
                    Picker("Gender", selection: $userProfile.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                }
                
                Section("Physical Information") {
                    TextField("Height (e.g., 5'10\")", text: $userProfile.height)
                    TextField("Weight (e.g., 180 lbs)", text: $userProfile.weight)
                    
                    Picker("Blood Type", selection: $userProfile.bloodType) {
                        ForEach(["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"], id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
                
                Section("Medical Information") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Allergies")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter allergies separated by commas", text: $editableAllergies)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Medications")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter medications separated by commas", text: $editableMedications)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Medical Conditions")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter conditions separated by commas", text: $editableConditions)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                        dismiss()
                    }
                    .foregroundColor(.healthTealBlue)
                }
            }
            .onAppear {
                setupEditableFields()
            }
        }
    }
    
    private func setupEditableFields() {
        editableAllergies = userProfile.allergies.joined(separator: ", ")
        editableMedications = userProfile.medications.joined(separator: ", ")
        editableConditions = userProfile.medicalConditions.joined(separator: ", ")
    }
    
    private func saveProfile() {
        // Parse comma-separated strings back to arrays
        userProfile.allergies = editableAllergies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        userProfile.medications = editableMedications.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        userProfile.medicalConditions = editableConditions.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}


struct UserProfile {
    var firstName: String = "John"
    var lastName: String = "Doe"
    var email: String = "john.doe@example.com"
    var age: Int = 30
    var gender: String = "Male"
    var height: String = "5'10\""
    var weight: String = "180 lbs"
    var bloodType: String = "O+"
    var allergies: [String] = ["Peanuts", "Shellfish"]
    var medications: [String] = ["Lisinopril", "Metformin"]
    var medicalConditions: [String] = ["Hypertension", "Type 2 Diabetes"]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var bmi: String {
        // Enhanced BMI calculation
        let heightInInches = parseHeight(height)
        let weightInPounds = parseWeight(weight)
        
        if heightInInches > 0 && weightInPounds > 0 {
            let bmi = (weightInPounds / (heightInInches * heightInInches)) * 703
            return String(format: "%.1f", bmi)
        }
        return "24.5" // Default fallback
    }
    
    private func parseHeight(_ heightString: String) -> Double {
        // Simple parsing for format like "5'10""
        let components = heightString.replacingOccurrences(of: "\"", with: "").components(separatedBy: "'")
        if components.count == 2,
           let feet = Double(components[0]),
           let inches = Double(components[1]) {
            return (feet * 12) + inches
        }
        return 70.0 // Default 5'10"
    }
    
    private func parseWeight(_ weightString: String) -> Double {
        // Simple parsing for format like "180 lbs"
        let numberString = weightString.replacingOccurrences(of: " lbs", with: "").replacingOccurrences(of: "lbs", with: "")
        return Double(numberString) ?? 180.0
    }
    
    var recentActivities: [HealthActivity] = [
        HealthActivity(title: "Health Assessment Completed", date: Date().addingTimeInterval(-86400), icon: "checkmark.circle", color: .green),
        HealthActivity(title: "Blood Pressure Recorded", date: Date().addingTimeInterval(-172800), icon: "heart", color: .red),
        HealthActivity(title: "Weight Updated", date: Date().addingTimeInterval(-259200), icon: "scalemass", color: .blue),
        HealthActivity(title: "Medication Reminder", date: Date().addingTimeInterval(-345600), icon: "pills", color: .orange),
        HealthActivity(title: "Doctor Appointment", date: Date().addingTimeInterval(-432000), icon: "stethoscope", color: .purple)
    ]
    
    var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(name: "Jane Doe", relationship: "Spouse", phone: "555-0123"),
        EmergencyContact(name: "Dr. Smith", relationship: "Primary Care", phone: "555-0456"),
        EmergencyContact(name: "Michael Doe", relationship: "Brother", phone: "555-0789")
    ]
    
    var healthDocuments: [HealthDocument] = [
        HealthDocument(name: "Blood Test Results", date: Date().addingTimeInterval(-604800), icon: "doc.text"),
        HealthDocument(name: "Prescription", date: Date().addingTimeInterval(-1209600), icon: "pills"),
        HealthDocument(name: "X-Ray Report", date: Date().addingTimeInterval(-1814400), icon: "xmark.square"),
        HealthDocument(name: "Insurance Card", date: Date().addingTimeInterval(-2419200), icon: "creditcard"),
        HealthDocument(name: "Vaccination Record", date: Date().addingTimeInterval(-3024000), icon: "cross.vial")
    ]
}

struct HealthActivity: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let icon: String
    let color: Color
}

struct EmergencyContact: Identifiable {
    let id = UUID()
    let name: String
    let relationship: String
    let phone: String
}

struct HealthDocument: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let icon: String
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.light)
        
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
