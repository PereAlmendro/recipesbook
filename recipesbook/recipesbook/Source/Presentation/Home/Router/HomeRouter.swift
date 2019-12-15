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
    func showAlert(title: String?, message: String?,
                   action: String?, style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)?)
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
    
    func showAlert(title: String?, message: String?,
                   action: String?, style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: style, handler: handler))
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
