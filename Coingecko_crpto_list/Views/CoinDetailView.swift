//
//  CoinDetailView.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//
import SwiftUI
import Charts

struct CoinDetailView: View {
    @StateObject private var viewModel = CoinDetailViewModel()
    @State private var isDescriptionExpanded = false
    let coinID: String

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    loadingView
                } else if let coinDetail = viewModel.coinDetail {
                    ScrollView {
                        content(for: coinDetail)
                    }
                } else {
                    errorView
                }
            }
            .navigationTitle("Coin Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchCoinDetails(for: coinID)
                await viewModel.fetchChartData(for: coinID)
            }
        }
    }

    // MARK: - Loading View
    private var loadingView: some View {
        VStack {
            ProgressView("Loading Coin Details...")
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .padding()
            Text("Please wait while we fetch the latest data.")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }

    // MARK: - Error View
    private var errorView: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            Text("Unable to load details")
                .font(.headline)
                .padding(.top, 4)
            Text("Please check your internet connection and try again.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }

    // MARK: - Content View
    private func content(for coinDetail: CoinDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection(for: coinDetail)
            Divider()
            marketDataSection(for: coinDetail)
            Divider()
            if !viewModel.chartData.isEmpty {
                chartSection
            } else {
                Text("Loading chart data...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding()
    }

    // MARK: - Header Section
    private func headerSection(for coinDetail: CoinDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(coinDetail.name)
                .font(.title)
                .bold()
            
            Text(coinDetail.symbol.uppercased())
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let description = coinDetail.description?.en, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(isDescriptionExpanded ? nil : 3)
                    .truncationMode(.tail)
                    .onTapGesture {
                        withAnimation {
                            isDescriptionExpanded.toggle()
                        }
                    }
                    .overlay(
                        isDescriptionExpanded ? nil : gradientOverlay
                    )
                    .padding(.top, 4)
            } else {
                Text("No description available.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var gradientOverlay: some View {
        LinearGradient(
            colors: [Color.white.opacity(0.0), Color.white],
            startPoint: .center,
            endPoint: .bottom
        )
        .frame(height: 20)
        .allowsHitTesting(false)
    }

    // MARK: - Market Data Section
    private func marketDataSection(for coinDetail: CoinDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let currentPrice = coinDetail.market_data?.current_price?["usd"] {
                Text("Current Price: $\(String(format: "%.2f", currentPrice))")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            HStack {
                if let high = coinDetail.market_data?.high_24h?["usd"] {
                    Text("High (24h): $\(String(format: "%.2f", high))")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                if let low = coinDetail.market_data?.low_24h?["usd"] {
                    Text("Low (24h): $\(String(format: "%.2f", low))")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
        }
    }

    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("7-Day Price Chart")
                .font(.headline)
                .padding(.bottom, 8)
            
            Chart(viewModel.chartData) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Price", $0.price)
                )
                .foregroundStyle(.blue)
            }
            .frame(height: 200)
            .background(Color(UIColor.systemGroupedBackground))
            .cornerRadius(8)
        }
    }
}

#Preview {
    CoinDetailView(coinID: "0dog")
}
