//
//  User.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 5/26/25.
//


import Foundation

struct User: Codable {
    let id: String
    let fullName: String
    let email: String
    let password: String
    let createdAt: Date
    
    init(fullName: String, email: String, password: String) {
        self.id = UUID().uuidString
        self.fullName = fullName
        self.email = email
        self.password = password
        self.createdAt = Date()
    }
}

class UserManager: ObservableObject {
    static let shared = UserManager()
    private let usersKey = "RegisteredUsers"
    
    private init() {}
    
    func saveUser(_ user: User) -> Bool {
        // Check if user already exists
        if userExists(email: user.email) {
            return false
        }
        
        var users = getAllUsers()
        users.append(user)
        
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: usersKey)
            return true
        } catch {
            print("Error saving user: \(error)")
            return false
        }
    }
    
    private func getAllUsers() -> [User] {
        guard let data = UserDefaults.standard.data(forKey: usersKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Error decoding users: \(error)")
            return []
        }
    }
    
    func userExists(email: String) -> Bool {
        let users = getAllUsers()
        return users.contains { $0.email.lowercased() == email.lowercased() }
    }
    
    func validateLogin(email: String, password: String) -> Bool {
        let users = getAllUsers()
        return users.contains { 
            $0.email.lowercased() == email.lowercased() && $0.password == password 
        }
    }
    
    func getUser(by email: String) -> User? {
        let users = getAllUsers()
        return users.first { $0.email.lowercased() == email.lowercased() }
    }
    
    func clearAllUsers() {
        UserDefaults.standard.removeObject(forKey: usersKey)
    }
}
