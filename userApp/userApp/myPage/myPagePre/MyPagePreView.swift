//
//  MyPagePreView.swift
//  userApp
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class MyPagePreView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var dataReceived:Bool = false
    
    var playingVideoIdArray = Array<String>()
    var playingTitleArray = Array<String>()
    var playingAuthorArray = Array<String>()
    
    var img = ["imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg","imgAdd.jpeg"]
    var item = ["AWS", "Java", "Swift", "C", "C++", "swift"]
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self

        videoDataLoad()

    }
    
    func videoDataLoad(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key as! String
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.playingVideoIdArray.append(videoId)
                self.playingTitleArray.append(title)
                self.playingAuthorArray.append(author)
                
            }
            self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.playingTitleArray.count
        //return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyPagePreCell
        if dataReceived {
        cell.tagLbl.text = self.playingTitleArray[indexPath.row]
        cell.tagImg.image = CachedImageView().loadCacheImage(urlKey: playingVideoIdArray[indexPath.row])
            cell.taglbl2.text = self.playingAuthorArray[indexPath.row]
        }else{
            cell.tagLbl.text = item[indexPath.row]
            cell.tagImg.image = UIImage(named: img[(indexPath as NSIndexPath).row])
        }
            return cell
            
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            item.remove(at: (indexPath as NSIndexPath).row)
            img.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert{
            
        }
    }

}
