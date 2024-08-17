// App/Services/InventoryService.swift

import Foundation
import Combine

class InventoryService {
    static let shared = InventoryService()

    private init() {}

    func fetchInventoryItems() -> AnyPublisher<[InventoryItem], Error> {
        // Simulate fetching data from an API
        let items = [
            InventoryItem(id: "1", name: "Cheese", quantity: 10, supplier: nil, reorderLevel: 5, unitPrice: 2.50),
            InventoryItem(id: "2", name: "Tomato Sauce", quantity: 20, supplier: nil, reorderLevel: 10, unitPrice: 1.75)
        ]

        return Future<[InventoryItem], Error> { promise in
            if Bool.random() {
                promise(.success(items))
            } else {
                promise(.failure(NSError(domain: "InventoryService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch inventory items"])))
            }
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func addInventoryItem(item: InventoryItem) -> AnyPublisher<InventoryItem, Error> {
        // Simulate adding item to an API
        return Future<InventoryItem, Error> { promise in
            if Bool.random() {
                promise(.success(item))
            } else {
                promise(.failure(NSError(domain: "InventoryService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to add inventory item"])))
            }
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
