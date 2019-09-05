//
//  tagEditCollectionView.swift
//  userApp
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class tagEditCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource  {

    var tagArray = ["","",""]
    var dataReceived:Bool = false
    
    var databaseTagArray = Array<String>()
    var selectedTagIndexArray = Array<Int>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        getTagListFromDB()
        getUserSelectedTag()
    }
    
    func getTagListFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/tags").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>;()
            for tag in value! {
                let tagDic = tag.value as! Dictionary<String, Any>;()
                let tag = tagDic["value"] as! String
                self.databaseTagArray.append(tag)
            }
            self.dataReceived = true
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getUserSelectedTag() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/selectedTags").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.exists() || snapshot.value == nil {
                self.reloadData()
                return
            }
            
            let tagList = snapshot.value as! String
            userSelectedTagArray = tagList.components(separatedBy: " ")
            
            let totalTagCount = self.databaseTagArray.count
            let userTagCount = userSelectedTagArray.count
            
            for i in 0...totalTagCount-1 {
                for j in 0...userTagCount-1{
                    if self.databaseTagArray[i] == userSelectedTagArray[j] {
                        //태그 색 변환
                        self.selectedTagIndexArray.append(i)
                    }
                }
            }

            self.reloadData()
            self.dataReceived = true
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    func numberOfSections(in tableView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return databaseTagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagEditCell
        if dataReceived && selectedTagIndexArray.count > 0{
            for i in 0...selectedTagIndexArray.count-1 {
                if selectedTagIndexArray[i] == indexPath.row {
                    cell.backgroundColor = UIColor.init(red: 157/255, green: 206/255, blue: 255/255, alpha: 1.0)
                }
            }
            cell.tagCell.text = databaseTagArray[indexPath.row]
        }else{
            cell.tagCell.text = databaseTagArray[indexPath.row]
        }
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.backgroundColor == nil {
            cell?.backgroundColor = UIColor.init(red: 157/255, green: 206/255, blue: 255/255, alpha: 1.0)
            userSelectedTagArray.append(databaseTagArray[indexPath.row])
        } else {
            cell?.backgroundColor = nil
            removeElementByValue(element:databaseTagArray[indexPath.row])
        }
        
        for tag in userSelectedTagArray {
            if tag == "" {
                removeElementByValue(element:tag)
            }
        }
    }
    
    private func removeElementByValue(element:String) {
        while userSelectedTagArray.contains(element) {
            if let itemToRemoveIndex = userSelectedTagArray.firstIndex(of: element) {
                userSelectedTagArray.remove(at: itemToRemoveIndex)
            }
        }
    }
}
