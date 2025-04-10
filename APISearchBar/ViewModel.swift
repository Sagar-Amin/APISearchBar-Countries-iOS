//
//  ViewModel.swift
//  APISearchBar
//
//  Created by Sagar Amin on 2/25/25.
//

import Foundation

@MainActor
class CountryViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([Country])
        case error(String)
    }
    
    private(set) var state: State = .loading {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let networkManager = NetworkManager.shared
    @Published var filteredCountries = [Country]() // The array to store filtered countries
    
    func fetchCountries() async {
        state = .loading
        
        do {
            let countries = try await networkManager.fetchCountries()
            self.state = .loaded(countries)
            self.filteredCountries = countries // Initially, display all countries
        } catch {
            self.state = .error("Failed to fetch countries: \(error.localizedDescription)")
        }
    }
    
    // Filter countries based on search text
    func filterCountries(by searchText: String) {
        if searchText.isEmpty {
            if case .loaded(let countries) = state {
                filteredCountries = countries // Show all if search text is empty
            }
        } else {
            if case .loaded(let countries) = state {
                filteredCountries = countries.filter { country in
                    country.name.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }
}
