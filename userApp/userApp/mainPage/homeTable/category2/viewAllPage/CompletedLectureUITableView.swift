//
//  PlayingLectureTableView.swift
//  userApp
//
//  Created by user on 04/09/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class CompletedLectureUITableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var viewArray = ["","",""]
    var dataReceived:Bool = false
    var currentVideoIdArray = Array<String>()
    var currentVideoTitleArray = Array<String>()
    var currentVideoAuthorArray = Array<String>()
    var currentVideoViewArray = Array<Int>()
    var currentVideoProgressArray = Array<Float>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        getPlayingVideoList()
    }
    
    func clearArrays() {
        currentVideoIdArray.removeAll()
        currentVideoTitleArray.removeAll()
        currentVideoAuthorArray.removeAll()
        currentVideoProgressArray.removeAll()
        currentVideoViewArray.removeAll()
    }
    
    func getPlayingVideoList() {
        clearArrays()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let value = snapshot.value as? NSDictionary
            for lecture in value! {
                let lectureDict = lecture.value as! Dictionary<String, Any>;()
                let status = lectureDict["state"] as! String
                if status == "completed" {
                    let lectureId = lecture.key as! String
                    let title = lectureDict["title"] as! String
                    let author = lectureDict["author"] as! String
                    let progress = (lectureDict["progress"] as! NSNumber)
                    self.currentVideoIdArray.append(lectureId)
                    self.currentVideoTitleArray.append(title)
                    self.currentVideoAuthorArray.append(author)
                    self.currentVideoProgressArray.append(progress.floatValue)
                    
                    ref.child(userCompanyCode + "/lecture/" + lectureId).observeSingleEvent(of: .value, with: { (snapshot) in
                        let videoDict2 = snapshot.value as! Dictionary<String, Any>;()
                        let view = videoDict2["view"] as! Int
                        self.currentVideoViewArray.append(view)
                        self.dataReceived = true
                        self.reloadData()
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                } else {
                    continue
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = currentVideoIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedLectureCell") as! SelectedVideoCell
        var index:Int = 0;
        
        if currentVideoViewArray.count == currentVideoIdArray.count {
            index = indexPath.row
            cell.videoProgressView.isHidden = false
            cell.videoProgressView.progress = currentVideoProgressArray[index]
            
            if dataReceived {
                cell.videoTitleLabel.text = currentVideoTitleArray[index]
                cell.videoAuthorLabel.text = currentVideoAuthorArray[index]
                cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: currentVideoIdArray[index])
                cell.videoViewLabel.text = String(currentVideoViewArray[index])
            } else {
                cell.videoTitleLabel.text = textArray[indexPath.row]
                cell.videoAuthorLabel.text = authorArray[indexPath.row]
                cell.videoThumbnail.image = UIImage(named: "white.jpg")
                cell.videoViewLabel.text = viewArray[indexPath.row]
            }
        } else {
            self.reloadData()
        }
        
        return cell
    }
}

