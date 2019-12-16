//
//  RecipeDetailPresenter.swift
//  recipesbook
//
//  Created by Pere Almendro on 14/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RecipeDetailPresenterProtocol {
    var detailUrl: URL? { get } 
}

class RecipeDetailPresenter: RecipeDetailPresenterProtocol {
    private var interactor: RecipeDetailInteractorProtocol
    private var router: RecipeDetailRouterProtocol
    var detailUrl: URL?
    
    init(interactor: RecipeDetailInteractorProtocol, router: RecipeDetailRouterProtocol, detailUrl: String) {
        self.interactor = interactor
        self.router = router
        self.detailUrl = URL(string: detailUrl)
    }
}
