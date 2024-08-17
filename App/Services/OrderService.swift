// App/Services/OrderService.swift

import Foundation
import Combine

class OrderService {
    static let shared = OrderService()

    private init() {}

    func fetchOrders() -> AnyPublisher<[Order], Error> {
        // Simulate fetching orders from an API
        let orders = [
            Order(id: "1", tableNumber: 1, items: [OrderItem(id: "1", name: "Pizza", quantity: 2, specialRequests: nil, price: 8.99)], status: .pending, createdAt: Date(), updatedAt: Date()),
            Order(id: "2", tableNumber: 2, items: [OrderItem(id: "2", name: "Salad", quantity: 1, specialRequests: nil, price: 5.99)], status: .preparing, createdAt: Date(), updatedAt: Date())
        ]

        return Future<[Order], Error> { promise in
            if Bool.random() {
                promise(.success(orders))
            } else {
                promise(.failure(NSError(domain: "OrderService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch orders"])))
            }
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func createOrder(order: Order) -> AnyPublisher<Order, Error> {
        // Simulate creating an order in an API
        return Future<Order, Error> { promise in
            if Bool.random() {
                promise(.success(order))
            } else {
                promise(.failure(NSError(domain: "OrderService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create order"])))
            }
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
