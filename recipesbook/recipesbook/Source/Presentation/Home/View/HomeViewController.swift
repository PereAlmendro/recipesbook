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
    
    var presenter: HomePresenterProtocol = HomePresenter(interactor: HomeInteractor(), router: HomeRouter())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupRxCollectionView()
    }
    
    func setupRxCollectionView() {
        collectionView.register(UINib(nibName: HomeRecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: HomeRecipeCollectionViewCell.cellIdentifier)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        presenter.recipes.asObserver().bind(to: collectionView.rx.items(cellIdentifier: HomeRecipeCollectionViewCell.cellIdentifier,
                                    cellType: HomeRecipeCollectionViewCell.self)) { (_, element ,cell) in
                                        cell.setupCell(recipe: element, delegate: self)
        }.disposed(by: disposeBag)
        
        collectionView.rx.scrollViewDidScroll.subscribe({ [weak self] event in
            guard let scrollView = event.element else { return }
            
            let scrollViewHeight = scrollView.frame.size.height
            let scrollViewContentSize = scrollView.contentSize.height
            let scrollViewOffset = scrollView.contentOffset.y
            let bottomOffsetLoadMore: CGFloat = 100.0
            
            let isAtBottom = (scrollViewOffset + scrollViewHeight > scrollViewContentSize - bottomOffsetLoadMore)
            if (isAtBottom) {
                scrollView.stopScrolling()
                self?.presenter.fetchMoreRecipes()
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({[weak self] event in
            guard let item = event.element else { return }
            self?.presenter.openDetail(recipe: item)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter.makeFavourite(recipe: recipe)
    }
}
