//
//  RecipeDetailRouter.swift
//  recipesbook
//
//  Created by Pere Almendro on 14/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeDetailRouterProtocol {

}

class RecipeDetailRouter: RecipeDetailRouterProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

