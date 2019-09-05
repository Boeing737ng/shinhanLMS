//
//  VideoAddTableView.swift
//  userApp
//
//  Created by user on 30/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase
var addArray = Array<String>()

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID SELECTED ROW AT")
        let videoId = videoIdArray[indexPath.row]
        addArray.append(videoId)
        //selectedVideoId = videoId
    }
    
    func getDataFromDB() {
        clearArrays()
        var dataURL:String = ""
        if selectedCategoryIndex == 0 {
            dataURL = userCompanyCode + "/lecture"
        } else {
            dataURL = userCompanyCode + "/categories/" + categoryDict1[selectedCategoryIndex]! + "/lecture/"
        }
        
        print(dataURL)
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
    func onGoBack() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.window!.layer.add(transition, forKey: nil)
        //self.dismiss(animated: false, completion: nil)
    }
    @IBAction func Addcurriculum(_ sender: Any) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        for i in addArray
        {
            ref.child("58/lecture/" + i).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? Dictionary<String,Any>;()
                let videoDict = value as! Dictionary<String, Any>;()
                let author=videoDict["author"] as! String
                let title=videoDict["title"] as! String
                ///////////////////
                print(curri_send)
                print(i)
                ref.child("58/study/"+curri_send+"/curriculum/"+i).setValue([
                    "author": author,
                    "title": title,
                    ])
                self.dataReceived = true
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        addArray.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "back"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addcurri"), object: nil)
        }
    }
}


