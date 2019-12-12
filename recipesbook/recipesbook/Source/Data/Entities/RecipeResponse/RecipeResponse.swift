//
//  RecipeResponse.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation

// MARK: - Recipe
struct Recipe: Codable {
    let title: String
    let version: Double
    let href: String
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let title: String
    let href: String
    let ingredients: String
    let thumbnail: String
}
