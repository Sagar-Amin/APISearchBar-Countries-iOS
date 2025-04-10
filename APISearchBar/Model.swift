//
//  Model.swift
//  APISearchBar
//
//  Created by Sagar Amin on 2/25/25.
//

import Foundation
struct Country: Identifiable, Codable {
    var id: String { name }
    let name: String
    let capital: String?
    let alpha2Code: String?
}
