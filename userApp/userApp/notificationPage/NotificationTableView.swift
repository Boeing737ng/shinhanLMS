//
//  NotificationTableView.swift
//  userApp
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class NotificationTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var keyArray = Array<String>()
    var detailKeyArray = Array<String>()
    var detailTextArray = Array<String>()
    var stateArray = Array<String>()
    var textArray = Array<String>()
    var dateArray = Array<String>()
    var titleArray = Array<String>()
    
    var totalKeyArray = Array<String>()
    var totalDetailKeyArray = Array<String>()
    var totalDetailTextArray = Array<String>()
    var totalStateArray = Array<String>()
    var totalTextArray = Array<String>()
    var totalDateArray = Array<String>()
    var totalTitleArray = Array<String>()

    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        getNoticeFromDB()
    }
    
    func getNoticeFromDB() {
        initArray()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/notice/" + userNo).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let dataSize = Int(snapshot.childrenCount) - 1
            
            for noti in snapshot.children.allObjects as! [DataSnapshot] {
                if let notiInfo = noti.value as? [String : Any] {
                    self.totalKeyArray.append(noti.key)
                    self.totalDetailKeyArray.append(notiInfo["detailKey"] as! String)
                    self.totalDetailTextArray.append(notiInfo["detailText"] as! String)
                    self.totalStateArray.append(notiInfo["state"] as! String)
                    self.totalTextArray.append(notiInfo["text"] as! String)
                    self.totalDateArray.append(notiInfo["date"] as! String)
                    self.totalTitleArray.append(notiInfo["title"] as! String)
                }
            }
            
            for i in 0...dataSize {
                self.keyArray.append(self.totalKeyArray[dataSize - i])
                self.detailKeyArray.append(self.totalDetailKeyArray[dataSize - i])
                self.detailTextArray.append(self.totalDetailTextArray[dataSize - i])
                self.stateArray.append(self.totalStateArray[dataSize - i])
                self.textArray.append(self.totalTextArray[dataSize - i])
                self.dateArray.append(self.totalDateArray[dataSize - i])
                self.titleArray.append(self.totalTitleArray[dataSize - i])
            }
            
            //self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initArray() {
        keyArray.removeAll()
        detailKeyArray.removeAll()
        detailTextArray.removeAll()
        stateArray.removeAll()
        textArray.removeAll()
        dateArray.removeAll()
        titleArray.removeAll()
    
        totalKeyArray.removeAll()
        totalDetailKeyArray.removeAll()
        totalDetailTextArray.removeAll()
        totalStateArray.removeAll()
        totalTextArray.removeAll()
        totalDateArray.removeAll()
        totalTitleArray.removeAll()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notiCell") as! NotificationTableViewCell
        
        if stateArray[(indexPath as NSIndexPath).row] == "unread" {
            cell.imgReadUnread.image = UIImage(named: "notice")
        }
        else {
            cell.imgReadUnread.image = UIImage(named: "readNotice")
            cell.backgroundColor = UIColor.lightGray
        }
        cell.lblText.text = textArray[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dateArray[(indexPath as NSIndexPath).row]
        cell.lblTitle.text = titleArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
}
