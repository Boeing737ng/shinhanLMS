//
//  CategoryTable1.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

var totalPopularVideoIdArray = Array<String>()
var totalPopularTitleArray = Array<String>()
var totalPopularAuthorArray = Array<String>()
var totalPopularViewArray = Array<Int>()

class CategoryTable2: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var viewArray = ["","",""]
    var dataReceived:Bool = false
    var dataSize:Int = 0
    
    var popularLectureIdArray = Array<String>()
    var popularTitleArray = Array<String>()
    var popularAuthorArray = Array<String>()
    var popularViewArray = Array<Int>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        getDataFromDB()
    }
    
    func getDataFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/views/").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Lecture list is empty!!!!")
                return
            }
            self.dataSize = Int(snapshot.childrenCount)
            let lectures = snapshot.children.allObjects as! [DataSnapshot]
            for lecture in lectures {
                let lectureId = lecture.key
                totalPopularViewArray.append(lecture.value as! Int)
                ref.child(userCompanyCode + "/lecture/" + lectureId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let lectureDict = snapshot.value as! Dictionary<String, Any>;()
                    totalPopularVideoIdArray.append(lectureId)
                    totalPopularTitleArray.append(lectureDict["title"] as! String)
                    totalPopularAuthorArray.append(lectureDict["author"] as! String)
                    self.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
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
        return totalPopularVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = totalPopularVideoIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell2") as! VideoCell2
        print(totalPopularTitleArray)
        if dataReceived {
            cell.videoTitleLabel.text = totalPopularTitleArray[(dataSize - 1) - indexPath.row]
            cell.videoAuthorLabel.text = totalPopularAuthorArray[(dataSize - 1) - indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: totalPopularVideoIdArray[(dataSize - 1) - indexPath.row])
            cell.videoViewLabel.text = String(totalPopularViewArray[(dataSize - 1) - indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
            cell.videoViewLabel.text = viewArray[indexPath.row]
        }
        return cell
    }
}
