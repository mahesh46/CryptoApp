//
//  ContentView.swift
//  Coingecko_crpto_list
//
//  Created by mahesh lad on 07/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CoinListViewModel()
    @State private var selectedSortOption: SortOption = .name // Default sorting by name

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search by name...", text: $viewModel.searchQuery)
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Sorting options
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading Coins...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredCoins.isEmpty {
                        Text("No coins available")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(viewModel.sortedCoins(by: selectedSortOption)) { coin in
                            NavigationLink(destination: CoinDetailView(coinID: coin.id)) {
                                HStack {
                                    // Load and display the thumbnail
                                    if let imageUrl = coin.image, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(20)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(coin.name)
                                            .font(.headline)
                                        Text(coin.symbol.uppercased())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    // Display current price
                                    if let price = coin.current_price {
                                        Text("$\(String(format: "%.2f", price))")
                                            .font(.body)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Crypto Currencies")
                .task {
                    await viewModel.fetchCoins()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
