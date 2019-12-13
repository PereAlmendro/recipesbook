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
    
    func openRecipeDetailWithRequest(_ request: String) {
        // TODO : Open detail web VIew
    }
}
