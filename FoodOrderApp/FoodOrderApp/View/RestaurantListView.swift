//
//  Restaurant.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//


import SwiftUI
import MapKit

// Модель ресторана
struct Restaurant1: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

// ViewModel для списка ресторанов
class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant1] = []
    
    init() {
        // В реальном приложении данные загружаются из локальной SQLite БД.
        // Здесь для демонстрации используется статический массив.
        restaurants = [
            Restaurant1(name: NSLocalizedString("Pizza Place", comment: ""),
                       address: "123 Main St",
                       coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
            Restaurant1(name: NSLocalizedString("Sushi Bar", comment: ""),
                       address: "456 Center St",
                       coordinate: CLLocationCoordinate2D(latitude: 37.7780, longitude: -122.4170))
        ]
    }
}

// Представление списка ресторанов
struct RestaurantListView: View {
    @StateObject var viewModel = RestaurantListViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, annotationItems: viewModel.restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        VStack {
                            Text(restaurant.name)
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(8)
                            Image(systemName: "mappin")
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: 300)
                
                List(viewModel.restaurants) { restaurant in
                    VStack(alignment: .leading) {
                        Text(restaurant.name)
                            .font(.headline)
                        Text(restaurant.address)
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Restaurants", comment: "")), displayMode: .inline)
        }
    }
}
