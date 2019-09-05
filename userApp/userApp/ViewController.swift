//
//  ViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 19/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

// For test Commit
import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var alarmCountView: UIView!
    @IBOutlet weak var alarmCountLabel: UILabel!
    var notificationCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundBtn()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationCount()
    }
    
    func roundBtn() {
        alarmCountView.layer.cornerRadius = 9
        alarmCountView.clipsToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (goToNotification(_:)))
        alarmCountView.addGestureRecognizer(gesture)
    }
    
    func getNotificationCount() {
        notificationCount = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/notice/" + userNo).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                self.notificationCount = 0
                self.alarmCountView.isHidden = true
                return
            }
            
            let notices = snapshot.value as! Dictionary<String, Any>;()
            for notice in notices {
                let noticeDict = notice.value as! Dictionary<String, Any>;()
                let state:String = noticeDict["state"] as! String
                if state == "read" {
                    continue
                } else {
                    self.notificationCount += 1
                }
            }
            if self.notificationCount == 0 {
                self.alarmCountView.isHidden = true
                return
            }
            self.alarmCountView.isHidden = false
            self.alarmCountLabel.text = String(self.notificationCount)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @objc func goToNotification(_ sender:UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goToNotification", sender: self)
    }
    
}
