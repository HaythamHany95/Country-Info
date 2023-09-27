//
//  Country.swift
//  Country Info
//
//  Created by Haytham on 20/09/2023.
//

import Foundation


struct Country: Decodable {
    let name: Name?
    let capital: [String]?
    let region: String?
    let population: Int?

}

// MARK: - Name
struct Name: Decodable {
    let official: String?
}
