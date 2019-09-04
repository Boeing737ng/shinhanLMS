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
    var viewArray = ["","",""]
    var defaultProgress:Float = 0.0
    var dataReceived:Bool = false
    
    var playingLectureIdArray = Array<String>()
    var playingTitleArray = Array<String>()
    var playingAuthorArray = Array<String>()
    var playingProgressArray = Array<Float>()
    var playingViewArray = Array<Int>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "refreshMainTable"), object: nil)
        setUserLectureProgress()
    }
    @objc func reloadTable() {
        setUserLectureProgress()
    }
    
    func clearArrays() {
        playingLectureIdArray.removeAll()
        playingTitleArray.removeAll()
        playingAuthorArray.removeAll()
        playingProgressArray.removeAll()
        playingViewArray.removeAll()
    }
    
    func setUserLectureProgress() {
        var watchedVideoCount:Int = 0
        var totalVideoCount:Int = 0
        var compledtedRatio:Float = 0.0
        var currentState:String = ""
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList/" + selectedLectureId + "/videos").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Playlist is empty!!!!")
                self.gerUserPlayingLectureInfoFromDB()
                return
            }
            let videos = snapshot.children.allObjects as! [DataSnapshot]
            totalVideoCount = Int(snapshot.childrenCount)
            for video in videos {
                let videoInfo = video.value as! Dictionary<String, Any>;()
                let videoState = videoInfo["state"] as! String
                if videoState == "completed" {
                    watchedVideoCount += 1
                }
            }
            compledtedRatio = Float(Double(watchedVideoCount) / Double(totalVideoCount))
            print(totalVideoCount)
            print(watchedVideoCount)
            print(compledtedRatio)
            if compledtedRatio == 1.0 {
                currentState = "completed"
            } else {
                currentState = "playing"
            }
            ref.child("user/" + userNo + "/playList/" + selectedLectureId).updateChildValues([
                "progress": compledtedRatio,
                "state": currentState
                ]
            )
            self.gerUserPlayingLectureInfoFromDB()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func gerUserPlayingLectureInfoFromDB() {
        clearArrays()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Playlist is empty!!!!")
                return
            }
            let value = snapshot.value as? NSDictionary
            for video in value! {
                if self.playingLectureIdArray.count == 3 {
                    break
                }
                let videoDict = video.value as! Dictionary<String, Any>;()
                let status = videoDict["state"] as! String
                if status == "playing" {
                    let lectureId = video.key as! String
                    let title = videoDict["title"] as! String
                    let author = videoDict["author"] as! String
                    let progress = (videoDict["progress"] as! NSNumber)
                    self.playingLectureIdArray.append(lectureId)
                    self.playingTitleArray.append(title)
                    self.playingAuthorArray.append(author)
                    self.playingProgressArray.append(progress.floatValue)
                    
                    ref.child(userCompanyCode + "/lecture/" + lectureId).observeSingleEvent(of: .value, with: { (snapshot) in
                        let lecture = snapshot.value as! Dictionary<String, Any>;()
                        let view = lecture["view"] as! Int
                        self.playingViewArray.append(view)
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
    
    func updateCells() {
        self.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playingLectureIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(playingLectureIdArray)
        let videoId = playingLectureIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell1") as! VideoCell1
        
        cell.videoProgressBar.progress = 0.8
        if playingViewArray.count == playingLectureIdArray.count {
            if dataReceived {
                cell.videoTitleLabel.text = self.self.playingTitleArray[indexPath.row]
                cell.videoAuthorLabel.text = playingAuthorArray[indexPath.row]
                cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: self.playingLectureIdArray[indexPath.row])
                cell.videoProgressBar.progress = self.playingProgressArray[indexPath.row]
                cell.videoViewLabel.text = String(self.playingViewArray[indexPath.row])
            } else {
                cell.videoTitleLabel.text = textArray[indexPath.row]
                cell.videoAuthorLabel.text = authorArray[indexPath.row]
                cell.videoThumbnail.image = UIImage(named: "white.jpg")
                cell.videoProgressBar.progress = defaultProgress
                cell.videoViewLabel.text = viewArray[indexPath.row]
            }
        } else {
            self.reloadData()
        }
        
        return cell
    }
}
