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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getQuestionCommentFromDB()
    }
    
    func getQuestionCommentFromDB() {
        self.keyArray.removeAll()
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard/" + selectedQuestionId + "/comment").observeSingleEvent(of: .value, with: { (snapshot) in
            let commentInfo = snapshot.value as? Dictionary<String,Any>;()
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            for comment in commentInfo! {
                let commentDict = comment.value as! Dictionary<String, Any>;()
                
                let commentId = comment.key
                let content = commentDict["content"] as! String
                let writer = commentDict["writer"] as! String
                
                let date: Double = commentDict["date"] as! Double
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
                
                self.keyArray.append(commentId)
                self.contentArray.append(content)
                self.dateArray.append(formattedDate)
                self.writerArray.append(writer)
            }
            //self.dataReceived = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        cell.lblWriter.text = writerArray[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dateArray[(indexPath as NSIndexPath).row]
        cell.lblContent.text = contentArray[(indexPath as NSIndexPath).row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
