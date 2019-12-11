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
}
