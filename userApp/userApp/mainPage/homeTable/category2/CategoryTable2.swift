//
//  CategoryTable1.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class CategoryTable2: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var urlArray = ["","",""]
    var dataReceived:Bool = false
    
    var playingTitleArray = Array<String>()
    var playingAuthorArray = Array<String>()
    var playingThumbnailArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/201302493/playList/completed").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let title = (video.key as AnyObject).description
                let author = videoDict["author"] as! String
                let thumbnailUrl = videoDict["thumbnail"] as! String
                
                self.playingTitleArray.append(title!)
                self.playingAuthorArray.append(author)
                self.playingThumbnailArray.append(thumbnailUrl)
                
            }
            self.dataReceived = true
            self.textArray = self.playingTitleArray
            self.authorArray = self.playingAuthorArray
            self.urlArray = self.playingThumbnailArray
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell2") as! VideoCell2
        
        cell.videoTitleLabel.text = textArray[indexPath.row]
        cell.videoAuthorLabel.text = authorArray[indexPath.row]
        if dataReceived {
            let url = URL(string: urlArray[indexPath.row])
            if let data = try? Data(contentsOf: url!)
            {
                let image: UIImage = UIImage(data: data)!
                cell.videoThumbnail.image = image
            }
        } else {
            cell.videoThumbnail.image = UIImage(named: "white.jpg")
        }
        
        return cell
    }
}
