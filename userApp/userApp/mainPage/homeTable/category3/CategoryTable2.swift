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
    
    var top3IdArray = Array<String>()
    var top3ViewArray = Array<Int>()
    var top3TitleArray = Array<String>()
    var top3AuthorArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        getDataFromDB()
    }
    
    func getDataFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId).queryOrdered(byChild: "view").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Lecture list is empty!!!!")
                return
            }
            self.dataSize = Int(snapshot.childrenCount)
            let lectures = snapshot.children.allObjects as! [DataSnapshot]
            for lecture in lectures {
                let lectureDict = lecture.value as! Dictionary<String, Any>;()
                totalPopularVideoIdArray.append(lecture.key)
                totalPopularViewArray.append(lectureDict["view"] as! Int)
                totalPopularTitleArray.append(lectureDict["title"] as! String)
                totalPopularAuthorArray.append(lectureDict["author"] as! String)
                self.dataReceived = true
                self.reloadData()
            }
            totalPopularVideoIdArray.reverse()
            totalPopularViewArray.reverse()
            totalPopularTitleArray.reverse()
            totalPopularAuthorArray.reverse()
            
            self.top3IdArray = Array(totalPopularVideoIdArray[0...3])
            self.top3ViewArray = Array(totalPopularViewArray[0...3])
            self.top3TitleArray = Array(totalPopularTitleArray[0...3])
            self.top3AuthorArray = Array(totalPopularAuthorArray[0...3])
            
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = totalPopularVideoIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell2") as! VideoCell2
        if dataReceived {
            cell.videoTitleLabel.text = top3TitleArray[indexPath.row]
            cell.videoAuthorLabel.text = top3AuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: top3IdArray[indexPath.row])
            cell.videoViewLabel.text = String(top3ViewArray[indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
            cell.videoViewLabel.text = viewArray[indexPath.row]
        }
        return cell
    }
}
