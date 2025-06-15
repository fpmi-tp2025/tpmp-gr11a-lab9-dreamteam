//
//  RegistrationView.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//


import SwiftUI

struct RegistrationView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("Register", comment: ""))
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            TextField(NSLocalizedString("Username", comment: ""), text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField(NSLocalizedString("Password", comment: ""), text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField(NSLocalizedString("Confirm Password", comment: ""), text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                authViewModel.register(username: username, password: password, confirmPassword: confirmPassword)
            }) {
                Text(NSLocalizedString("Register", comment: ""))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
}
