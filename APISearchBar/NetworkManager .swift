//
//  NetworkManager .swift
//  APISearchBar
//
//  Created by Sagar Amin on 2/25/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // Function to fetch data from the API
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let countries = try JSONDecoder().decode([Country].self, from: data)

        return countries
    }
}
