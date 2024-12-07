//
//  Coin.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//

struct Coin: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let current_price: Double? // Include current price for display
}
