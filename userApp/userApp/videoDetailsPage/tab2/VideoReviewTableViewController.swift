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

    var totalContentArray = Array<String>()
    var totalDateArray = Array<String>()
    var totalWriterArray = Array<String>()
    
    var contentArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getReviewFromDB()
    }
    
    func getReviewFromDB() {
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/review/").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let dataSize = Int(snapshot.childrenCount) - 1
            
            //let reviewInfo = snapshot.value as? Dictionary<String,Any>;()
            
            for review in snapshot.children.allObjects as! [DataSnapshot] {
                //let reviewDict = review.value as! Dictionary<String, Any>;()
                if let reviewInfo = review.value as? [String : Any] {
                    self.totalContentArray.append(reviewInfo["content"] as! String)
                    
                    let date: Double = reviewInfo["date"] as! Double
                    let myTimeInterval = TimeInterval(date)
                    let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy/MM/dd HH:mm"
                    let formattedDate = formatter.string(from: ts as Date)

                    self.totalDateArray.append(formattedDate)
                    self.totalWriterArray.append(reviewInfo["writer"] as! String)
                } 
//                let content = reviewDict["content"] as! String
//                let writer = reviewDict["writer"] as! String
//
//                let date: Double = reviewDict["date"] as! Double
//                let myTimeInterval = TimeInterval(date)
//                let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yy/MM/dd HH:mm"
//                let formattedDate = formatter.string(from: ts as Date)
                
//                print(content)
//                print(review.key)
//                print(writer)
//                print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ\n")
            }
            for i in 0...dataSize {
                self.contentArray.append(self.totalContentArray[dataSize - i])
                self.dateArray.append(self.totalDateArray[dataSize - i])
                self.writerArray.append(self.totalWriterArray[dataSize - i])
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
