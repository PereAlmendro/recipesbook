//
//  FavouritesInteractor.swift
//  recipesbook
//
//  Created by Pere Almendro on 16/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol FavouritesInteractorProtocol {
    func fetchFavourites() -> Observable<Recipe>
    func deleteFavourite(recipe: Result) -> Observable<Recipe>
}

class FavouritesInteractor: FavouritesInteractorProtocol {
    
    private let recipeRepository: RecipeRepository
 
    init(recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }
    
    func fetchFavourites() -> Observable<Recipe> {
        return recipeRepository.fetchFavourites()
    }
    
    func deleteFavourite(recipe: Result) -> Observable<Recipe> {
        return recipeRepository.deleteFavourite(recipe: recipe)
    }
}
