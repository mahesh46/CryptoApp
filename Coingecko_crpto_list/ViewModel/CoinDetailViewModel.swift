//
//  CoinDetailViewModel.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//

import Foundation

@MainActor
class CoinDetailViewModel: ObservableObject {
    @Published var coinDetail: CoinDetail?
    @Published var chartData: [ChartDataPoint] = []
    @Published var isLoading = false

    private let apiKey = "CG-8TtEzEAAWPKyaKMnFtNxX24k"

    func fetchCoinDetails(for id: String) async {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(id)?x_cg_demo_api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            coinDetail = try JSONDecoder().decode(CoinDetail.self, from: data)
        } catch {
            print("Error fetching coin details: \(error)")
        }
    }

    func fetchChartData(for id: String) async {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(id)/market_chart?vs_currency=usd&days=7&x_cg_demo_api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MarketChartResponse.self, from: data)

            chartData = response.prices.compactMap { point -> ChartDataPoint? in
                guard point.count == 2, let timestamp = point.first, let price = point.last else { return nil }
                let date = Date(timeIntervalSince1970: timestamp / 1000)
                return ChartDataPoint(date: date, price: price)
            }
        } catch {
            print("Error fetching chart data: \(error)")
        }
    }
}

struct MarketChartResponse: Decodable {
    let prices: [[Double]]
}
