//
//  tagEditViewController.swift
//  userApp
//
//  Created by user on 24/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class tagEditViewController: UIViewController{
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func saveSelectedTags(_ sender: UIBarButtonItem) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo).updateChildValues([
            "selectedTags": setUserTagString()
            ]
        )
        userTagUpdated()
        popPage()
    }
    
    func userTagUpdated() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTagUpdated"), object: nil)
    }
    
    private func setUserTagString() -> String {
        var userTagString:String = ""
        for tag in userSelectedTagArray {
            userTagString += (tag + " ")
        }
        return userTagString
    }
    
    @IBAction func onGoBack(_ sender: Any) {
        popPage()
    }
    
    func popPage() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
