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
        return videoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoId = videoIdArray[indexPath.row]
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as! VideoListCell
        
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
