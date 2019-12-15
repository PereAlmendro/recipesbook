//
//  RecipeDetailViewController.swift
//  recipesbook
//
//  Created by Pere Almendro on 14/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit
import WebKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    var presenter: RecipeDetailPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let request = presenter?.detailUrl else { return }
        webView.load(URLRequest(url: request))
    }
}
