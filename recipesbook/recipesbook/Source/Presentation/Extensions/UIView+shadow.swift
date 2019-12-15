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
}
