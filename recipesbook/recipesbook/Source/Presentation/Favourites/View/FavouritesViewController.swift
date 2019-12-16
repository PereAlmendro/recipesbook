//
//  FavouritesViewController.swift
//  recipesbook
//
//  Created by Pere Almendro on 16/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritesViewController: UIViewController,
UICollectionViewDelegateFlowLayout,
RecipeCollectionViewCellDelegate,
UICollectionViewDelegate {

    @IBOutlet private weak var informationView: InformationView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var presenter: FavouritesPresenterProtocol?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        presenter?.viewDidLoad()
        setupRxCollectionView()
        setupInformationView()
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
    
    private func setupRxCollectionView() {
        collectionView.register(UINib(nibName: RecipeCollectionViewCell.cellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: RecipeCollectionViewCell.cellIdentifier)
        
        collectionView.delegate = self
        
        presenter?.recipes.bind(to:
            collectionView.rx.items(cellIdentifier: RecipeCollectionViewCell.cellIdentifier,
                                    cellType: RecipeCollectionViewCell.self)) { [weak self] (_, element ,cell) in
                                        guard let strongSelf = self else { return }
                                        cell.setupCell(recipe: element, delegate: strongSelf, buttonTitle: "Delete\nfavourite")
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Result.self).subscribe({ [presenter] event in
            guard let recipe = event.element else { return }
            presenter?.openDetail(recipe: recipe)
        }).disposed(by: disposeBag)
    }
    
    func buttonAction(_ recipe: Result) {
        presenter?.deleteFavourite(recipe: recipe)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: screenWidth - 10, height: 350)
    }
}
