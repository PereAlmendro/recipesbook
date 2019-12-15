//
//  HomeInteractor.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomeInteractorProtocol {
    func fetchRecipes(query: String?, ingredients: String?, page: String?) -> Observable<Recipe>
    func fetchFavourites() -> Observable<Recipe>
    func saveFavourite(recipe: Result) -> Observable<Recipe>
    func deleteFavourite(recipe: Result) -> Observable<Recipe>
}

class HomeInteractor: HomeInteractorProtocol {
    
    private let baseUrl: String = "http://www.recipepuppy.com/api/?"
    private let sesion: URLSession = URLSession(configuration: .default)
    private let recipeRepository: RecipeRepository
    
    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }
    
    func fetchRecipes(query: String?, ingredients: String?, page: String?) -> Observable<Recipe> {
        return recipeRepository.fetchRecipes(query: query, ingredients: ingredients, page: page)
    }
    
    func fetchFavourites() -> Observable<Recipe> {
        return recipeRepository.fetchFavourites()
    }
    
    func saveFavourite(recipe: Result) -> Observable<Recipe> {
        return recipeRepository.saveFavourite(recipe: recipe)
    }
    
    func deleteFavourite(recipe: Result) -> Observable<Recipe> {
        return recipeRepository.deleteFavourite(recipe: recipe)
    }
}
