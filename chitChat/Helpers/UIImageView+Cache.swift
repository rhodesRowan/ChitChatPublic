//
//  Helper.swift
//  chitChat
//
//  Created by Rowan Rhodes on 05/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import Alamofire


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    // MARK:- Public
    public func loadImageUsingCacheWithURLString(urlString: String) {
        self.image = UIImage()
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        // new download required
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        AF.request(request).response { [weak self] (response) in
            if let imgData = response.data {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: imgData) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                        self?.image = downloadedImage
                    }
                }
            }
        }
    }
    
}


