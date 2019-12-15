//
//  UIImageView+imageFromUrl.swift
//  recipesbook
//
//  Created by Pere Almendro on 15/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func setImageUrl(_ url: URL?) {
        
        self.image = UIImage(named: "imgPlaceholder")
        guard let url = url else { return }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data,
                    let image = UIImage(data: data) else {
                        return
                }
                imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
                self.image = image
            }
        }).resume()
    }
    
}
