//
//  CoinDetail.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//

struct CoinDetail: Decodable {
    let id: String
    let symbol: String
    let name: String
    let description: Description?
    let links: Links?
    let market_data: MarketData?

    struct Description: Decodable {
        let en: String?
    }

    struct Links: Decodable {
        let homepage: [String]?
    }

    struct MarketData: Decodable {
        let current_price: [String: Double]?
        let high_24h: [String: Double]?
        let low_24h: [String: Double]?
    }
}
