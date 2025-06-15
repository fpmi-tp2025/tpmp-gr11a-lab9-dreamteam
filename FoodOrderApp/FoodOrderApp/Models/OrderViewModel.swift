//
//  OrderViewModel.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//

import SwiftUI

// Модель блюда уже должна соответствовать Hashable (см. предыдущий пример)
struct Dish: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
}

class OrderViewModel: ObservableObject {
    @Published var selectedDish: Dish?
    @Published var quantity: Int = 1
    @Published var comments: String = ""
    @Published var paymentMethod: PaymentMethod = .online
    @Published var address: String = ""
    @Published var errorMessage: String = ""
    
    // Способы оплаты
    enum PaymentMethod: String, CaseIterable, Identifiable {
        case online = "Online"
        case erip = "ERIP"
        case terminal = "Terminal"
        case cash = "Cash"
        
        var id: String { self.rawValue }
        
        func localized() -> String {
            switch self {
            case .online: return NSLocalizedString("Online", comment: "")
            case .erip: return NSLocalizedString("ERIP", comment: "")
            case .terminal: return NSLocalizedString("Terminal", comment: "")
            case .cash: return NSLocalizedString("Cash", comment: "")
            }
        }
    }
    
    /// Метод для оформления заказа
    func placeOrder() {
        // Дополнительная логика проверки
        guard let dish = selectedDish else {
            errorMessage = NSLocalizedString("Select a dish before placing order", comment: "")
            return
        }
        
        guard !address.isEmpty else {
            errorMessage = NSLocalizedString("Address is required", comment: "")
            return
        }
        
        // Вставка заказа в базу данных
        if let insertedRowId = DatabaseManager.shared.insertOrder(dish: dish.name,
                                                                  quantity: quantity,
                                                                  paymentMethod: paymentMethod.rawValue,
                                                                  address: address,
                                                                  comments: comments) {
            print("Order successfully recorded with id \(insertedRowId)")
            errorMessage = NSLocalizedString("Order placed successfully", comment: "")
            
            // Дополнительное действие: очистка заказа после успешного оформления
            selectedDish = nil
            quantity = 1
            address = ""
            comments = ""
        } else {
            errorMessage = NSLocalizedString("Failed to record order", comment: "")
        }
    }
}
