// App/ViewModels/InventoryManagement/InventoryViewModel.swift

import Foundation
import Combine

class InventoryViewModel: ObservableObject {
    @Published var inventoryItems: [InventoryItem] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func loadInventoryItems() {
        InventoryService.shared.fetchInventoryItems()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] items in
                self?.inventoryItems = items
            }
            .store(in: &cancellables)
    }

    func addItem(_ item: InventoryItem) {
        InventoryService.shared.addInventoryItem(item: item)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] newItem in
                self?.inventoryItems.append(newItem)
            }
            .store(in: &cancellables)
    }
}
