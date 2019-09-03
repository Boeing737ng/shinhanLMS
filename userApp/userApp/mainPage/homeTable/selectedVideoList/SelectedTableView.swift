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
    var dataSize:Int = 0;
    var currentVideoIdArray = Array<String>()
    var currentVideoTitleArray = Array<String>()
    var currentVideoAuthorArray = Array<String>()
    var currentVideoViewArray = Array<Int>()
    
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
            ref.child(userCompanyCode + "/videos").observeSingleEvent(of: .value, with: { (snapshot) in
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
                            recommendedVideoIdArray.append(videoId)
                            recommendedTitleArray.append(title)
                            recommendedAuthorArray.append(author)
                            
                            ref.child(userCompanyCode + "/videos/" + videoId).observeSingleEvent(of: .value, with: { (snapshot) in
                                let videoDict2 = snapshot.value as! Dictionary<String, Any>;()
                                let view = videoDict2["view"] as! Int
                                recommendedViewArray.append(view)
                                self.dataReceived = true
                                self.dataSize = recommendedVideoIdArray.count
                                self.currentVideoIdArray = recommendedVideoIdArray
                                self.currentVideoTitleArray = recommendedTitleArray
                                self.currentVideoAuthorArray = recommendedAuthorArray
                                self.currentVideoViewArray = recommendedViewArray
                                
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
        clearArray()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/201302493/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let status = videoDict["state"] as! String
                if status == "playing" {
                    let videoId = video.key as! String
                    let title = videoDict["title"] as! String
                    let author = videoDict["author"] as! String
                    let progress = (videoDict["progress"] as! NSNumber)
                    self.currentVideoIdArray.append(videoId)
                    self.currentVideoTitleArray.append(title)
                    self.currentVideoAuthorArray.append(author)
                    //playingProgressArray.append(progress.floatValue)
                    
                    ref.child(userCompanyCode + "/videos/" + videoId).observeSingleEvent(of: .value, with: { (snapshot) in
                        let videoDict2 = snapshot.value as! Dictionary<String, Any>;()
                        let view = videoDict2["view"] as! Int
                        self.currentVideoViewArray.append(view)
                        self.dataSize = self.currentVideoViewArray.count
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
        clearArray()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/").queryOrdered(byChild: "view").observeSingleEvent(of: .value, with: { (snapshot) in
            self.dataSize = Int(snapshot.childrenCount) - 1
            for video in snapshot.children.allObjects as! [DataSnapshot] {
                if let videoInfo = video.value as? [String : Any] {
                    totalPopularVideoIdArray.append(video.key)
                    totalPopularTitleArray.append(videoInfo["title"] as! String)
                    totalPopularAuthorArray.append(videoInfo["author"] as! String)
                    totalPopularViewArray.append(videoInfo["view"] as! Int)
                }
            }
            self.dataReceived = true
            self.currentVideoIdArray = totalPopularVideoIdArray
            self.currentVideoTitleArray = totalPopularTitleArray
            self.currentVideoAuthorArray = totalPopularAuthorArray
            self.currentVideoViewArray = totalPopularViewArray
            
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func clearArray() {
        totalPopularVideoIdArray.removeAll()
        totalPopularTitleArray.removeAll()
        totalPopularAuthorArray.removeAll()
        totalPopularViewArray.removeAll()
        
//        playingVideoIdArray.removeAll()
//        playingTitleArray.removeAll()
//        playingAuthorArray.removeAll()
//        playingViewArray.removeAll()
//        playingProgressArray.removeAll()
    }
    
    func updateCells() {
        self.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSize)
        return dataSize
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
                index = dataSize - indexPath.row
            } else {
                index = indexPath.row
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
            print("????????????????????????????????????????")
            self.reloadData()
        }
        
        return cell
    }
}
