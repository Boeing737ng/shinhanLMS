//
//  tagEditCollectionView.swift
//  userApp
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class tagEditCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource  {

    var item = ["AWS", "dsdsdsdsdsdd", "ccc", "sss", "www"]
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
//        studyImg?.contentMode = UIView.ContentMode.scaleAspectFill
//        studyImg?.layer.cornerRadius = 20.0
//        studyImg?.layer.masksToBounds = true
    }
    func numberOfSections(in tableView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagEditCell
        
        cell.tagCell.text = item[(indexPath as NSIndexPath).row]
        
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 8
//        let title = UILabel(frame: CGRect(x: 15, y: 60, width: 150, height: 40))
//        title.textColor = UIColor.black
//        title.text = item[(indexPath as NSIndexPath).row]
//        title.textAlignment = .center
//        cell.contentView.addSubview(title)
//
        return cell
    }
    
    var num = 0
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! tagEditCell
        
       let cell = collectionView.cellForItem(at: indexPath)
        
        if num%2 == 0{
            cell?.backgroundColor = UIColor.groupTableViewBackground
            cell?.layer.cornerRadius = 20
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
