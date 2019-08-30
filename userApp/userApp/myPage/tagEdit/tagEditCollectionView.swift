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
        tagLoadDB()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "load"), object: nil)
//        studyImg?.contentMode = UIView.ContentMode.scaleAspectFill
//        studyImg?.layer.cornerRadius = 20.0
//        studyImg?.layer.masksToBounds = true
    }
    
    func getDataFromDB() {
        clearArrays()
//        var dataURL:String = ""
//        dataURL = userCompanyCode + "/tags"
       var dataURL:String = "58/tags"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>;()
            for tag in value! {
                let tagDic = tag.value as! Dictionary<String, Any>;()
                let tag = tagDic["value"] as! String
                self.databaseTitleArray.append(tag)
            }
            self.dataReceived = true
            DispatchQueue.main.async {
                self.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    var arr = Array<String>()
    func tagLoadDB(){
        clearArrays()
  //      var dataURL:String = ""
  //      dataURL = "user/" + userNo
        var dataURL:String = "user/201302493"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>;()
            //for tag2 in value! {
                let tDic = value as! Dictionary<String, Any>;()
                let tag = tDic["selectedTags"] as! String
                self.databaseAuthorArray.append(tag)
           // }
            print(tag)
            self.arr = tag.components(separatedBy: " ")
            var arr2 = self.arr.count
            print(self.arr[0])
            
            let tagcount = self.databaseTitleArray.count
            for cout in 0...tagcount-1 {
                for cout2 in 0...arr2-1{
                    if self.databaseTitleArray[cout] == self.arr[cout2] {
                        //태그 색 변환
                        
                    }
                }
            }
            
            self.dataReceived = true
            }){ (error) in
                print(error.localizedDescription)
            }
        }
    
    
    func clearArrays() {
        databaseTitleArray.removeAll()
        databaseAuthorArray.removeAll()
    }
    
    @objc func reloadTable() {
        getDataFromDB()
        self.reloadData()
    }
    
    func numberOfSections(in tableView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return databaseTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagEditCell
        if dataReceived{
            cell.tagCell.text = databaseTitleArray[indexPath.row]
        }else{
            cell.tagCell.text = textArray[indexPath.row]
        }

//
        return cell
    }
    
    var num = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagEditCell
        
       let cell = collectionView.cellForItem(at: indexPath)
        
        if num%2 == 0{
            cell?.backgroundColor = UIColor.lightGray
            cell?.layer.cornerRadius = 10
            //cell.tagCell.backgroundColor = UIColor.cyan
            num = num + 1
        } else{
            cell?.backgroundColor = nil
            num = num + 1
        }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
