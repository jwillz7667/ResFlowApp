// App/Services/MenuService.swift

import Foundation
import Combine

class MenuService {
    static let shared = MenuService()

    private init() {}

    func fetchMenuItems() -> AnyPublisher<[MenuItem], Error> {
        // Simulate fetching data from an API
        let items = [
            MenuItem(id: "1", name: "Margherita Pizza", description: "Classic cheese pizza", price: 8.99, category: .entrees, isAvailable: true),
            MenuItem(id: "2", name: "Caesar Salad", description: "Crisp romaine with Caesar dressing", price: 5.99, category: .appetizers, isAvailable: true)
        ]

        return Future<[MenuItem], Error> { promise in
            promise(.success(items))
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func addMenuItem(item: MenuItem) -> AnyPublisher<MenuItem, Error> {
        // Simulate adding item to an API
        return Future<MenuItem, Error> { promise in
            promise(.success(item))
        }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
