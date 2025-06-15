//
//  LoginView.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(NSLocalizedString("Login", comment: ""))
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                TextField(NSLocalizedString("Username", comment: ""), text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField(NSLocalizedString("Password", comment: ""), text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    authViewModel.login(username: username, password: password)
                }) {
                    Text(NSLocalizedString("Login", comment: ""))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                NavigationLink(destination: RegistrationView(authViewModel: authViewModel)) {
                    Text(NSLocalizedString("Don't have an account? Register", comment: ""))
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
