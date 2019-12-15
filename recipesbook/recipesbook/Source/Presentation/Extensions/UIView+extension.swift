//
//  UIView+shadow.swift
//  recipesbook
//
//  Created by Pere Almendro on 15/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func removeShadow() {
        layer.masksToBounds = true
        layer.shadowColor = nil
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
    }
    
    func loadNib(nibName: String?) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let name = nibName == nil ? type(of: self).description().components(separatedBy: ".").last! : nibName
        let nib = UINib(nibName: name!, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func addSubviewFillingConstraints(with subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
