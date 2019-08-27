//
//  VideoCollection.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class VideoCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var textArray = ["","","","",""]
    var authorArray = ["","","","",""]
    var dataReceived:Bool = false
    
    var recentVideoIdArray = Array<String>()
    var recentTitleArray = Array<String>()
    var recentAuthorArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        var index = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("videos").queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                if index == 5 {
                    break
                }
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.recentVideoIdArray.append(videoId)
                self.recentTitleArray.append(title)
                self.recentAuthorArray.append(author)
                index += 1
            }
            self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let videoId = playingVideoIdArray[indexPath.row]
//        selectedVideoId = videoId
//        TabViewController().goToDetailPage()
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        cell.textLabel.text = textArray[indexPath.row]
        cell.authorLabel.text = authorArray[indexPath.row]
        
        if dataReceived {
            cell.textLabel.text = recentTitleArray[indexPath.row]
            cell.authorLabel.text = recentAuthorArray[indexPath.row]
            cell.thumbnail.image = CachedImageView().loadCacheImage(urlKey: recentVideoIdArray[indexPath.row])
        } else {
            cell.textLabel.text = textArray[indexPath.row]
            cell.authorLabel.text = authorArray[indexPath.row]
            cell.thumbnail.image = UIImage(named: "white.jpg")
        }
        
        
        return cell
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
