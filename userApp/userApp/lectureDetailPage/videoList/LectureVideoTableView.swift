//
//  LectureVideoTableView.swift
//  userApp
//
//  Created by Kihyun Choi on 03/09/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class LectureVideoTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    
    var databaseVideoIdArray = Array<String>()
    var databaseTitleArray = Array<String>()
    var databaseAuthorArray = Array<String>()
    var dataReceived:Bool = false
    
    override func awakeFromNib() {
        self.dataSource = self
        self.delegate = self
        getDataFromDB()
    }
    
    func getDataFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print(selectedLectureId)
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId + "/videos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.childrenCount == 0 {
                return
            }
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.databaseVideoIdArray.append(videoId)
                self.databaseTitleArray.append(title)
                self.databaseAuthorArray.append(author)
                
                self.dataReceived = true
                self.reloadData()
            }
            print(self.databaseVideoIdArray)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("SECTION:", databaseVideoIdArray)
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ROWS:", databaseVideoIdArray)
        return databaseVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = databaseVideoIdArray[indexPath.row]
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId + "/videos/" + videoId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>;()
            videoURL = value!["downloadURL"] as! String
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "videoSelected"), object: nil)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LectureVideoListTableViewCell") as! LectureVideoListTableViewCell
        if dataReceived{
            cell.videoTitleLabel.text = databaseTitleArray[indexPath.row]
            cell.videoAuthorLabel.text = databaseAuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: databaseVideoIdArray[indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
        }
        
        return cell
    }
}
