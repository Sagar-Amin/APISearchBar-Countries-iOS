//
//  ContentView.swift
//  APISearchBar
//
//  Created by Sagar Amin on 2/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CountryViewModel()
    @State private var searchText = "" // To hold the search text
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search Countries", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onChange(of: searchText) { previousValue, newValue in
                        // Trigger filtering when text changes (newValue is the updated search text)
                        viewModel.filterCountries(by: newValue)
                    }
                
                // ScrollView - else if case, to show the list of countries
                ScrollView {
                    if case .loading = viewModel.state {
                        ProgressView("Loading countries...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if case .error(let message) = viewModel.state {
                        Text(message)
                            .foregroundColor(.red)
                    } else if case .loaded(let countries) = viewModel.state {
                        // List filtered countries
                        ForEach(viewModel.filteredCountries) { country in
                            VStack(alignment: .leading) {
                                Text(country.name) // Country name
                                    .font(.headline)
                                Text(country.capital ?? "No capital") // Country capital (optional)
                                    .font(.subheadline)
                                Text(country.alpha2Code ?? "No code") // Country code (optional)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            Divider()
                        }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.fetchCountries()
                    }
                }
                .navigationTitle("Countries")
            }
        }
    }
}
