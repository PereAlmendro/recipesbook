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
UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomePresenterProtocol? = nil
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupRxCollectionView()
    }
    
    func setupRxCollectionView() {
        collectionView.register(UINib(nibName: HomeRecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: HomeRecipeCollectionViewCell.cellIdentifier)
        
        presenter?.recipes.bind(to:
            collectionView.rx.items(cellIdentifier: HomeRecipeCollectionViewCell.cellIdentifier,
                                    cellType: HomeRecipeCollectionViewCell.self)) { (_, element ,cell) in
                                        cell.setupCell(recipe: element, delegate: self)
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({[weak self] event in
            guard let recipe = event.element else { return }
            self?.presenter?.openDetail(recipe: recipe)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter?.makeFavourite(recipe: recipe)
    }
    
}
