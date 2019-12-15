//
//  InformationView.swift
//  recipesbook
//
//  Created by Pere Almendro on 15/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

struct InformationModel {
    var image: UIImage?
    var title: String?
    var description: String?
}

class InformationView: UIView {
    
    @IBOutlet private weak var infoImageView: UIImageView!
    @IBOutlet private weak var infoTitleLabel: UILabel!
    @IBOutlet private weak var infoMessageLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = loadNib(nibName: String(describing: InformationView.self))
        addSubviewFillingConstraints(with: view)
        
        infoTitleLabel.font = UIFont.helveticaNeueBoldWith(size: 20)
        infoMessageLabel.font = UIFont.helveticaNeueRegularWith(size: 16)
    }
    
    func setInformation(_ model: InformationModel) {
        infoImageView.image = model.image
        infoTitleLabel.text = model.title
        infoMessageLabel.text = model.description
    }
}
