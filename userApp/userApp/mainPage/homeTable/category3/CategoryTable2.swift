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
    var dataReceived:Bool = false
    
    var popularVideoIdArray = Array<String>()
    var popularTitleArray = Array<String>()
    var popularAuthorArray = Array<String>()
    var popularViewArray = Array<Int>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/").queryOrdered(byChild: "view").observeSingleEvent(of: .value, with: { (snapshot) in
            let dataSize = Int(snapshot.childrenCount) - 1
            for video in snapshot.children.allObjects as! [DataSnapshot] {
                if let videoInfo = video.value as? [String : Any] {
                    totalPopularVideoIdArray.append(video.key)
                    totalPopularTitleArray.append(videoInfo["title"] as! String)
                    totalPopularAuthorArray.append(videoInfo["author"] as! String)
                    totalPopularViewArray.append(videoInfo["view"] as! Int)
                }
            }
            for i in 0...2 {
                self.popularVideoIdArray.append(totalPopularVideoIdArray[dataSize - i])
                self.popularTitleArray.append(totalPopularTitleArray[dataSize - i])
                self.popularAuthorArray.append(totalPopularAuthorArray[dataSize - i])
                self.popularViewArray.append(totalPopularViewArray[dataSize - i])
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
        return popularVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = popularVideoIdArray[indexPath.row]
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell2") as! VideoCell2
        
        if dataReceived {
            cell.videoTitleLabel.text = popularTitleArray[indexPath.row]
            cell.videoAuthorLabel.text = popularAuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: popularVideoIdArray[indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
        }
        
        return cell
    }
}
