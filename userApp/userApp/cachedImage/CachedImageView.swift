//
//  CachedImageView.swift
//  userApp
//
//  Created by Kihyun Choi on 24/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

/**
 A convenient UIImageView to load and cache images.
 */
open class CachedImageView: UIImageView {
    
    public static let imageCache = NSCache<NSString, UIImage>()
    
    func setImageCache(item: UIImage, urlKey: String) {
        print(urlKey)
        CachedImageView.imageCache.setObject(item, forKey: urlKey as NSString)
    }
    
    func loadCacheImage(urlKey: String, completion: (() -> ())? = nil) -> UIImage {
        let cachedItem = CachedImageView.imageCache.object(forKey: urlKey as NSString)
        return cachedItem!
    }
}
