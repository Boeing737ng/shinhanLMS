//
//  MyPageViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//User Info
//- Name
//- Department
//- Selected Tags
//- User's group list
//- User's Playlist

import UIKit
import Firebase

class MyPageViewController: UIViewController{
    
    var dbingArray = Array<String>()
    var dbedArray = Array<String>()
    var dbnameArray = Array<String>()
    var dbfieldArray = Array<String>()
    var dbgroupArray = Array<String>()
    var playnum: Int = 0
    var plednum: Int = 0
    
    @IBOutlet weak var fieldlbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var edLecture: UILabel!
    @IBOutlet weak var imgLecture: UILabel!
    @IBOutlet weak var questionlbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDB()
        getUserInfo()
    }
    
    func getDataFromDB(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList/").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>;()
            for ing in value! {
                let statusD = ing.value as! Dictionary<String, Any>;()
                let status = statusD["state"] as! String
                self.dbingArray.append(status)
                
                if status == "playing"{
                   self.playnum += 1
               }else{
                   self.plednum += 1
                }
            }
            self.imgLecture.text = "\(self.playnum)"
            self.edLecture.text = "\(self.plednum)"
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getUserInfo(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>;()
            let name = value!["name"] as! String
            let department = value!["department"] as! String
            self.dbnameArray.append(name)
            self.dbfieldArray.append(department)
            
            self.namelbl.text = "\(self.dbnameArray[0])"
            self.fieldlbl.text = "\(self.dbfieldArray[0])"
        }) { (error) in
            print(error.localizedDescription)
        }
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
}
