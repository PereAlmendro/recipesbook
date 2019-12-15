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

    @IBOutlet private weak var informationView: InformationView!
    @IBOutlet private weak var searchBarContentView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: HomePresenterProtocol? = nil
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupRxCollectionView()
        setupSearchBar()
        setupTopShadow()
        setupInformationView()
        setupNavigationBar()
    }
    
    private func setupTopShadow() {
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
            
            if itemsCount - 2 == indexPath.row && offset.y > 0 {
                collectionView?.stopScrolling()
                presenter?.fetchMoreRecipes()
            }
        }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({ [presenter] event in
            guard let recipe = event.element else { return }
            presenter?.openDetail(recipe: recipe)
        }).disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search : onions, eggs ..."
        searchBar.rx.searchButtonClicked.subscribe({ [weak self] event in
            self?.presenter?.searchQuery(queryString: self?.searchBar.text)
            self?.searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    private func setupInformationView() {
        presenter?.information.subscribe({ [weak self] event in
            guard let information = event.element else { return }
            DispatchQueue.main.async {
                if let info = information {
                    self?.informationView.setInformation(info)
                    self?.collectionView.isHidden = true
                } else {
                    self?.collectionView.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - HomeRecipeCollectionViewCellDelegate
    
    func makeFavouriteAction(_ recipe: Result) {
        presenter?.makeFavourite(recipe: recipe)
    }
    
    // MARK: - NavBar
    
    private func setupNavigationBar() {
        title = "Recipes Book"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let favourites = UIBarButtonItem(title: "go", style: .plain, target: self, action: #selector(goToFavourites(_:)))
        favourites.image = UIImage(systemName: "heart.fill")
        favourites.tintColor = .systemRed

        navigationItem.rightBarButtonItems = [favourites]
    }
    
    @objc func goToFavourites(_ sender: Any) {
        presenter?.goToFavourites()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: screenWidth - 10, height: 350)
    }
}
