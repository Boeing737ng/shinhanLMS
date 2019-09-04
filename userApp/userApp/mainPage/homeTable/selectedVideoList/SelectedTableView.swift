//
//  SelectedTableView.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class SelectedTableView: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
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
        getDataUponRequest()
    }
    
    private func getDataUponRequest() {
        if segueId == "recommendListSegue" {
            getRecommendedVideoList()
        } else if segueId == "playingListSegue" {
            getPlayingVideoList()
        } else {
            getPopularVideoList()
        }
    }
    
    func getRecommendedVideoList() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/selectedTags").observeSingleEvent(of: .value, with: { (snapshot) in
            let tagList = snapshot.value as! String
            userSelectedTagArray = tagList.components(separatedBy: " ")
            ref.child(userCompanyCode + "/lecture").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? Dictionary<String,Any>;()
                for video in value! {
                    let videoDict = video.value as! Dictionary<String, Any>;()
                    let videoTagList = (videoDict["tags"] as! String).components(separatedBy: " ")
                    for userTag in userSelectedTagArray {
                        if videoTagList.contains(userTag) {
                            let videoId = video.key
                            let title = videoDict["title"] as! String
                            let author = videoDict["author"] as! String
                            self.currentVideoIdArray.append(videoId)
                            self.currentVideoTitleArray.append(title)
                            self.currentVideoAuthorArray.append(author)
                            
                            ref.child(userCompanyCode + "/lecture/" + videoId).observeSingleEvent(of: .value, with: { (snapshot) in
                                let videoDict2 = snapshot.value as! Dictionary<String, Any>;()
                                let view = videoDict2["view"] as! Int
                                self.currentVideoViewArray.append(view)
                                self.dataReceived = true
                                self.reloadData()
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            break
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func getPlayingVideoList() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/201302493/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for lecture in value! {
                let lectureDict = lecture.value as! Dictionary<String, Any>;()
                let status = lectureDict["state"] as! String
                if status == "playing" {
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
    
    func getPopularVideoList() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture").queryOrdered(byChild: "view").observeSingleEvent(of: .value, with: { (snapshot) in
            for video in snapshot.children.allObjects as! [DataSnapshot] {
                if let videoInfo = video.value as? [String : Any] {
                    self.currentVideoIdArray.append(video.key)
                    self.currentVideoTitleArray.append(videoInfo["title"] as! String)
                    self.currentVideoAuthorArray.append(videoInfo["author"] as! String)
                    self.currentVideoViewArray.append(videoInfo["view"] as! Int)
                }
            }
            self.dataReceived = true
            self.reloadData()
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
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedVideoCell") as! SelectedVideoCell
        var index:Int = 0;
        if currentVideoViewArray.count == currentVideoIdArray.count {
            if segueId == "popularListSegue" {
                index = (currentVideoIdArray.count - 1) - indexPath.row
            } else {
                index = indexPath.row
            }
            
            if segueId == "playingListSegue" {
                cell.videoProgressView.isHidden = false
                cell.videoProgressView.progress = currentVideoProgressArray[index]
            } else {
                cell.videoProgressView.isHidden = true
            }
            
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
