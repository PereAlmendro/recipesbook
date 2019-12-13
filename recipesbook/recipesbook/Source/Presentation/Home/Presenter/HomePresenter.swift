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
}

class HomePresenter: HomePresenterProtocol {
    
    private let disposeBag = DisposeBag()
    private var interactor: HomeInteractorProtocol? = nil
    private var router: HomeRouterProtocol? = nil
    private var actualQuery: String = "a" // "a" will be the first search
    private var actualPage: Int = 1
    private var lastPage: Int = 0
    
    var recipes: BehaviorRelay<[Result]> = BehaviorRelay<[Result]>(value: [])
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        updateRecipes(with: actualQuery, isNewQuery: true)
    }
    
    private func updateRecipes(with query: String, isNewQuery: Bool) {
        if isNewQuery {
            actualPage = 1
        }
        let page = String(actualPage)
        
        if actualPage != lastPage {
            self.lastPage = actualPage
            
            interactor?.fetchRecipes(query: query, ingredients: "", page: page)
                .subscribe({ [weak self] (item) in
                    self?.actualPage += 1
                    guard let recipe = item.element else { return }
                    
                    var newResults = self?.recipes.value
                    newResults?.append(contentsOf: recipe.results)
                    
                    guard let results = newResults else { return }
                    self?.recipes.accept(results)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - infinite scrolling
    
    func prefetchItems(at IndexPaths: [IndexPath]) {
        
    }
    
    func fetchMoreRecipes() {
        updateRecipes(with: actualQuery, isNewQuery: false)
    }
    
    // MARK: - User Actions
    
    func searchQuery(queryString: String) {
        actualQuery = queryString
        updateRecipes(with: queryString, isNewQuery: true)
    }
    
    func makeFavourite(recipe: Result) {
        // TODO: Save locally
    }
    
    func navigationBarRightButtonAction() {
        // TODO: Open saved favourites screen
    }
}
