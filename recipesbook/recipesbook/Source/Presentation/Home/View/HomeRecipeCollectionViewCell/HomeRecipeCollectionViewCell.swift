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
        return String(describing: self)
    }()
    
    private weak var delegate: HomeRecipeCollectionViewCellDelegate?

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var makeFavouriteButton: UIButton!
    private var recipe: Result? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeFavouriteButton.setTitle("Make favourite", for: .normal)
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

    @IBAction func makeFavouriteAction(_ sender: Any) {
        guard let recipe = recipe else { return }
        delegate?.makeFavouriteAction(recipe)
    }
}
