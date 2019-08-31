//
//  CategoryTable1.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class CategoryTable1: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var defaultProgress:Float = 0.0
    var dataReceived:Bool = false
    
    var playingVideoIdArray = Array<String>()
    var playingTitleArray = Array<String>()
    var playingAuthorArray = Array<String>()
    var playingProgressArray = Array<Float>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/201302493/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for video in value! {
                if self.playingVideoIdArray.count == 3 {
                    print("-------ARRAY SIZE IS FULL------")
                    break
                }
                let videoDict = video.value as! Dictionary<String, Any>;()
                print(videoDict)
                let status = videoDict["state"] as! String
                if status == "playing" {
                    let videoId = video.key as! String
                    let title = videoDict["title"] as! String
                    let author = videoDict["author"] as! String
                    let progress = (videoDict["progress"] as! NSNumber)
                    self.playingVideoIdArray.append(videoId)
                    self.playingTitleArray.append(title)
                    self.playingAuthorArray.append(author)
                    self.playingProgressArray.append(progress.floatValue)
                } else {
                    continue
                }
            }
            self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateCells() {
        self.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playingVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = playingVideoIdArray[indexPath.row]
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell1") as! VideoCell1
        
        cell.videoProgressBar.progress = 0.8
        if dataReceived {
            cell.videoTitleLabel.text = playingTitleArray[indexPath.row]
            cell.videoAuthorLabel.text = playingAuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: playingVideoIdArray[indexPath.row])
            cell.videoProgressBar.progress = playingProgressArray[indexPath.row]
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
            cell.videoProgressBar.progress = defaultProgress
        }
        
        return cell
    }
}
