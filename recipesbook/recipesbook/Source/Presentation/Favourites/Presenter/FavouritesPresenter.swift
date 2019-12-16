//
//  FavouritesPresenter.swift
//  recipesbook
//
//  Created by Pere Almendro on 16/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import RxCocoa
import RxSwift

protocol FavouritesPresenterProtocol {
    var information: BehaviorRelay<InformationModel?> { get }
    var recipes: BehaviorRelay<[Result]> { get }
    func viewDidLoad()
    func deleteFavourite(recipe: Result)
    func openDetail(recipe: Result)
}

class FavouritesPresenter: FavouritesPresenterProtocol {
    private var interactor: FavouritesInteractorProtocol
    private var router: FavouritesRouterProtocol
    
    var recipes: BehaviorRelay<[Result]> = BehaviorRelay<[Result]>(value: [])
    var information: BehaviorRelay<InformationModel?> = BehaviorRelay<InformationModel?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init(interactor: FavouritesInteractorProtocol, router: FavouritesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        updateFavourites()
    }
    
    private func updateFavourites() {
        interactor.fetchFavourites().subscribe({ [weak self] event in
            if let recipes = event.element, recipes.results.isEmpty {
                self?.showInitialInformation()
            } else {
                guard let recipe = event.element else { return }
                self?.recipes.accept(recipe.results)
            }
        }).disposed(by: disposeBag)
    }
    
    private func showInitialInformation() {
        let informationModel = InformationModel(image: UIImage(named: "favourites"),
                                           title: "Favourites page",
                                           description: "Look for recipes at home page and save your favourites to access them in this section")
        information.accept(informationModel)
    }
    
    func deleteFavourite(recipe: Result) {
        interactor.deleteFavourite(recipe: recipe).subscribe({ [weak self] event in
            let title = "Recipe removed"
            var message = ""
            if let error = event.error as? ServiceError, error.type == .operationFailed {
                message = error.localizedDescription
            } else {
                self?.updateFavourites()
            }
            self?.router.showAlert(title: title,
                                   message: message,
                                   action: "Close",
                                   style: .default,
                                   handler: nil)
        }).disposed(by: disposeBag)
    }
    
    func openDetail(recipe: Result) {
        router.openRecipeDetailWithRequest(recipe.href)
    }
}
