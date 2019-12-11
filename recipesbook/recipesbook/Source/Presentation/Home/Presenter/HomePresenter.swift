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
    var recipes: PublishSubject<[Result]> { get }
    func viewDidLoad()
    func makeFavourite(recipe: Result)
}

class HomePresenter: HomePresenterProtocol {
    
    private let disposeBag = DisposeBag()
    private var interactor: HomeInteractorProtocol? = nil
    private var router: HomeRouterProtocol? = nil
    private var actualQuery: String = "a"
    private var actualPage: Int = 1
    
    var recipes: PublishSubject<[Result]> = PublishSubject()
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        updateRecipes(with: "a", isNewQuery: true)
    }
    
    private func updateRecipes(with query: String, isNewQuery: Bool) {
        if isNewQuery {
            actualPage = 1
        }
        let page = String(actualPage)
        
        interactor?.fetchRecipes(query: query, ingredients: "", page: page)
            .subscribe({ [weak self] (item) in
                guard let recipe = item.element else { return }
                self?.recipes.onNext(recipe.results)
                self?.actualPage += 1
        }).disposed(by: disposeBag)
    }
    
    // MARK: - User Actions
    
    func searchQuery(queryString: String) {
        updateRecipes(with: queryString, isNewQuery: true)
    }
    
    func makeFavourite(recipe: Result) {
        
    }
}
