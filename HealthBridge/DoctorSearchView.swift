//
//  DoctorSearchView.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/24/25.
//

import SwiftUI
import MapKit

struct DoctorSearchView: View {
    @State private var searchText = ""
    @State private var selectedSpecialty = "All"
    @State private var selectedSortOption = "Distance"
    @State private var showFilters = false
    @State private var showMap = false
    @State private var selectedDoctor: Doctor?
    @State private var showBookingSheet = false
    @State private var doctors: [Doctor] = Doctor.sampleDoctors
    @State private var isLoading = false

    let specialties = ["All", "General Practice", "Cardiology", "Dermatology", "Pediatrics", "Orthopedics", "Neurology", "Psychiatry", "Endocrinology"]
    let sortOptions = ["Distance", "Rating", "Price", "Availability"]

    var filteredDoctors: [Doctor] {
        var filtered = doctors
        if !searchText.isEmpty {
            filtered = filtered.filter { doctor in
                doctor.name.localizedCaseInsensitiveContains(searchText) ||
                doctor.specialty.localizedCaseInsensitiveContains(searchText) ||
                doctor.hospital.localizedCaseInsensitiveContains(searchText)
            }
        }
        if selectedSpecialty != "All" {
            filtered = filtered.filter { $0.specialty == selectedSpecialty }
        }
        switch selectedSortOption {
        case "Distance":
            filtered = filtered.sorted { $0.distance < $1.distance }
        case "Rating":
            filtered = filtered.sorted { $0.rating > $1.rating }
        case "Price":
            filtered = filtered.sorted { $0.consultationFee < $1.consultationFee }
        case "Availability":
            filtered = filtered.sorted { $0.isAvailableToday && !$1.isAvailableToday }
        default:
            break
        }
        return filtered
    }

    var body: some View {
        ZStack {
            Color.lightGray.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                headerView
                searchAndFilterBar
                resultsHeaderView
                if showMap {
                    mapView
                } else {
                    doctorListView
                }
            }
            if isLoading {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView(
                selectedSpecialty: $selectedSpecialty,
                selectedSortOption: $selectedSortOption,
                specialties: specialties,
                sortOptions: sortOptions
            )
        }
        .sheet(item: $selectedDoctor) { doctor in
            DoctorDetailView(doctor: doctor, showBookingSheet: $showBookingSheet)
        }
        .sheet(isPresented: $showBookingSheet) {
            if let doctor = selectedDoctor {
                BookingView(doctor: doctor)
            }
        }
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "heart")
                .font(.title2)
                .foregroundColor(.tealBlue)
            VStack(alignment: .leading) {
                Text("Find Doctors")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.tealBlue)
                Text("Nearby healthcare providers")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                if let url = URL(string: "tel://911") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundColor(.customPink)
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
    }

    private var searchAndFilterBar: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search doctors, specialties, hospitals...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Quick Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(["All", "Available Today", "Top Rated", "Nearby"], id: \.self) { filter in
                        QuickFilterChip(
                            title: filter,
                            isSelected: selectedSpecialty == filter,
                            action: {
                                selectedSpecialty = filter
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.lightGray)
    }
    
    private var resultsHeaderView: some View {
        HStack {
            Text("\(filteredDoctors.count) doctors found")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { showFilters = true }) {
                    HStack {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                        Text("Filter")
                    }
                    .font(.caption)
                    .foregroundColor(.tealBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                
                Button(action: { showMap.toggle() }) {
                    HStack {
                        Image(systemName: showMap ? "list.bullet" : "map")
                        Text(showMap ? "List" : "Map")
                    }
                    .font(.caption)
                    .foregroundColor(.tealBlue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.lightGray)
    }
    
    private var doctorListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredDoctors) { doctor in
                    DoctorCard(doctor: doctor) {
                        selectedDoctor = doctor
                    }
                }
            }
            .padding()
        }
    }
    
    private var mapView: some View {
        ZStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
            .edgesIgnoringSafeArea(.bottom)
            
            VStack {
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filteredDoctors.prefix(5)) { doctor in
                            CompactDoctorCard(doctor: doctor) {
                                selectedDoctor = doctor
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .padding()
            }
        }
    }
}

struct QuickFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .tealBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.tealBlue : Color.white)
                .cornerRadius(16)
        }
    }
}

struct DoctorCard: View {
    let doctor: Doctor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    // Doctor Image
                    AsyncImage(url: URL(string: doctor.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    
                    // Doctor Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Dr. \(doctor.name)")
                                .font(.headline)
                                .foregroundColor(.tealBlue)
                            
                            Spacer()
                            
                            if doctor.isAvailableToday {
                                Text("Available Today")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Text(doctor.specialty)
                            .font(.subheadline)
                            .foregroundColor(.customPink)
                        
                        Text(doctor.hospital)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            // Rating
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(doctor.rating) ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                                Text(String(format: "%.1f", doctor.rating))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Text("•")
                                .foregroundColor(.gray)
                            
                            Text("\(doctor.distance, specifier: "%.1f") mi")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("$\(doctor.consultationFee)")
                                .font(.headline)
                                .foregroundColor(.tealBlue)
                        }
                    }
                }
                .padding()
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        // Call doctor
                        if let url = URL(string: "tel://\(doctor.phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.customPink.opacity(0.1))
                        .foregroundColor(.customPink)
                        .cornerRadius(8)
                    }
                    
                    Button(action: action) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Book")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.tealBlue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CompactDoctorCard: View {
    let doctor: Doctor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: doctor.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(spacing: 2) {
                    Text("Dr. \(doctor.name)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.tealBlue)
                    
                    Text(doctor.specialty)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text("$\(doctor.consultationFee)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.customPink)
                }
            }
            .frame(width: 120)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterView: View {
    @Binding var selectedSpecialty: String
    @Binding var selectedSortOption: String
    let specialties: [String]
    let sortOptions: [String]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section("Specialty") {
                    ForEach(specialties, id: \.self) { specialty in
                        HStack {
                            Text(specialty)
                            Spacer()
                            if specialty == selectedSpecialty {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.tealBlue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSpecialty = specialty
                        }
                    }
                }
                
                Section("Sort By") {
                    ForEach(sortOptions, id: \.self) { option in
                        HStack {
                            Text(option)
                            Spacer()
                            if option == selectedSortOption {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.tealBlue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSortOption = option
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Clear") {
                    selectedSpecialty = "All"
                    selectedSortOption = "Distance"
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct DoctorDetailView: View {
    let doctor: Doctor
    @Binding var showBookingSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Doctor Header
                    VStack(spacing: 16) {
                        AsyncImage(url: URL(string: doctor.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        
                        VStack(spacing: 4) {
                            Text("Dr. \(doctor.name)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.tealBlue)
                            
                            Text(doctor.specialty)
                                .font(.headline)
                                .foregroundColor(.customPink)
                            
                            Text(doctor.hospital)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(doctor.rating) ? "star.fill" : "star")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                    }
                                    Text(String(format: "%.1f", doctor.rating))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Text("•")
                                    .foregroundColor(.gray)
                                
                                Text("\(doctor.distance, specifier: "%.1f") mi away")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Consultation Fee
                    HStack {
                        Text("Consultation Fee")
                            .font(.headline)
                        Spacer()
                        Text("$\(doctor.consultationFee)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.tealBlue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    // About
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(.tealBlue)
                        
                        Text(doctor.about)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    // Contact Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            if let url = URL(string: "tel://\(doctor.phoneNumber)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Call Now")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.customPink)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showBookingSheet = true
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Book Appointment")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.tealBlue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Doctor Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct BookingView: View {
    let doctor: Doctor
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedTime = "9:00 AM"
    @State private var appointmentType = "In-Person"
    @State private var reason = ""
    
    let timeSlots = ["9:00 AM", "10:00 AM", "11:00 AM", "2:00 PM", "3:00 PM", "4:00 PM"]
    let appointmentTypes = ["In-Person", "Video Call", "Phone Call"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Doctor") {
                    HStack {
                        AsyncImage(url: URL(string: doctor.imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Dr. \(doctor.name)")
                                .font(.headline)
                                .foregroundColor(.tealBlue)
                            Text(doctor.specialty)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("$\(doctor.consultationFee)")
                            .font(.headline)
                            .foregroundColor(.customPink)
                    }
                }
                
                Section("Appointment Details") {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Picker("Time", selection: $selectedTime) {
                        ForEach(timeSlots, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    
                    Picker("Type", selection: $appointmentType) {
                        ForEach(appointmentTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    TextField("Reason for visit", text: $reason, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Button(action: {
                        // Book appointment logic
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Book Appointment")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.tealBlue)
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}


struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let hospital: String
    let rating: Double
    let distance: Double
    let consultationFee: Int
    let isAvailableToday: Bool
    let phoneNumber: String
    let imageURL: String
    let about: String
    
    static let sampleDoctors = [
        Doctor(
            name: "Sarah Johnson",
            specialty: "Cardiology",
            hospital: "City Medical Center",
            rating: 4.8,
            distance: 1.2,
            consultationFee: 150,
            isAvailableToday: true,
            phoneNumber: "555-0123",
            imageURL: "https://example.com/doctor1.jpg",
            about: "Dr. Johnson is a board-certified cardiologist with over 15 years of experience in treating heart conditions."
        ),
        Doctor(
            name: "Michael Chen",
            specialty: "General Practice",
            hospital: "Community Health Clinic",
            rating: 4.6,
            distance: 0.8,
            consultationFee: 100,
            isAvailableToday: true,
            phoneNumber: "555-0124",
            imageURL: "https://example.com/doctor2.jpg",
            about: "Dr. Chen specializes in family medicine and preventive care, serving the community for over 10 years."
        ),
        Doctor(
            name: "Emily Rodriguez",
            specialty: "Dermatology",
            hospital: "Skin Care Institute",
            rating: 4.9,
            distance: 2.5,
            consultationFee: 175,
            isAvailableToday: false,
            phoneNumber: "555-0125",
            imageURL: "https://example.com/doctor3.jpg",
            about: "Dr. Rodriguez is a leading dermatologist specializing in skin cancer detection and cosmetic procedures."
        ),
        Doctor(
            name: "David Thompson",
            specialty: "Pediatrics",
            hospital: "Children's Hospital",
            rating: 4.7,
            distance: 1.8,
            consultationFee: 120,
            isAvailableToday: true,
            phoneNumber: "555-0126",
            imageURL: "https://example.com/doctor4.jpg",
            about: "Dr. Thompson has dedicated his career to pediatric care, ensuring the health and wellness of children."
        ),
        Doctor(
            name: "Lisa Park",
            specialty: "Orthopedics",
            hospital: "Sports Medicine Center",
            rating: 4.5,
            distance: 3.2,
            consultationFee: 200,
            isAvailableToday: false,
            phoneNumber: "555-0127",
            imageURL: "https://example.com/doctor5.jpg",
            about: "Dr. Park specializes in sports injuries and orthopedic surgery, helping athletes recover and perform."
        )
    ]
}

struct DoctorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSearchView()
    }
}
