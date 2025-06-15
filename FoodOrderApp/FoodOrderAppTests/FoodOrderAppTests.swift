//
//  FoodOrderAppTests.swift
//  FoodOrderAppTests
//
//  Created by Shvarsman on 18.05.25.
//

import XCTest
@testable import FoodOrderApp // замените на имя вашего основного модуля

class DatabaseManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Очищаем таблицу заказов перед выполнением каждого теста.
        if let db = DatabaseManager.shared.db {
            do {
                // Выполняем сырый SQL-запрос для удаления всех записей из таблицы orders.
                try db.run("DELETE FROM orders")
            } catch {
                XCTFail("Не удалось очистить таблицу orders: \(error)")
            }
        } else {
            XCTFail("Подключение к базе данных равно nil")
        }
    }
    
    override func tearDownWithError() throws {
        // Если необходимо, можно добавить очистку после теста.
    }
    
    /// Тестирует метод вставки заказа.
    func testInsertOrder() throws {
        // Arrange: задаём тестовые данные для заказа.
        let dish = "Test Dish"
        let quantity = 5
        let paymentMethod = "Online"
        let address = "Test Address"
        let comments = "Test Comments"
        
        // Act: вставляем заказ через DatabaseManager.
        guard let rowId = DatabaseManager.shared.insertOrder(dish: dish, quantity: quantity, paymentMethod: paymentMethod, address: address, comments: comments) else {
            XCTFail("Метод insertOrder вернул nil")
            return
        }
        
        // Assert: проверяем, что rowId положительный.
        XCTAssertTrue(rowId > 0, "Идентификатор вставленной записи должен быть положительным числом.")
    }
    
    /// Тестирует, что после вставки нескольких заказов их можно корректно извлечь.
    func testFetchOrders() throws {
        // Arrange: вставляем два заказа.
        let order1Id = DatabaseManager.shared.insertOrder(dish: "Dish 1", quantity: 1, paymentMethod: "Cash", address: "Address 1", comments: "Comments 1")
        XCTAssertNotNil(order1Id)
        let order2Id = DatabaseManager.shared.insertOrder(dish: "Dish 2", quantity: 2, paymentMethod: "Online", address: "Address 2", comments: "Comments 2")
        XCTAssertNotNil(order2Id)
        
        // Act: получаем список заказов из базы данных.
        let orders = DatabaseManager.shared.fetchOrders()
        
        // Assert: убеждаемся, что количество заказов соответствует ожиданиям.
        XCTAssertGreaterThanOrEqual(orders.count, 2, "В базе данных должно быть не менее 2 заказов")
        
        // Проверяем конкуретные заказы.
        if let order1 = orders.first(where: { $0.dish == "Dish 1" }) {
            XCTAssertEqual(order1.quantity, 1)
            XCTAssertEqual(order1.paymentMethod, "Cash")
            XCTAssertEqual(order1.address, "Address 1")
            XCTAssertEqual(order1.comments, "Comments 1")
        } else {
            XCTFail("Заказ с названием 'Dish 1' не найден")
        }
        
        if let order2 = orders.first(where: { $0.dish == "Dish 2" }) {
            XCTAssertEqual(order2.quantity, 2)
            XCTAssertEqual(order2.paymentMethod, "Online")
            XCTAssertEqual(order2.address, "Address 2")
            XCTAssertEqual(order2.comments, "Comments 2")
        } else {
            XCTFail("Заказ с названием 'Dish 2' не найден")
        }
    }
    
    /// Тестирует комбинированную вставку и последующую выборку конкретного заказа.
    func testInsertAndFetchOrder() throws {
        // Arrange: вставляем заказ с тестовыми данными.
        let dish = "Combined Test Dish"
        let quantity = 3
        let paymentMethod = "Terminal"
        let address = "Combined Address"
        let comments = "Combined Comments"
        
        guard let insertedRowId = DatabaseManager.shared.insertOrder(dish: dish, quantity: quantity, paymentMethod: paymentMethod, address: address, comments: comments) else {
            XCTFail("Вставка заказа вернула nil")
            return
        }
        
        // Act: получаем список заказов и ищем вставленный заказ.
        let orders = DatabaseManager.shared.fetchOrders()
        guard let order = orders.first(where: { $0.id == insertedRowId }) else {
            XCTFail("Заказ с id \(insertedRowId) не найден")
            return
        }
        
        // Assert: сверяем данные заказа с ожидаемыми.
        XCTAssertEqual(order.dish, dish)
        XCTAssertEqual(order.quantity, quantity)
        XCTAssertEqual(order.paymentMethod, paymentMethod)
        XCTAssertEqual(order.address, address)
        XCTAssertEqual(order.comments, comments)
    }
}
