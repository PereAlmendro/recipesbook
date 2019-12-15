//
//  UIImageView+imageFromUrl.swift
//  recipesbook
//
//  Created by Pere Almendro on 15/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageUrl(_ url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data,
                    let image = UIImage(data: data) else {
                        self.image = UIImage(named: "placeholderImage")
                        return
                }
                self.image = image
            }
        }).resume()
    }
    
}
