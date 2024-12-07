//
//  CoinListViewModel.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//

import Foundation

enum SortOption: String, CaseIterable {
    case name = "Name"
    case price = "Price"
}

@MainActor
class CoinListViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var isLoading = false
    @Published var searchQuery: String = ""

    private let baseUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&x_cg_demo_api_key=CG-8TtEzEAAWPKyaKMnFtNxX24k"
    
    var filteredCoins: [Coin] {
        if searchQuery.isEmpty {
            return coins
        } else {
            return coins.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        }
    }

    func sortedCoins(by option: SortOption) -> [Coin] {
        switch option {
        case .name:
            return filteredCoins.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .price:
            return filteredCoins.sorted {
                ($0.current_price ?? 0) > ($1.current_price ?? 0)
            }
        }
    }

    func fetchCoins() async {
        guard let url = URL(string: baseUrl) else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            self.coins = coins
        } catch {
            print("Error fetching coins: \(error)")
        }
    }
}
