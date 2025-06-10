//
//  SettingsView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var settings = AppSettings()
    @State private var showingResetAlert = false
    @State private var showingDeleteAccountAlert = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            List {
                // User Preferences Section
                Section("Preferences") {
                    // Notifications
                    NavigationLink {
                        NotificationSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: settings.notificationsEnabled ? "On" : "Off",
                            color: .tealBlue
                        )
                    }
                    
                    // Theme
                    NavigationLink {
                        ThemeSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "paintbrush.fill",
                            title: "Theme",
                            subtitle: settings.theme.rawValue,
                            color: .customPink
                        )
                    }
                    
                    // Language
                    NavigationLink {
                        LanguageSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "globe",
                            title: "Language",
                            subtitle: settings.language,
                            color: .blue
                        )
                    }
                    
                    // Units
                    NavigationLink {
                        UnitsSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "ruler",
                            title: "Units",
                            subtitle: settings.measurementSystem.rawValue,
                            color: .green
                        )
                    }
                }
                
                // Health & Privacy Section
                Section("Health & Privacy") {
                    // Health Data Sync
                    Toggle(isOn: $settings.healthKitEnabled) {
                        SettingsRow(
                            icon: "heart.fill",
                            title: "HealthKit Integration",
                            subtitle: "Sync with Apple Health",
                            color: .red
                        )
                    }
                    .tint(.tealBlue)
                    
                    // Data Backup
                    Toggle(isOn: $settings.cloudBackupEnabled) {
                        SettingsRow(
                            icon: "icloud.fill",
                            title: "iCloud Backup",
                            subtitle: "Backup health data",
                            color: .cyan
                        )
                    }
                    .tint(.tealBlue)
                    
                    // Privacy Settings
                    NavigationLink {
                        PrivacySettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "lock.shield.fill",
                            title: "Privacy & Security",
                            subtitle: "Data protection settings",
                            color: .orange
                        )
                    }
                    
                    // Export Health Data
                    Button(action: exportHealthData) {
                        SettingsRow(
                            icon: "square.and.arrow.up",
                            title: "Export Health Data",
                            subtitle: "Download your data",
                            color: .purple
                        )
                    }
                    .foregroundColor(.primary)
                }
                
                // Emergency Section
                Section("Emergency") {
                    // Emergency Contacts
                    NavigationLink {
                        EmergencyContactsSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "phone.fill.badge.plus",
                            title: "Emergency Contacts",
                            subtitle: "\(settings.emergencyContacts.count) contacts",
                            color: .red
                        )
                    }
                    
                    // Medical ID
                    NavigationLink {
                        MedicalIDSettingsView(settings: $settings)
                    } label: {
                        SettingsRow(
                            icon: "cross.case.fill",
                            title: "Medical ID",
                            subtitle: "Emergency information",
                            color: .red
                        )
                    }
                    
                    // Emergency Services
                    Button(action: callEmergencyServices) {
                        SettingsRow(
                            icon: "exclamationmark.triangle.fill",
                            title: "Emergency Services",
                            subtitle: "Quick access to 911",
                            color: .red
                        )
                    }
                    .foregroundColor(.primary)
                }
                
                // Support Section
                Section("Support") {
                    // Help Center
                    NavigationLink {
                        HelpCenterView()
                    } label: {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            subtitle: "FAQs and support",
                            color: .blue
                        )
                    }
                    
                    // Contact Support
                    Button(action: contactSupport) {
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Support",
                            subtitle: "Get help from our team",
                            color: .tealBlue
                        )
                    }
                    .foregroundColor(.primary)
                    
                    // Report a Problem
                    Button(action: reportProblem) {
                        SettingsRow(
                            icon: "exclamationmark.bubble.fill",
                            title: "Report a Problem",
                            subtitle: "Send feedback",
                            color: .orange
                        )
                    }
                    .foregroundColor(.primary)
                }
                
                // About Section
                Section("About") {
                    Button(action: { showingAbout = true }) {
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "About HealthBridge",
                            subtitle: "Version 1.0.0",
                            color: .gray
                        )
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: { showingPrivacyPolicy = true }) {
                        SettingsRow(
                            icon: "doc.text.fill",
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            color: .indigo
                        )
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: { showingTermsOfService = true }) {
                        SettingsRow(
                            icon: "doc.plaintext.fill",
                            title: "Terms of Service",
                            subtitle: "Usage agreement",
                            color: .brown
                        )
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: rateApp) {
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate HealthBridge",
                            subtitle: "Leave a review",
                            color: .yellow
                        )
                    }
                    .foregroundColor(.primary)
                }
                
                // Account Section
                Section("Account") {
                    Button(action: { showingResetAlert = true }) {
                        SettingsRow(
                            icon: "arrow.clockwise",
                            title: "Reset All Data",
                            subtitle: "Clear all health data",
                            color: .orange
                        )
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: { showingDeleteAccountAlert = true }) {
                        SettingsRow(
                            icon: "trash.fill",
                            title: "Delete Account",
                            subtitle: "Permanently delete account",
                            color: .red
                        )
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.lightGray.edgesIgnoringSafeArea(.all))
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will permanently delete all your health data. This action cannot be undone.")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
        } message: {
            Text("This will permanently delete your account and all associated data. This action cannot be undone.")
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            WebView(url: "https://healthbridge.com/privacy")
        }
        .sheet(isPresented: $showingTermsOfService) {
            WebView(url: "https://healthbridge.com/terms")
        }
    }
    

    private func exportHealthData() {
        // Implement health data export
        print("Exporting health data...")
    }
    
    private func callEmergencyServices() {
        if let url = URL(string: "tel://911") {
            UIApplication.shared.open(url)
        }
    }
    
    private func contactSupport() {
        if let url = URL(string: "mailto:support@healthbridge.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func reportProblem() {
        if let url = URL(string: "mailto:feedback@healthbridge.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        // Open App Store rating
        if let url = URL(string: "https://apps.apple.com/app/healthbridge") {
            UIApplication.shared.open(url)
        }
    }
    
    private func resetAllData() {
        // Implement data reset
        print("Resetting all data...")
    }
    
    private func deleteAccount() {
        // Implement account deletion
        print("Deleting account...")
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(color)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct NotificationSettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("General") {
                Toggle("Enable Notifications", isOn: $settings.notificationsEnabled)
                    .tint(.tealBlue)
                
                if settings.notificationsEnabled {
                    Toggle("Health Reminders", isOn: $settings.healthRemindersEnabled)
                        .tint(.tealBlue)
                    
                    Toggle("Medication Reminders", isOn: $settings.medicationRemindersEnabled)
                        .tint(.tealBlue)
                    
                    Toggle("Appointment Reminders", isOn: $settings.appointmentRemindersEnabled)
                        .tint(.tealBlue)
                    
                    Toggle("Emergency Alerts", isOn: $settings.emergencyAlertsEnabled)
                        .tint(.tealBlue)
                }
            }
            
            if settings.notificationsEnabled {
                Section("Timing") {
                    Picker("Reminder Time", selection: $settings.reminderTime) {
                        Text("Morning").tag("Morning")
                        Text("Afternoon").tag("Afternoon")
                        Text("Evening").tag("Evening")
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThemeSettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("Appearance") {
                Picker("Theme", selection: $settings.theme) {
                    Text("System").tag(Theme.system)
                    Text("Light").tag(Theme.light)
                    Text("Dark").tag(Theme.dark)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section("Colors") {
                HStack {
                    Text("Primary Color")
                    Spacer()
                    Circle()
                        .fill(Color.tealBlue)
                        .frame(width: 30, height: 30)
                }
                
                HStack {
                    Text("Accent Color")
                    Spacer()
                    Circle()
                        .fill(Color.customPink)
                        .frame(width: 30, height: 30)
                }
            }
            
            Section("Text Size") {
                Picker("Font Size", selection: $settings.fontSize) {
                    Text("Small").tag(FontSize.small)
                    Text("Medium").tag(FontSize.medium)
                    Text("Large").tag(FontSize.large)
                    Text("Extra Large").tag(FontSize.extraLarge)
                }
            }
        }
        .navigationTitle("Theme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguageSettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("Language") {
                ForEach(["English", "Spanish", "French", "German", "Chinese", "Japanese"], id: \.self) { language in
                    Button(action: {
                        settings.language = language
                    }) {
                        HStack {
                            Text(language)
                                .foregroundColor(.primary)
                            Spacer()
                            if settings.language == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.tealBlue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UnitsSettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("Measurement System") {
                Picker("System", selection: $settings.measurementSystem) {
                    Text("Imperial").tag(MeasurementSystem.imperial)
                    Text("Metric").tag(MeasurementSystem.metric)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section("Details") {
                HStack {
                    Text("Weight")
                    Spacer()
                    Text(settings.measurementSystem == .imperial ? "lbs" : "kg")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Height")
                    Spacer()
                    Text(settings.measurementSystem == .imperial ? "ft/in" : "cm")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text(settings.measurementSystem == .imperial ? "°F" : "°C")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Units")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("Data Collection") {
                Toggle("Analytics", isOn: $settings.analyticsEnabled)
                    .tint(.tealBlue)
                
                Toggle("Crash Reports", isOn: $settings.crashReportsEnabled)
                    .tint(.tealBlue)
                
                Toggle("Usage Data", isOn: $settings.usageDataEnabled)
                    .tint(.tealBlue)
            }
            
            Section("Security") {
                Toggle("Biometric Lock", isOn: $settings.biometricLockEnabled)
                    .tint(.tealBlue)
                
                Toggle("Auto Lock", isOn: $settings.autoLockEnabled)
                    .tint(.tealBlue)
                
                if settings.autoLockEnabled {
                    Picker("Auto Lock Time", selection: $settings.autoLockTime) {
                        Text("Immediately").tag(0)
                        Text("1 minute").tag(60)
                        Text("5 minutes").tag(300)
                        Text("15 minutes").tag(900)
                    }
                }
            }
            
            Section("Data Sharing") {
                Toggle("Share with Healthcare Provider", isOn: $settings.shareWithProvider)
                    .tint(.tealBlue)
                
                Toggle("Research Participation", isOn: $settings.researchParticipation)
                    .tint(.tealBlue)
            }
        }
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmergencyContactsSettingsView: View {
    @Binding var settings: AppSettings
    @State private var showingAddContact = false
    
    var body: some View {
        List {
            Section("Emergency Contacts") {
                ForEach(settings.emergencyContacts) { contact in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(contact.relationship)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if let url = URL(string: "tel://\(contact.phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.tealBlue)
                        }
                    }
                }
                .onDelete(perform: deleteContact)
            }
            
            Section {
                Button(action: { showingAddContact = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.tealBlue)
                        Text("Add Emergency Contact")
                    }
                }
            }
        }
        .navigationTitle("Emergency Contacts")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddContact) {
            AddEmergencyContactView(settings: $settings)
        }
    }
    
    private func deleteContact(at offsets: IndexSet) {
        settings.emergencyContacts.remove(atOffsets: offsets)
    }
}

struct MedicalIDSettingsView: View {
    @Binding var settings: AppSettings
    
    var body: some View {
        List {
            Section("Medical Information") {
                HStack {
                    Text("Blood Type")
                    Spacer()
                    Text(settings.medicalID.bloodType)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Medical Conditions")
                    Spacer()
                    Text("\(settings.medicalID.conditions.count)")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Allergies")
                    Spacer()
                    Text("\(settings.medicalID.allergies.count)")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Medications")
                    Spacer()
                    Text("\(settings.medicalID.medications.count)")
                        .foregroundColor(.gray)
                }
            }
            
            Section("Emergency Access") {
                Toggle("Show on Lock Screen", isOn: $settings.medicalID.showOnLockScreen)
                    .tint(.tealBlue)
            }
        }
        .navigationTitle("Medical ID")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("Common Questions") {
                NavigationLink("How to use Health Detection") {
                    HelpDetailView(title: "Health Detection", content: "Learn how to use our AI-powered health detection features...")
                }
                
                NavigationLink("Understanding Health Reports") {
                    HelpDetailView(title: "Health Reports", content: "Understand what your health assessment results mean...")
                }
                
                NavigationLink("Setting up Emergency Contacts") {
                    HelpDetailView(title: "Emergency Contacts", content: "Configure emergency contacts for quick access...")
                }
                
                NavigationLink("Data Privacy and Security") {
                    HelpDetailView(title: "Privacy", content: "Learn about how we protect your health data...")
                }
            }
            
            Section("Troubleshooting") {
                NavigationLink("App Not Working Properly") {
                    HelpDetailView(title: "Troubleshooting", content: "Common solutions for app issues...")
                }
                
                NavigationLink("Sync Issues") {
                    HelpDetailView(title: "Sync Issues", content: "Resolve data synchronization problems...")
                }
            }
        }
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpDetailView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(content)
                    .font(.body)
                    .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Icon and Name
                    VStack(spacing: 12) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.tealBlue)
                        
                        Text("HealthBridge")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.tealBlue)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About HealthBridge")
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        
                        Text("HealthBridge is your comprehensive health companion, designed to help you monitor, understand, and improve your health through advanced AI-powered analysis and personalized recommendations.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "waveform.path.ecg", text: "AI-powered health detection")
                            FeatureRow(icon: "heart.fill", text: "Vital signs monitoring")
                            FeatureRow(icon: "stethoscope", text: "Doctor recommendations")
                            FeatureRow(icon: "pills", text: "Medicine suggestions")
                            FeatureRow(icon: "phone.fill", text: "Emergency contacts")
                        }
                    }
                    
                    // Credits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Credits")
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        
                        Text("Developed by Kinjal Kathiriya\n© 2025 HealthBridge. All rights reserved.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the sheet
                    }
                    .foregroundColor(.tealBlue)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.customPink)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct AddEmergencyContactView: View {
    @Binding var settings: AppSettings
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var relationship = ""
    @State private var phone = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                    TextField("Relationship", text: $relationship)
                    TextField("Phone Number", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let contact = EmergencyContact(name: name, relationship: relationship, phone: phone)
                        settings.emergencyContacts.append(contact)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty || phone.isEmpty)
                    .foregroundColor(.tealBlue)
                }
            }
        }
    }
}

struct AppSettings {
    // Notification Settings
    var notificationsEnabled = true
    var healthRemindersEnabled = true
    var medicationRemindersEnabled = true
    var appointmentRemindersEnabled = true
    var emergencyAlertsEnabled = true
    var reminderTime = "Morning"
    
    // Theme Settings
    var theme: Theme = .system
    var fontSize: FontSize = .medium
    
    // Language and Units
    var language = "English"
    var measurementSystem: MeasurementSystem = .imperial
    
    // Health Integration
    var healthKitEnabled = false
    var cloudBackupEnabled = true
    
    // Privacy Settings
    var analyticsEnabled = true
    var crashReportsEnabled = true
    var usageDataEnabled = false
    var biometricLockEnabled = false
    var autoLockEnabled = true
    var autoLockTime = 300
    var shareWithProvider = false
    var researchParticipation = false
    
    // Emergency Contacts
    var emergencyContacts: [EmergencyContact] = [
        EmergencyContact(name: "Jane Doe", relationship: "Spouse", phone: "555-0123"),
        EmergencyContact(name: "Dr. Smith", relationship: "Primary Care", phone: "555-0456")
    ]
    
    // Medical ID
    var medicalID = MedicalID()
}

enum Theme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
}

enum FontSize: String, CaseIterable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum MeasurementSystem: String, CaseIterable {
    case imperial = "Imperial"
    case metric = "Metric"
}

struct MedicalID {
    var bloodType = "O+"
    var conditions: [String] = ["Hypertension", "Type 2 Diabetes"]
    var allergies: [String] = ["Peanuts", "Shellfish"]
    var medications: [String] = ["Lisinopril", "Metformin"]
    var showOnLockScreen = false
}

// Need to import WebKit for WKWebView
import WebKit

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
