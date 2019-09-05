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
    
    var completedVideoIdArray = Array<String>()
    var completedTitleArray = Array<String>()
    var completedAuthorArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        videoDataLoad()
    }
    
    func clearArrays() {
        completedVideoIdArray.removeAll()
        completedTitleArray.removeAll()
        completedAuthorArray.removeAll()
    }
    
    func videoDataLoad(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let value = snapshot.value as? NSDictionary
            
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                
                let status = videoDict["state"] as! String
                
                if status == "completed" {
                    let videoId = video.key as! String
                    let title = videoDict["title"] as! String
                    let author = videoDict["author"] as! String
                    
                    self.completedVideoIdArray.append(videoId)
                    self.completedTitleArray.append(title)
                    self.completedAuthorArray.append(author)
                }
                else {
                    continue
                }
            }
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
        
        return self.completedVideoIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyPagePreCell
        
            cell.tagLbl.text = self.completedTitleArray[indexPath.row]
            cell.tagImg.image = CachedImageView().loadCacheImage(urlKey: completedVideoIdArray[indexPath.row])
            cell.taglbl2.text = self.completedAuthorArray[indexPath.row]
        
        return cell
    }
}
