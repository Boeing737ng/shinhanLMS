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
    
    var img = ["imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg", "imgAdd.jpeg"]
    var item = ["AWS", "Java", "Swift", "C", "C++"]
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyPagePreCell
        
//        cell.textLabel?.text = item[(indexPath as NSIndexPath).row]
//        cell.imageView?.image = UIImage(named: img[(indexPath as NSIndexPath).row])
        cell.tagLbl.text = item[(indexPath as NSIndexPath).row]
        cell.tagImg.image = UIImage(named: img[(indexPath as NSIndexPath).row])
        
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
