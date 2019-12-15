//
//  HomePresenter.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol HomePresenterProtocol {
    var recipes: BehaviorRelay<[Result]> { get }
    func viewDidLoad()
    func makeFavourite(recipe: Result)
    func fetchMoreRecipes()
    func navigationBarRightButtonAction()
    func openDetail(recipe: Result)
    func searchQuery(queryString: String?)
}

class HomePresenter: HomePresenterProtocol {
    
    private let disposeBag = DisposeBag()
    private var interactor: HomeInteractorProtocol? = nil
    private var router: HomeRouterProtocol? = nil
    private var actualIngredients: String = "a" // "a" will be the first search
    private var actualPage: Int = 1
    private var lastPage: Int = 0
    
    var recipes: BehaviorRelay<[Result]> = BehaviorRelay<[Result]>(value: [])
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        updateRecipes(with: actualIngredients, isNewQuery: true)
    }
    
    private func updateRecipes(with query: String = "", ingredients: String = "", isNewQuery: Bool) {
        if isNewQuery {
            actualPage = 1
            lastPage = 0
        }
        let page = String(actualPage)
        
        if actualPage != lastPage {
            self.lastPage = actualPage
            
            interactor?.fetchRecipes(query: query, ingredients: ingredients, page: page)
                .subscribe({ [weak self] (item) in
                    self?.actualPage += 1
                    guard let recipe = item.element else { return }
                    if isNewQuery {
                        self?.recipes.accept(recipe.results)
                    } else {
                        var newResults = self?.recipes.value
                        newResults?.append(contentsOf: recipe.results)
                        guard let results = newResults else { return }
                        self?.recipes.accept(results)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - infinite scrolling
    
    func prefetchItems(at IndexPaths: [IndexPath]) {
        
    }
    
    func fetchMoreRecipes() {
        updateRecipes(with: actualIngredients, isNewQuery: false)
    }
    
    // MARK: - User Actions
    
    func searchQuery(queryString: String?) {
        guard let ingredients = queryString else { return }
        actualIngredients = ingredients
        updateRecipes(ingredients: ingredients, isNewQuery: true)
    }
    
    func makeFavourite(recipe: Result) {
        // TODO: Save locally
    }
    
    func navigationBarRightButtonAction() {
        // TODO: Open saved favourites screen
    }
    
    func openDetail(recipe: Result) {
        router?.openRecipeDetailWithRequest(recipe.href)
    }
}
