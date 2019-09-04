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
        ref.child(userCompanyCode + "/lecture/").queryOrdered(byChild: "view").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Lecture list is empty!!!!")
                return
            }
            let dataSize = Int(snapshot.childrenCount)
            for lecutre in snapshot.children.allObjects as! [DataSnapshot] {
                if let lectureInfo = lecutre.value as? [String : Any] {
                    totalPopularVideoIdArray.append(lecutre.key)
                    totalPopularTitleArray.append(lectureInfo["title"] as! String)
                    totalPopularAuthorArray.append(lectureInfo["author"] as! String)
                    totalPopularViewArray.append(lectureInfo["view"] as! Int)
                }
            }
            for i in 0...2 {
                if dataSize == i {
                    break
                }
                self.popularLectureIdArray.append(totalPopularVideoIdArray[(dataSize - 1) - i])
                self.popularTitleArray.append(totalPopularTitleArray[(dataSize - 1) - i])
                self.popularAuthorArray.append(totalPopularAuthorArray[(dataSize - 1) - i])
                self.popularViewArray.append(totalPopularViewArray[(dataSize - 1) - i])
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
        return popularLectureIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = popularLectureIdArray[indexPath.row]
        selectedLectureId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell2") as! VideoCell2
        if dataReceived {
            cell.videoTitleLabel.text = popularTitleArray[indexPath.row]
            cell.videoAuthorLabel.text = popularAuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: popularLectureIdArray[indexPath.row])
            cell.videoViewLabel.text = String(popularViewArray[indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
            cell.videoViewLabel.text = viewArray[indexPath.row]
        }
        
        return cell
    }
}
