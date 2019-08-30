//
//  VideoAddTableView.swift
//  userApp
//
//  Created by user on 30/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

// var selectedCategoryIndex:Int = 0

class VideoAddTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var textArray = ["","",""]
    var authorArray = ["","",""]
    var dataReceived:Bool = false
    
    var videoIdArray = Array<String>()
    var databaseTitleArray = Array<String>()
    var databaseAuthorArray = Array<String>()
    
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
        
        print(dataURL)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.videoIdArray.append(videoId)
                self.databaseTitleArray.append(title)
                self.databaseAuthorArray.append(author)
            }
            print(self.databaseTitleArray)
            self.dataReceived = true
            DispatchQueue.main.async {
                self.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func clearArrays() {
        videoIdArray.removeAll()
        databaseTitleArray.removeAll()
        databaseAuthorArray.removeAll()
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
        print("ROW NUMBER ", videoIdArray.count)
        return videoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CELL")
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! VideoAddCell
        
        if dataReceived {
            cell.videoTitleLabel.text = databaseTitleArray[indexPath.row]
            cell.videoAuthorLabel.text = databaseAuthorArray[indexPath.row]
            cell.videoThumbnail.image = CachedImageView().loadCacheImage(urlKey: videoIdArray[indexPath.row])
        } else {
            cell.videoTitleLabel.text = textArray[indexPath.row]
            cell.videoAuthorLabel.text = authorArray[indexPath.row]
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
        }
        
        return cell
}
}
