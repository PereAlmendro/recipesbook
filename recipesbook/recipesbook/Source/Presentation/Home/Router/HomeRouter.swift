//
//  HomeRouter.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation
import UIKit


protocol HomeRouterProtocol {
    func openRecipeDetailWithRequest(_ request: String)
}

class HomeRouter: HomeRouterProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func openRecipeDetailWithRequest(_ request: String) {
        let recipeDetail = RecipeDetailViewController()
        let recipeDetailInteractor = RecipeDetailInteractor()
        let recipeDetailRouter = RecipeDetailRouter(navigationController: navigationController)
        let recipeDetailPresenter = RecipeDetailPresenter(interactor: recipeDetailInteractor,
                                                          router: recipeDetailRouter,
                                                          detailUrl: request)
        recipeDetail.presenter = recipeDetailPresenter
        navigationController?.present(recipeDetail, animated: true, completion: nil)
    }
}
