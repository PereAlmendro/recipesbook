//
//  HomeViewController.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController,
HomeRecipeCollectionViewCellDelegate,
UIScrollViewDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomePresenterProtocol? = nil
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes Book"
        presenter?.viewDidLoad()
        setupRxCollectionView()
    }
    
    private func setupRxCollectionView() {
        collectionView.register(UINib(nibName: HomeRecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: HomeRecipeCollectionViewCell.cellIdentifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 300)
        }
        
        presenter?.recipes.bind(to:
            collectionView.rx.items(cellIdentifier: HomeRecipeCollectionViewCell.cellIdentifier,
                                    cellType: HomeRecipeCollectionViewCell.self)) { [weak self] (_, element ,cell) in
                                        guard let strongSelf = self else { return }
                                        cell.setupCell(recipe: element, delegate: strongSelf)
        }.disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell.subscribe({ [presenter, collectionView] event in
            guard let (_, indexPath) = event.element,
                let itemsCount = collectionView?.numberOfItems(inSection: 0),
                let offset = collectionView?.contentOffset else { return }
            
            if itemsCount - 2 == indexPath.row &&  offset.y > 0 {
                presenter?.fetchMoreRecipes()
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({ [presenter] event in
            guard let recipe = event.element else { return }
            presenter?.openDetail(recipe: recipe)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter?.makeFavourite(recipe: recipe)
    }
    
    // MARK: - NavBar Action
    
    @IBAction func navigationBarRightButtonAction(_ sender: Any) {
        presenter?.navigationBarRightButtonAction()
    }
}
