//
//  VideoTableViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 28/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

var selectedCategoryIndex:Int = 0

class VideoTableView: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var dataReceived:Bool = false
    
    var databaseVideoIdArray = Array<String>()
    var databaseTitleArray = Array<String>()
    var databaseAuthorArray = Array<String>()
    var databaseViewArray = Array<Int>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        getDataFromDB()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getDataFromDB() {
        clearArrays()
        var dataURL:String = ""
        if selectedCategoryIndex == 0 {
            dataURL = userCompanyCode + "/videos"
        } else {
            dataURL = userCompanyCode + "/categories/" + categoryDict[selectedCategoryIndex]! + "/videos/"
        }
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
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
                
                ref.child(userCompanyCode + "/videos/" + videoId).observeSingleEvent(of: .value, with: { (viewCount) in
                    let videoDict2 = viewCount.value as! Dictionary<String, Any>;()
                    let view = videoDict2["view"] as! Int
                    self.databaseViewArray.append(view)
                    self.dataReceived = true
                    self.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func clearArrays() {
        databaseVideoIdArray.removeAll()
        databaseTitleArray.removeAll()
        databaseAuthorArray.removeAll()
        databaseViewArray.removeAll()
    }
    
    @objc func reloadTable() {
        getDataFromDB()
        self.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return databaseVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = databaseVideoIdArray[indexPath.row]
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as! VideoListCell
        if (databaseViewArray.count == databaseVideoIdArray.count) {
            if dataReceived{
                cell.videoTitleLabel.text = databaseTitleArray[indexPath.row]
                cell.videoAuthorLabel.text = databaseAuthorArray[indexPath.row]
                cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: databaseVideoIdArray[indexPath.row])
                cell.videoViewLabel.text = String(databaseViewArray[indexPath.row])
            } else {
                cell.videoTitleLabel.text = textArray[indexPath.row]
                cell.videoAuthorLabel.text = authorArray[indexPath.row]
                cell.videoThumbnail.image = UIImage(named: "white.jpg")
                cell.videoViewLabel.text = "0"
            }
        } else {
            self.reloadData()
        }
        
        return cell
    }
}
