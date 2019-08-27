//
//  LoginViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 26/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var urlDict = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView().setLoadingStyle(self)
        getThumbnailURL()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getThumbnailURL() {
        LoadingView().startLoading(self)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("thumbnailUrl").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for video in value! {
                //let videoDict = video.value as! Dictionary<String, Any>;()
                let title = video.key as! String
                let url = video.value as! String
                self.urlDict[title] = url
            }
            self.setThumbnailCache(withCompletion: self.isCachingCompleted)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setThumbnailCache(withCompletion completion: () -> Void) {
        for (id, url) in urlDict {
            let imageURL = URL(string: url)
            URLSession.shared.dataTask(with: imageURL!) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)!
                CachedImageView().setImageCache(item: image, urlKey: id)
                }.resume()
            print(id + " ---> Cached!")
        }
        completion()
    }
    
    func isCachingCompleted() {
        LoadingView().stopLoading()
    }

}
