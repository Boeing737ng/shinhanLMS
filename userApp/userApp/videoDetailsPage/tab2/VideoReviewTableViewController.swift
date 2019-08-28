//
//  TableViewControllerTwo.swift
//  eeeeee
//
//  Created by 강희승 on 22/08/2019.
//  Copyright © 2019 강희승. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

class VideoReviewTableViewController: UITableViewController {

    var contentArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getReviewFromDB()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getReviewFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/review").observeSingleEvent(of: .value, with: { (snapshot) in
            let reviewInfo = snapshot.value as? Dictionary<String,Any>;()
            
            for review in reviewInfo! {
                let reviewDict = review.value as! Dictionary<String, Any>;()
                let content = reviewDict["content"] as! String
                let date = String(reviewDict["date"] as! Int)
                let writer = reviewDict["writer"] as! String
                
//                print(content)
//                print(date)
//                print(writer)
//                print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ\n")
                
                self.contentArray.append(content)
                self.dateArray.append(date)
                self.writerArray.append(writer)
            }
            //self.dataReceived = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath) as! TableViewCellTwo
        
        cell.lblcontent.text = contentArray[indexPath.row]
        cell.lblDate.text = dateArray[indexPath.row]
        cell.lblWriter.text = writerArray[indexPath.row]
        
        return cell
    }
    
}

extension VideoReviewTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수강후기")
    }
}
