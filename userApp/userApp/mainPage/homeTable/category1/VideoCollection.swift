//
//  VideoCollection.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

var userSelectedTagArray = Array<String>()

var recommendedVideoIdArray = Array<String>()
var recommendedTitleArray = Array<String>()
var recommendedAuthorArray = Array<String>()
var recommendedViewArray = Array<Int>()

class VideoCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var textArray = ["","","","",""]
    var authorArray = ["","","","",""]
    var dataReceived:Bool = false
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromDB), name: NSNotification.Name(rawValue: "userTagUpdated"), object: nil)
        getDataFromDB()
    }
    
    @objc func getDataFromDB() {
        clearArrays()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/selectedTags").observeSingleEvent(of: .value, with: { (snapshot) in
            let tagList = snapshot.value as! String
            userSelectedTagArray = tagList.components(separatedBy: " ")
            var index = 0
            ref.child(userCompanyCode + "/lecture").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? Dictionary<String,Any>;()
                for video in value! {
                    let videoDict = video.value as! Dictionary<String, Any>;()
                    let videoTagList = (videoDict["tags"] as! String).components(separatedBy: " ")
                    for userTag in userSelectedTagArray {
                        for videoTag in videoTagList {
                            if userTag == videoTag {
                                if index == 5 {
                                    self.dataReceived = true
                                    self.reloadData()
                                    return
                                }
                                let videoId = video.key
                                if recommendedVideoIdArray.contains(videoId) {
                                    continue
                                }
                                let title = videoDict["title"] as! String
                                let author = videoDict["author"] as! String
                                recommendedVideoIdArray.append(videoId)
                                recommendedTitleArray.append(title)
                                recommendedAuthorArray.append(author)
                                index += 1
                            }
                        }
                    }
                }
                self.dataReceived = true
                self.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func clearArrays() {
        recommendedVideoIdArray.removeAll()
        recommendedTitleArray.removeAll()
        recommendedAuthorArray.removeAll()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedVideoIdArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoId = recommendedVideoIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        if dataReceived {
            cell.textLabel.text = recommendedTitleArray[indexPath.row]
            cell.authorLabel.text = recommendedAuthorArray[indexPath.row]
            cell.thumbnail.image = CachedImageView().loadCacheImage(urlKey: recommendedVideoIdArray[indexPath.row])
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
