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
}
