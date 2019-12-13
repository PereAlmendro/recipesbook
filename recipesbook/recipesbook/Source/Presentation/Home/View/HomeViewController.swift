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
        title = "Recipes Book"
        presenter.viewDidLoad()
        setupRxCollectionView()
    }
    
    private func setupRxCollectionView() {
        collectionView.register(UINib(nibName: HomeRecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: HomeRecipeCollectionViewCell.cellIdentifier)
        
        collectionView.isPrefetchingEnabled = true
        
        presenter.recipes
            .bind(to:
                collectionView.rx.items(cellIdentifier: HomeRecipeCollectionViewCell.cellIdentifier,
                                        cellType: HomeRecipeCollectionViewCell.self)) { [weak self] (_, element ,cell) in
                                            guard let strongSelf = self else { return }
                                            cell.setupCell(recipe: element, delegate: strongSelf)
        }.disposed(by: disposeBag)
        
        collectionView.rx.prefetchItems.subscribe( { event in
            guard let indexPaths = event.element else { return }
            
        }).disposed(by: disposeBag)
        
//        collectionView.rx.scrollViewDidScroll.subscribe({ [weak self] event in
            // TODO: remove this and implement prefetchItems to load more cells while user scrolls
//            guard let scrollView = event.element else { return }
//
//            let scrollViewHeight = scrollView.frame.size.height
//            let scrollViewContentSize = scrollView.contentSize.height
//            let scrollViewOffset = scrollView.contentOffset.y
//            let bottomOffsetLoadMore: CGFloat = 100.0
//
//            let isAtBottom = (scrollViewOffset + scrollViewHeight > scrollViewContentSize - bottomOffsetLoadMore)
//            if (isAtBottom) {
//                scrollView.stopScrolling()
//                self?.presenter.fetchMoreRecipes()
//            }
//        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({[weak self] event in
            guard let item = event.element else { return }
            self?.presenter.openDetail(recipe: item)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter.makeFavourite(recipe: recipe)
    }
    @IBAction func navigationBarRightButtonAction(_ sender: Any) {
        presenter.navigationBarRightButtonAction()
    }
}
