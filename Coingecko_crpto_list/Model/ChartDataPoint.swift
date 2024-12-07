//
//  ChartDataPoint.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//
import Foundation

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
