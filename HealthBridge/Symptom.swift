//
//  Symptom.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//


import SwiftUI

// Custom colors
extension Color {
    static let tealBlue = Color(red: 0.0, green: 0.59, blue: 0.65)
    static let customPink = Color(red: 0.91, green: 0.12, blue: 0.39)
    static let lightGray = Color(white: 0.95)
}

struct HealthDetectionView: View {
    @State private var selectedTab = 0
    @State private var selectedSymptoms: Set<Symptom> = []
    @State private var vitalSigns = VitalSigns()
    @State private var painLevel: Double = 0
    @State private var moodIndex = 2
    @State private var assessmentResults: [HealthRisk] = []
    @State private var recommendations: [String] = []
    @State private var showResults = false
    @State private var currentStep = 1
    @State private var showEmergencyAlert = false
    @State private var isLoading = false
    
    let moods = ["😊", "😐", "😔", "😰", "🤒"]
    let moodLabels = ["Great", "Good", "Okay", "Worried", "Sick"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.lightGray.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Progress Indicator
                    progressView
                    
                    // Tab Selector
                    tabSelector
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 20) {
                            if showResults {
                                resultsView
                            } else {
                                switch selectedTab {
                                case 0: symptomCheckerView
                                case 1: vitalSignsView
                                case 2: healthCategoriesView
                                default: symptomCheckerView
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Action Buttons
                    if !showResults {
                        actionButtons
                            .padding(.bottom)
                    }
                }
                
                if isLoading {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Emergency", isPresented: $showEmergencyAlert) {
            Button("Call 911", role: .destructive) {
                if let url = URL(string: "tel://911") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("If you're experiencing a medical emergency, please call 911 immediately.")
        }
    }
    
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("HealthBridge")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.tealBlue)
                Text("Health Problem Detection")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.tealBlue)
                }
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.tealBlue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
    }
    
    private var progressView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Step \(currentStep) of 3")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int((Double(currentStep) / 3.0) * 100))% Complete")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            ProgressView(value: Double(currentStep), total: 3.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .tealBlue))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: {
                    withAnimation {
                        selectedTab = index
                        currentStep = index + 1
                    }
                }) {
                    Text(["Symptoms", "Vitals", "Categories"][index])
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selectedTab == index ? .white : .tealBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            selectedTab == index ? Color.tealBlue : Color.clear
                        )
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.tealBlue.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var symptomCheckerView: some View {
        VStack(spacing: 16) {
            // Mood Selector
            moodSelectorCard
            
            // Symptom Selection
            symptomSelectionCard
            
            // Pain Level Slider
            if !selectedSymptoms.isEmpty {
                painLevelCard
            }
        }
    }
    
    private var moodSelectorCard: some View {
        CardView {
            VStack(spacing: 16) { // 🔄 increased from 12 to 16
                Text("How are you feeling today?")
                    .font(.headline)
                    .foregroundColor(.tealBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<moods.count, id: \.self) { index in
                            Button(action: {
                                withAnimation { moodIndex = index }
                            }) {
                                VStack(spacing: 4) {
                                    Text(moods[index])
                                        .font(.system(size: 28))
                                        .scaleEffect(moodIndex == index ? 1.2 : 1.0)
                                    Text(moodLabels[index])
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 70, height: 80)
                                .background(moodIndex == index ? Color.tealBlue.opacity(0.15) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(moodIndex == index ? Color.tealBlue : Color.gray.opacity(0.3), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding()
        }
    }

    
    private var symptomSelectionCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Select your symptoms:")
                    .font(.headline)
                    .foregroundColor(.tealBlue)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) { // 🔄 spacing from 14 → 16
                    ForEach(Symptom.commonSymptoms) { symptom in
                        SymptomChip(symptom: symptom, isSelected: selectedSymptoms.contains(symptom)) {
                            withAnimation {
                                if selectedSymptoms.contains(symptom) {
                                    selectedSymptoms.remove(symptom)
                                } else {
                                    selectedSymptoms.insert(symptom)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20) // 🔄 More vertical breathing room
            .padding(.horizontal)
        }
    }

    
    private var painLevelCard: some View {
        CardView {
            VStack(spacing: 16) {
                Text("Pain Level (0-10):")
                    .font(.headline)
                    .foregroundColor(.tealBlue)
                
                VStack(spacing: 8) {
                    HStack {
                        Text("0")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("10")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                    
                    Slider(value: $painLevel, in: 0...10, step: 1)
                        .accentColor(.customPink)
                    
                    HStack {
                        Text("\(Int(painLevel))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.customPink)
                        
                        Text(painLevelDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
    }
    
    private var vitalSignsView: some View {
        CardView {
            VStack(spacing: 20) {
                Text("Enter Your Vital Signs:")
                    .font(.headline)
                    .foregroundColor(.tealBlue)
                
                VStack(spacing: 16) {
                    // Blood Pressure
                    HStack {
                        IconTextField(systemName: "heart.fill", color: .customPink,
                                     placeholder: "Systolic (120)", text: $vitalSigns.bloodPressureSystolic)
                            .keyboardType(.numberPad)
                        
                        Text("/")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        IconTextField(systemName: "heart.fill", color: .customPink,
                                     placeholder: "Diastolic (80)", text: $vitalSigns.bloodPressureDiastolic)
                            .keyboardType(.numberPad)
                    }
                    
                    // Heart Rate
                    IconTextField(systemName: "waveform.path.ecg", color: .customPink,
                                   placeholder: "Heart Rate (72)", text: $vitalSigns.heartRate)
                        .keyboardType(.numberPad)
                    
                    // Blood Sugar
                    IconTextField(systemName: "drop.fill", color: .customPink,
                                 placeholder: "Blood Sugar (100)", text: $vitalSigns.bloodSugar)
                        .keyboardType(.numberPad)
                    
                    // Temperature
                    IconTextField(systemName: "thermometer", color: .customPink,
                                 placeholder: "Temp (°F)", text: $vitalSigns.temperature)
                        .keyboardType(.decimalPad)
                    
                    // Weight
                    IconTextField(systemName: "scalemass.fill", color: .customPink,
                                 placeholder: "Weight (lbs)", text: $vitalSigns.weight)
                        .keyboardType(.numberPad)
                }
            }
            .padding()
        }
    }
    
    private var healthCategoriesView: some View {
        VStack(spacing: 16) {
            Text("Quick Health Assessments:")
                .font(.headline)
                .foregroundColor(.tealBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(HealthCategory.standardCategories) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        HealthCategoryCard(category: category)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            
            // Photo Analysis Card
            CardView {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.tealBlue)
                        Text("Photo Analysis")
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        Spacer()
                    }
                    
                    Text("Upload photos for skin conditions, eye checks, etc.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Take Photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.tealBlue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 16) {
            Text("Health Assessment Results:")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.tealBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(assessmentResults) { risk in
                    RiskAssessmentCard(risk: risk)
                }
            }
            .padding(.horizontal)
            
            // Recommendations
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommendations:")
                        .font(.headline)
                        .foregroundColor(.tealBlue)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(recommendations, id: \.self) { recommendation in
                            HStack(alignment: .top) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.customPink)
                                Text(recommendation)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .padding()
            }
            .padding(.horizontal)
            
            // Action Buttons
            HStack(spacing: 12) {
                NavigationLink(destination: DoctorSearchView()) {
                    HStack {
                        Image(systemName: "stethoscope")
                        Text("Doctors")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.tealBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                NavigationLink(destination: MedicineSuggestionsView()) {
                    HStack {
                        Image(systemName: "pills")
                        Text("Medicines")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.customPink)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: analyzeHealth) {
                HStack {
                    Image(systemName: "waveform.path.ecg")
                    Text("Analyze My Health")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.tealBlue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
            }
            
            Button(action: { showEmergencyAlert = true }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Emergency Contact")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customPink)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
            }
        }
        .padding(.horizontal)
    }
    
    private var painLevelDescription: String {
        switch Int(painLevel) {
        case 0: return "No pain"
        case 1...3: return "Mild"
        case 4...6: return "Moderate"
        case 7...8: return "Severe"
        default: return "Extreme"
        }
    }
    
    private func analyzeHealth() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var risks: [HealthRisk] = []
            var recs: [String] = []
            
            // Enhanced analysis with your color scheme
            if let systolic = Int(vitalSigns.bloodPressureSystolic), systolic > 140 {
                let level: HealthRisk.RiskLevel = systolic > 180 ? .high : .medium
                risks.append(HealthRisk(
                    condition: "Blood Pressure",
                    level: level,
                    description: level == .high ?
                    "Severely elevated blood pressure - seek immediate care" :
                    "Elevated blood pressure - consult your doctor"
                ))
                recs.append("Schedule appointment with cardiologist")
            }
            
            if let bloodSugar = Int(vitalSigns.bloodSugar), bloodSugar > 140 {
                let level: HealthRisk.RiskLevel = bloodSugar > 200 ? .high : .medium
                risks.append(HealthRisk(
                    condition: "Blood Sugar",
                    level: level,
                    description: level == .high ?
                    "Dangerously high blood sugar levels detected" :
                    "Elevated blood sugar levels detected"
                ))
                recs.append("Consult an endocrinologist")
            }
            
            if selectedSymptoms.contains(where: { $0.name == "Chest Pain" }) {
                risks.append(HealthRisk(
                    condition: "Cardiac Concern",
                    level: .high,
                    description: "Chest pain requires immediate medical attention"
                ))
                recs.append("Seek emergency care if pain persists")
            }
            
            if risks.isEmpty {
                risks.append(HealthRisk(
                    condition: "General Health",
                    level: .good,
                    description: "No immediate health concerns detected"
                ))
                recs.append("Maintain regular checkups and healthy lifestyle")
            }
            
            withAnimation {
                assessmentResults = risks
                recommendations = recs
                showResults = true
                currentStep = 3
                isLoading = false
            }
        }
    }
    
    private func validateInputs() -> Bool {
        // Implement validation logic here
        return true
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SymptomChip: View {
    let symptom: Symptom
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(symptom.icon)
                    .font(.system(size: 28))
                Text(symptom.name)
                    .font(.system(size: 12, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? Color.tealBlue.opacity(0.1) : Color.white
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.tealBlue : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .cornerRadius(12)
        }
        .foregroundColor(.primary)
    }
}

struct IconTextField: View {
    let systemName: String
    let color: Color
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(color)
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct HealthCategoryCard: View {
    let category: HealthCategory
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(category.color)
                .cornerRadius(25)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.tealBlue)
                Text(category.description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct RiskAssessmentCard: View {
    let risk: HealthRisk
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: riskIcon)
                        .foregroundColor(risk.level.color)
                    
                    Text(risk.condition)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(risk.level.text)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(risk.level.color.opacity(0.2))
                        .foregroundColor(risk.level.color)
                        .cornerRadius(12)
                }
                
                Text(risk.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(risk.level.color.opacity(0.3), lineWidth: 1))
    }
    
    private var riskIcon: String {
        switch risk.level {
        case .high: return "exclamationmark.triangle.fill"
        case .medium: return "exclamationmark.circle.fill"
        case .low: return "checkmark.circle.fill"
        case .good: return "heart.fill"
        }
    }
}

struct Symptom: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let category: String
    
    static let commonSymptoms = [
        Symptom(name: "Headache", icon: "🤕", category: "Neurological"),
        Symptom(name: "Chest Pain", icon: "💔", category: "Cardiac"),
        Symptom(name: "Shortness of Breath", icon: "💨", category: "Respiratory"),
        Symptom(name: "Fatigue", icon: "😴", category: "General"),
        Symptom(name: "Nausea", icon: "🤢", category: "Digestive"),
        Symptom(name: "Dizziness", icon: "😵", category: "Neurological"),
        Symptom(name: "Fever", icon: "🌡️", category: "General"),
        Symptom(name: "Joint Pain", icon: "🦴", category: "Musculoskeletal")
    ]
}

struct VitalSigns {
    var bloodPressureSystolic: String = ""
    var bloodPressureDiastolic: String = ""
    var heartRate: String = ""
    var bloodSugar: String = ""
    var temperature: String = ""
    var weight: String = ""
}

struct HealthRisk: Identifiable {
    let id = UUID()
    let condition: String
    let level: RiskLevel
    let description: String
    
    enum RiskLevel {
        case low, medium, high, good
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
            case .good: return .tealBlue
            }
        }
        
        var text: String {
            switch self {
            case .low: return "Low Risk"
            case .medium: return "Medium Risk"
            case .high: return "High Risk"
            case .good: return "Good"
            }
        }
    }
}

struct HealthCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let description: String
    
    static let standardCategories = [
        HealthCategory(name: "Diabetes Check", icon: "drop.fill", color: .tealBlue, description: "Blood sugar assessment"),
        HealthCategory(name: "Blood Pressure", icon: "heart.fill", color: .customPink, description: "Hypertension screening"),
        HealthCategory(name: "Heart Health", icon: "waveform.path.ecg", color: .red, description: "Cardiac assessment"),
        HealthCategory(name: "Mental Health", icon: "brain.head.profile", color: .purple, description: "Wellness check"),
        HealthCategory(name: "General Check", icon: "stethoscope", color: .green, description: "Overall health")
    ]
}

struct HealthDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDetectionView()
    }
}

