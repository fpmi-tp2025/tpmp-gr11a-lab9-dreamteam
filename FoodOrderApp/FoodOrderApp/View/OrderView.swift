//
//  OrderView.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//

import SwiftUI

struct OrderView: View {
    @StateObject var viewModel = OrderViewModel()
    
    // Пример списка блюд
    let dishes: [Dish] = [
        Dish(name: NSLocalizedString("Margherita Pizza", comment: ""),
             description: NSLocalizedString("Classic cheese pizza", comment: ""),
             price: 10.0),
        Dish(name: NSLocalizedString("Sushi Roll", comment: ""),
             description: NSLocalizedString("Fresh sushi with salmon", comment: ""),
             price: 12.0)
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Select Dish", comment: ""))) {
                    Picker(selection: $viewModel.selectedDish, label: Text(NSLocalizedString("Dish", comment: ""))) {
                        ForEach(dishes) { dish in
                            Text("\(dish.name) - $\(dish.price, specifier: "%.2f")")
                                .tag(Optional(dish))
                        }
                    }
                    .accessibilityIdentifier("dishPicker")
                }

                Section(header: Text(NSLocalizedString("Quantity", comment: ""))) {
                    Stepper(value: $viewModel.quantity, in: 1...10) {
                        Text("\(viewModel.quantity)")
                    }
                }
                Section(header: Text(NSLocalizedString("Payment Method", comment: ""))) {
                    Picker(selection: $viewModel.paymentMethod, label: Text(NSLocalizedString("Payment", comment: ""))) {
                        ForEach(OrderViewModel.PaymentMethod.allCases) { method in
                            Text(method.localized())
                                .tag(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text(NSLocalizedString("Delivery Address", comment: ""))) {
                    TextField(NSLocalizedString("Enter address", comment: ""), text: $viewModel.address)
                }
                Section(header: Text(NSLocalizedString("Additional Comments", comment: ""))) {
                    TextField(NSLocalizedString("Details", comment: ""), text: $viewModel.comments)
                }
                if !viewModel.errorMessage.isEmpty {
                    Section {
                        Text(viewModel.errorMessage)
                            .foregroundColor(viewModel.errorMessage == NSLocalizedString("Order placed successfully", comment: "") ? .green : .red)
                    }
                }
                Section {
                    Button(action: {
                        viewModel.placeOrder()
                    }) {
                        Text(NSLocalizedString("Place Order", comment: ""))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Order Food", comment: "")), displayMode: .inline)
        }
    }
}



