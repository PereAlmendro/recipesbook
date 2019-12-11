//
//  HomeRecipeCollectionViewCell.swift
//  recipesbook
//
//  Created by Pere Almendro on 09/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

protocol HomeRecipeCollectionViewCellDelegate: AnyObject {
    func makeFavouriteAction(_ recipe: Result)
}

struct HomeRecipeCollectionViewCellModel {
    let thumbnail: URL
    let name: String
    let ingredients: String
}

class HomeRecipeCollectionViewCell: UICollectionViewCell {
    
    static var cellIdentifier: String = {
        return String(describing: HomeRecipeCollectionViewCell.self)
    }()
    
    private weak var delegate: HomeRecipeCollectionViewCellDelegate?

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var makeFavouriteButton: UIButton!
    private var isHeightCalculated: Bool = false
    private var recipe: Result? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelsUI()
        setupMakeFavouritesButton()
    }
    
    func setupCell(recipe: Result, delegate: HomeRecipeCollectionViewCellDelegate) {
        self.delegate = delegate
        self.recipe = recipe
        
        recipeNameLabel.text = recipe.title
        recipeIngredientsLabel.text = recipe.ingredients
        
        guard let url = URL(string: recipe.thumbnail),
            let data = try? Data(contentsOf: url) else { return }
        recipeImageView.image = UIImage(data: data)
    }
    
    // MARK - User Actions

    @IBAction func makeFavouriteAction(_ sender: Any) {
        guard let recipe = recipe else { return }
        delegate?.makeFavouriteAction(recipe)
    }
    
    // MARK - Overrides
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // this code calculates UICollectionViewCells height,
        // keeping the screen width as width
        if !isHeightCalculated {
            layoutIfNeeded()
            var newFrame = layoutAttributes.frame
            let measuredHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let screenWidth = UIScreen.main.bounds.size.width
            newFrame.size = CGSize(width: screenWidth, height: measuredHeight)
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
    
    // MARK: - Private methods
    
    private func setupMakeFavouritesButton() {
        makeFavouriteButton.setTitle("Make\nfavourite", for: .normal)
        makeFavouriteButton.titleLabel?.numberOfLines = 2
        makeFavouriteButton.titleLabel?.textAlignment = .center
        makeFavouriteButton.layer.borderWidth = 1
        makeFavouriteButton.layer.borderColor = UIColor.defaultBlue.cgColor
        makeFavouriteButton.layer.cornerRadius = 5
    }
    
    private func setupLabelsUI() {
        recipeNameLabel.font = UIFont.helveticaNeueBoldWith(size: 18)
        recipeIngredientsLabel.font = UIFont.helveticaNeueRegularWith(size: 17)
    }
}
