//
//  NotificationViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UIViewController {
    
    //var item = ["새로운 영상이 업로드되었습니다.", "답변이 등록되었습니다.", "관심강의가 등록되었습니다.", "새로운 영상이 업로드되었습니다.", "답변이 등록되었습니다.", "관심강의가 등록되었습니다."]
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getNoticeFromDB()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onGoBack(_ sender: UIBarButtonItem) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
//    func getNoticeFromDB() {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.child("notice").observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? Dictionary<String,Any>;()
//            for noti in value! {
//                let noticeDict = noti.value as! Dictionary<String, Any>;()
//                let text = noticeDict["text"] as! String
//
//                print(text)
//
//                self.noticeArray.append(text)
//            }
//            self.dataReceived = true
//            //self.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
