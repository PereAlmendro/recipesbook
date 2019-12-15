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
UICollectionViewDelegateFlowLayout,
HomeRecipeCollectionViewCellDelegate,
UIScrollViewDelegate {

    @IBOutlet weak var searchBarContentView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomePresenterProtocol? = nil
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipes Book"
        presenter?.viewDidLoad()
        setupRxCollectionView()
        setupSearchBar()
        enableLargeTitles()
    }
    
    private func setupRxCollectionView() {
        collectionView.register(UINib(nibName: HomeRecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: HomeRecipeCollectionViewCell.cellIdentifier)
        
        collectionView.delegate = self
        
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
                collectionView?.stopScrolling()
                presenter?.fetchMoreRecipes()
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({ [presenter] event in
            guard let recipe = event.element else { return }
            presenter?.openDetail(recipe: recipe)
        }).disposed(by: disposeBag)
        
        collectionView.rx.scrollViewDidScroll.subscribe( { [weak self] event in
            guard let scrollView = event.element else { return }
            let showShadow = scrollView.contentOffset.y > 0
            if  showShadow {
                self?.searchBarContentView.addBottomShadow()
            } else {
                self?.searchBarContentView.removeShadow()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search : onions, carrots ..."
        searchBar.rx.searchButtonClicked.subscribe({ [weak self] event in
            self?.presenter?.searchQuery(queryString: self?.searchBar.text)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter?.makeFavourite(recipe: recipe)
    }
    
    // MARK: - NavBar
    
    private func enableLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    @IBAction func navigationBarRightButtonAction(_ sender: Any) {
        presenter?.navigationBarRightButtonAction()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: screenWidth - 10, height: 350)
    }
}
