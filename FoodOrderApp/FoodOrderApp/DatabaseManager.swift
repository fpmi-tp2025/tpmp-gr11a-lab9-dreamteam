//
//  DatabaseManager.swift
//  FoodOrderApp
//
//  Created by Shvarsman on 18.05.25.
//

import Foundation
import SQLite

// Структура, описывающая заказ (для выборки заказов из БД)
struct Order: Identifiable {
    let id: Int64
    let dish: String
    let quantity: Int
    let paymentMethod: String
    let address: String
    let comments: String
}

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: Connection?
    
    // Определение столбцов таблицы
    private let orders = Table("orders")
    private let id = Expression<Int64>("id")
    private let dishExp = Expression<String>("dish")
    private let quantityExp = Expression<Int>("quantity")
    private let paymentMethodExp = Expression<String>("paymentMethod")
    private let addressExp = Expression<String>("address")
    private let commentsExp = Expression<String>("comments")
    
    private init() {
        do {
            // Современный способ получения пути к документам
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: true)
            // Формируем путь к файлу базы данных
            let fileUrl = documentDirectory.appendingPathComponent("food_order").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTables()
        } catch {
            print("Database connection error: \(error)")
        }
    }
    
    private func createTables() {
        do {
            try db?.run(orders.create(ifNotExists: true, block: { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(dishExp)
                table.column(quantityExp)
                table.column(paymentMethodExp)
                table.column(addressExp)
                table.column(commentsExp)
            }))
            print("Orders table created successfully")
        } catch {
            print("Create table error: \(error)")
        }
    }
    
    /// Метод для вставки заказа в таблицу
    func insertOrder(dish: String, quantity: Int, paymentMethod: String, address: String, comments: String) -> Int64? {
        let insert = orders.insert(dishExp <- dish,
                                   quantityExp <- quantity,
                                   paymentMethodExp <- paymentMethod,
                                   addressExp <- address,
                                   commentsExp <- comments)
        do {
            let rowId = try db?.run(insert)
            return rowId
        } catch {
            print("Insert order error: \(error)")
            return nil
        }
    }
    
    /// Метод для выборки всех заказов (при необходимости можно использовать для истории)
    func fetchOrders() -> [Order] {
        var ordersArray: [Order] = []
        do {
            for orderRow in try db!.prepare(orders) {
                let order = Order(id: orderRow[id],
                                  dish: orderRow[dishExp],
                                  quantity: orderRow[quantityExp],
                                  paymentMethod: orderRow[paymentMethodExp],
                                  address: orderRow[addressExp],
                                  comments: orderRow[commentsExp])
                ordersArray.append(order)
            }
        } catch {
            print("Fetch orders error: \(error)")
        }
        return ordersArray
    }
}
