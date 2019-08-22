//
//  HomePageViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//Video Info upon Categories
//- thumbnail image
//- name
//- download Url

import UIKit
import Firebase

class HomePageViewController: UIViewController {
    
    var playingTitleArray = Array<String>()
    var playingAuthorArray = Array<String>()
    var playingThumbnailArray = Array<String>()
    
    var recommendedTitleArray = Array<String>()
    var recommendedAuthorArray = Array<String>()
    var recommendedThumbnailArray = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        getVideoInfoFromDB()
        // Do any additional setup after loading the view.
    }
    
    
    func getVideoInfoFromDB() {
        print("DB function called")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/201302493/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            for item in value! {
                let stringKey = (item.key as AnyObject).description
               
                if stringKey == "playing" {
                    let categoryDict = item.value as! Dictionary<String, Any>;()
                    for video in categoryDict {
                        let videoDict = video.value as! Dictionary<String, Any>;()
                        let title = (video.key as AnyObject).description
                        let author = videoDict["author"] as! String
                        let thumbnailUrl = videoDict["thumbnail"] as! String
                        
                        self.playingTitleArray.append(title!)
                        self.playingAuthorArray.append(author)
                        self.playingThumbnailArray.append(thumbnailUrl)
                        
                    }
                } else {
                    let categoryDict = item.value as! Dictionary<String, Any>;()
                    for video in categoryDict {
                        let videoDict = video.value as! Dictionary<String, Any>;()
                        let title = (video.key as AnyObject).description
                        let author = videoDict["author"] as! String
                        let thumbnailUrl = videoDict["thumbnail"] as! String
                        
                        self.recommendedTitleArray.append(title!)
                        self.recommendedAuthorArray.append(author)
                        self.recommendedThumbnailArray.append(thumbnailUrl)
                        
                    }
                }
//                var dict = item.value as! Dictionary<String, Any>;()
//                print(dict["author"]!)
//                print(dict["thumbnail"]!)
            }
            print(self.playingTitleArray)
            print(self.recommendedTitleArray)
            print("========================================================================")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
