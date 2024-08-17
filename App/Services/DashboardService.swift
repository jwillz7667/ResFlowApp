// App/Services/DashboardService.swift

import Foundation
import Combine

class DashboardService {
    static let shared = DashboardService()

    private init() {}

    func fetchDashboardData() -> AnyPublisher<DashboardData, Error> {
        // Simulate a network call with a delay
        let dashboardData = DashboardData(
            totalSales: 10000.0,
            totalOrders: 150,
            topSellingItems: ["Pizza": 50, "Burger": 30, "Pasta": 20]
        )

        return Just(dashboardData)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct DashboardData {
    let totalSales: Double
    let totalOrders: Int
    let topSellingItems: [String: Int]
}
