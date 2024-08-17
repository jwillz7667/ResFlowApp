// App/ViewModels/Dashboard/DashboardViewModel.swift

import Combine

class DashboardViewModel: ObservableObject {
    @Published var totalSales: Double = 0.0
    @Published var totalOrders: Int = 0
    @Published var topSellingItems: [String: Int] = [:]
    @Published var errorMessage: String?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()

    func loadDashboardData() {
        self.isLoading = true

        let query = """
        query {
            dashboard {
                totalSales
                totalOrders
                topSellingItems {
                    item
                    count
                }
            }
        }
        """

        if let cachedData: DashboardData = GraphQLManager.shared.cachedResponse(for: query) {
            self.totalSales = cachedData.totalSales
            self.totalOrders = cachedData.totalOrders
            self.topSellingItems = cachedData.topSellingItems
            self.isLoading = false
        } else {
            GraphQLManager.shared.performQuery(query: query)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = "Failed to load dashboard data: \(error.localizedDescription)"
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] (data: DashboardData) in
                    self?.totalSales = data.totalSales
                    self?.totalOrders = data.totalOrders
                    self?.topSellingItems = data.topSellingItems
                }
                .store(in: &cancellables)
        }
    }
}

struct DashboardData: Decodable {
    let totalSales: Double
    let totalOrders: Int
    let topSellingItems: [String: Int]
}
