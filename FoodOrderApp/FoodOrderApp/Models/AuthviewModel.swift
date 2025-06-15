//
//  AuthviewModel.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//

import Foundation
import SwiftUI

// Модель пользователя; все свойства поддерживают Codable и Hashable для удобства.
struct UserCredentials: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var username: String
    var password: String
}

final class AuthViewModel: ObservableObject {
    @Published var currentUser: UserCredentials?
    @Published var errorMessage: String = ""
    
    /// Регистрирует пользователя. Здесь проверяется, что поля не пустые, и что пароли совпадают.
    func register(username: String, password: String, confirmPassword: String) {
        guard !username.isEmpty else {
            errorMessage = NSLocalizedString("Username cannot be empty", comment: "")
            return
        }
        guard !password.isEmpty else {
            errorMessage = NSLocalizedString("Password cannot be empty", comment: "")
            return
        }
        guard password == confirmPassword else {
            errorMessage = NSLocalizedString("Passwords do not match", comment: "")
            return
        }
        let credentials = UserCredentials(username: username, password: password)
        if let encoded = try? JSONEncoder().encode(credentials) {
            UserDefaults.standard.set(encoded, forKey: "registeredUser")
            currentUser = credentials  // Можно сразу авторизовать пользователя после регистрации.
            errorMessage = ""
        } else {
            errorMessage = NSLocalizedString("Failed to register", comment: "")
        }
    }
    
    /// Пытается выполнить вход с введёнными данными.
    func login(username: String, password: String) {
        guard let data = UserDefaults.standard.data(forKey: "registeredUser"),
              let storedCredentials = try? JSONDecoder().decode(UserCredentials.self, from: data) else {
            errorMessage = NSLocalizedString("No registered user found", comment: "")
            return
        }
        if storedCredentials.username == username && storedCredentials.password == password {
            currentUser = storedCredentials
            errorMessage = ""
        } else {
            errorMessage = NSLocalizedString("Invalid username or password", comment: "")
        }
    }
    
    func logout() {
        currentUser = nil
    }
}
