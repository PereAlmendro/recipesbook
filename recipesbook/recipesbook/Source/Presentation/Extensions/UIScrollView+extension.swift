//
//  UIScrollView+killScroll.swift
//  recipesbook
//
//  Created by Pere Almendro on 12/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

extension UIScrollView {
    func stopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}
