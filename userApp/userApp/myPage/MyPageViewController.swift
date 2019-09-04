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
    

    
    var textArray = ["","",""]
    var authorArray = ["","",""]
    var dataReceived:Bool = false
    
    var dbingArray = Array<String>()
    var dbedArray = Array<String>()
    var dbnameArray = Array<String>()
    var dbfieldArray = Array<String>()
    var dbgroupArray = Array<String>()
    var dbwriterArray = Array<String>()

    
    //@IBOutlet weak var taglbl: UILabel!
    
    @IBOutlet weak var fieldlbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    
    @IBOutlet weak var edLecture: UILabel!
    @IBOutlet weak var imgLecture: UILabel!
    @IBOutlet weak var questionlbl: UILabel!

    
    var playnum: Int = 0
    var plednum: Int = 0
    
    func getDataFromDB(){
        clearArrays()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                self.imgLecture.text = "\(self.playnum)"
                self.edLecture.text = "\(self.plednum)"
                print("Playlist is empty!!!!")
                return
            }
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
            self.dataReceived = true
        }) { (error) in
            print(error.localizedDescription)
        }
        }
    
    func getNamePartDB(){
        clearArrays()
        var dataURL:String = "user/201302493"
//        var dataURL:String = ""
//        dataURL = "user/" + userNo
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>;()
            let nameD = value as! Dictionary<String, Any>;()
            let partD = value as! Dictionary<String, Any>;()
            let name = nameD["name"] as! String
            let part = partD["department"] as! String
            self.dbnameArray.append(name)
            self.dbfieldArray.append(part)
            
            self.namelbl.text = "\(self.dbnameArray[0])"
            self.fieldlbl.text = "\(self.dbfieldArray[0])"
            
            self.dataReceived = true
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getQnumDB(){
        clearArrays()
        var dataURL:String = "board_request/201302493"

        var ref: DatabaseReference!
        ref = Database.database().reference()
         ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in

            let value = snapshot.value as? Dictionary<String, Any>;()
            let nameD = value as! Dictionary<String, Any>;()
            let name = nameD["contents"] as! String
            self.dbwriterArray.append(name)

            self.questionlbl.text = "\(self.dbwriterArray.count)"
            print(self.dbwriterArray.count)
            self.dataReceived = true

         }) { (error) in
            print(error.localizedDescription)
    }
    }
    
    func clearArrays() {
        dbedArray.removeAll()
        dbingArray.removeAll()
        dbnameArray.removeAll()
        dbfieldArray.removeAll()
        dbgroupArray.removeAll()
        dbwriterArray.removeAll()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDB()
        getNamePartDB()
        getQnumDB()
//        self.imgLecture.text = "\(self.playnum)"
//        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
//        print("======================")
//        print("======= \(dbingArray)")
//        imgLecture.text = "\(dbingArray.count)"

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
