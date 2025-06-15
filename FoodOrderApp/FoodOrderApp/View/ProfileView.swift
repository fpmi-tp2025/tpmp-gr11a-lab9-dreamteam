//
//  ProfileView.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//


import SwiftUI

struct ProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            if let currentUser = authViewModel.currentUser {
                // Если пользователь уже авторизован, выводим приветствие и кнопку выхода
                VStack(spacing: 20) {
                    Text("\(NSLocalizedString("Welcome", comment: "")), \(currentUser.username)!")
                        .font(.title)
                        .padding()
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text(NSLocalizedString("Logout", comment: ""))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle(Text(NSLocalizedString("Profile", comment: "")), displayMode: .inline)
            } else {
                // Если пользователь не авторизован, показываем экран входа
                LoginView(authViewModel: authViewModel)
                    .navigationBarTitle(Text(NSLocalizedString("Login", comment: "")), displayMode: .inline)
            }
        }
    }
}
