//
//  LoadingView.swift
//  userApp
//
//  Created by Kihyun Choi on 27/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
let container: UIView = UIView()
let loadingView: UIView = UIView()

class LoadingView: NSObject {
    
    func setLoadingStyle(_ sender: UIViewController) {
        // Apply loading screen style
        container.frame = sender.view.frame
        container.center = sender.view.center
        loadingView.frame = sender.view.frame
        loadingView.center = sender.view.center
        loadingView.backgroundColor = UIColor(white: 000, alpha: 0.4)
        loadingView.clipsToBounds = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    }
    
    func startLoading(_ sender: UIViewController) {
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        sender.view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        container.removeFromSuperview()
    }
}
