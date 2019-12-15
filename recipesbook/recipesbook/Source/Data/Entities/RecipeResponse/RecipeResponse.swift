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
    var title: String
    var version: Double
    var href: String
    var results: [Result]
}

// MARK: - Result
struct Result: Codable, Equatable {
    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
}
