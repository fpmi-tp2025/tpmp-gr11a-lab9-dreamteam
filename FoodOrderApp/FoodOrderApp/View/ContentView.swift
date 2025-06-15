//
//  ContentView.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RestaurantListView()
                .tabItem {
                    Label(NSLocalizedString("Restaurants", comment: ""), systemImage: "fork.knife")
                }
            OrderView()
                .tabItem {
                    Label(NSLocalizedString("Order Food", comment: ""), systemImage: "cart")
                }
            ProfileView()
                .tabItem {
                    Label(NSLocalizedString("Profile", comment: ""), systemImage: "person")
                }
        }
    }
}
