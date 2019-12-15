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
    var information: BehaviorRelay<InformationModel?> { get }
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
    private var actualIngredients: String = ""
    private var actualPage: Int = 1
    private var lastPage: Int = 0
    
    var recipes: BehaviorRelay<[Result]> = BehaviorRelay<[Result]>(value: [])
    var information: BehaviorRelay<InformationModel?> = BehaviorRelay<InformationModel?>(value: nil)
    
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        showInitialInformation()
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
                    self?.updateRecipes(with: recipe.results)
                    if recipe.results.isEmpty {
                        self?.showNoResultsInformation()
                    } else {
                        self?.information.accept(nil)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    private func showInitialInformation() {
        let info = InformationModel(image: UIImage(named: "recipes"),
                                    title: "What to cook?",
                                    description: "Type in the searchbox the ingredients you have at home")
        information.accept(info)
    }
    
    private func showNoResultsInformation() {
        let info = InformationModel(image: UIImage(named: "noResultsImage"),
                                    title: "No results",
                                    description: "Nothing matches your search")
        information.accept(info)
    }
    
    private func updateRecipes(with recipes: [Result]) {
        var newRecipes = self.recipes.value
        newRecipes.append(contentsOf: recipes)
        self.recipes.accept(newRecipes)
    }
    
    // MARK: - infinite scrolling
    
    func fetchMoreRecipes() {
        updateRecipes(with: actualIngredients, isNewQuery: false)
    }
    
    // MARK: - User Actions
    
    func searchQuery(queryString: String?) {
        if let ingredients = queryString, !ingredients.isEmpty{
            actualIngredients = ingredients
            updateRecipes(ingredients: ingredients, isNewQuery: true)
        } else {
            self.showInitialInformation()
        }
        
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
