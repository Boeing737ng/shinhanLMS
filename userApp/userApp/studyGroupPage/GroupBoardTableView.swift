//
//  GroupBoardTableViewController.swift
//  userApp
//
//  Created by user on 31/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

var selectedCopPostId: String = ""

class GroupBoardTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var keyArray = Array<String>()
    var titleArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    var contentArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        getQuestionFromDB()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadtable), name: NSNotification.Name(rawValue: "copboardadd"), object: nil)
    }
    
    @objc func reloadtable() {
        getQuestionFromDB()
        self.reloadData()
    }
    
    func getQuestionFromDB() {
        self.keyArray.removeAll()
        self.titleArray.removeAll()
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/study/" + curri_send + "/board").observeSingleEvent(of: .value, with: { (snapshot) in
            let questionInfo = snapshot.value as? Dictionary<String,Any>;()
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            for question in questionInfo! {
                let questionDict = question.value as! Dictionary<String, Any>;()
                
                let questionId = question.key
                let title = questionDict["title"] as! String
                let content = questionDict["content"] as! String
                let writer = questionDict["writer"] as! String
                
                let date: Double = questionDict["date"] as! Double
                let myTimeInterval = TimeInterval(date)
                let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                let formatter = DateFormatter()
                formatter.dateFormat = "yy/MM/dd HH:mm"
                let formattedDate = formatter.string(from: ts as Date)
                
                //                print(title)
                //                print(content)
                //                print(date)
                //                print(writer)
                //                print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ\n")
                
                self.keyArray.append(questionId)
                self.titleArray.append(title)
                self.contentArray.append(content)
                self.dateArray.append(formattedDate)
                self.writerArray.append(writer)
            }
            //self.dataReceived = true
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
        // #warning Incomplete implementation, return the number of rows
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let copPostId = keyArray[indexPath.row]
        selectedCopPostId = copPostId
        goToCopPostShowPage()
    }
    
    func goToCopPostShowPage() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowStoryboard")
        UIApplication.topViewController()!.present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "copBoardCell", for: indexPath) as! GroupBoardTableViewCell
        
        cell.lblTitle.text = titleArray[(indexPath as NSIndexPath).row]
        cell.lblWriter.text = writerArray[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dateArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
}



/*
 extension VideoQnATableViewController : IndicatorInfoProvider{
 func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
 return IndicatorInfo(title: "질문답변")
 }
 }
 */
