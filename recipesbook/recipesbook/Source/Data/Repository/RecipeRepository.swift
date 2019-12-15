//
//  RecipeRepository.swift
//  recipesbook
//
//  Created by Pere Almendro on 12/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RecipeRepositoryProtocol {
    func fetchRecipes(query: String?, ingredients: String?, page: String?) -> Observable<Recipe>
    func fetchFavourites() -> Observable<Recipe>
    func saveFavourite(recipe: Result) -> Observable<Recipe>
    func deleteFavourite(recipe: Result) -> Observable<Recipe>
}

class RecipeRepository {
    private let favouritesUserDefaultsKey = "favouritesUserdefaultsKey"
    private let baseUrl: String = "http://www.recipepuppy.com/api/?"
    private let sesion: URLSession = URLSession(configuration: .default)
    
    func fetchRecipes(query: String?, ingredients: String?, page: String?) -> Observable<Recipe> {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "i", value: ingredients),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "p", value: page)
        ]
        
        guard let url = components?.url else {
            let error = ServiceError(localizedDescription: "Invalid Request")
            return Observable.error(error)
        }
        
        let request = URLRequest(url: url)
        return sesion.rx.response(request: request).map { (response, data) -> Recipe in
            if 200 ..< 300 ~= response.statusCode {
                return try JSONDecoder().decode(Recipe.self, from: data)
            } else {
                throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }
        }
    }
    
    func fetchFavourites() -> Observable<Recipe> {
        return Observable.create({ [weak self] observer in
            let favourites = self?.getRecipe()
            if let recipe = favourites {
                observer.onNext(recipe)
            } else {
                let error = ServiceError(localizedDescription: "Unable to fetch recipe")
                observer.onError(error)
            }
            return Disposables.create { }
        })
    }
    
    func saveFavourite(recipe: Result) -> Observable<Recipe> {
         return Observable.create({ [weak self] observer in
            var savedFavourites = self?.getRecipe()
            if savedFavourites == nil {
                // Any favourite has been added yet, init Favourites and save element
                savedFavourites = Recipe(title: "Favourites", version: 1, href: "", results: [])
            }
            if var favourites = savedFavourites {
                favourites.results.append(recipe)
                if self?.saveRecipe(recipe: favourites) ?? false {
                    observer.onNext(favourites)
                } else {
                    let error = ServiceError(localizedDescription: "Unable to save recipe")
                    observer.onError(error)
                }
            }
            return Disposables.create { }
        })
    }
    
    func deleteFavourite(recipe: Result) -> Observable<Recipe> {
        return Observable.create({ [weak self] observer in
            if var favourites = self?.getRecipe() {
                favourites.results.removeAll { (result) -> Bool in
                    return (result == recipe)
                }
                observer.onNext(favourites)
            }
            return Disposables.create { }
        })
    }
    
    private func saveRecipe(recipe: Recipe) -> Bool {
        let userDefaults = UserDefaults.standard
        do {
            let jsonData = try JSONEncoder().encode(recipe)
            userDefaults.set(jsonData, forKey: favouritesUserDefaultsKey)
            return true
        } catch {
            return false
        }
    }
    
    private func getRecipe() -> Recipe? {
        let userDefaults = UserDefaults.standard
        do {
            let favouritesSaved = userDefaults.object(forKey: favouritesUserDefaultsKey)
            guard let favouritesSavedUnwrapped = favouritesSaved as? Data else { return nil }
            return try JSONDecoder().decode(Recipe.self, from: favouritesSavedUnwrapped)
        } catch {
            return nil
        }
    }
}
