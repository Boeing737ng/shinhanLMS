//
//  VideoQuestionShowTableViewController.swift
//  userApp
//
//  Created by user on 30/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class VideoQuestionShowTableViewController: UITableViewController {
    
    var keyArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    var contentArray = Array<String>()
    var totalKeyArray = Array<String>()
    var totalDateArray = Array<String>()
    var totalWriterArray = Array<String>()
    var totalContentArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getQuestionCommentFromDB()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadComment), name: NSNotification.Name(rawValue: "commentAdd"), object: nil)
    }
    
    @objc func reloadComment() {
        getQuestionCommentFromDB()
        self.tableView.reloadData()
    }
    
    func initArray() {
        self.keyArray.removeAll()
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        self.totalKeyArray.removeAll()
        self.totalContentArray.removeAll()
        self.totalDateArray.removeAll()
        self.totalWriterArray.removeAll()
    }
    
    func getQuestionCommentFromDB() {
        initArray()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard/" + selectedQuestionId + "/comment/").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let dataSize = Int(snapshot.childrenCount) - 1
            
            for comment in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let commentInfo = comment.value as? [String : Any] {
                    self.totalKeyArray.append(comment.key)
                    self.totalContentArray.append(commentInfo["content"] as! String)
                    self.totalWriterArray.append(commentInfo["writer"] as! String)
                    
                    let date: Double = commentInfo["date"] as! Double
                    let myTimeInterval = TimeInterval(date)
                    let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy/MM/dd HH:mm"
                    let formattedDate = formatter.string(from: ts as Date)
                    
                    self.totalDateArray.append(formattedDate)
                }
            }
            
            for i in 0...dataSize {
                self.keyArray.append(self.totalKeyArray[dataSize - i])
                self.contentArray.append(self.totalContentArray[dataSize - i])
                self.dateArray.append(self.totalDateArray[dataSize - i])
                self.writerArray.append(self.totalWriterArray[dataSize - i])
            }
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        cell.lblWriter.text = writerArray[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dateArray[(indexPath as NSIndexPath).row]
        cell.lblContent.text = contentArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
}
