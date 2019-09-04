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
    @IBOutlet weak var essentialProgress: UIProgressView!
    
    @IBOutlet weak var edLecture: UILabel!
    @IBOutlet weak var imgLecture: UILabel!
    @IBOutlet weak var questionlbl: UILabel!
    
    var playnum: Int = 0
    var plednum: Int = 0
    var question: Int = 0
    var totalEssentialLectureCount:Int = 0
    var userEssentialCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromDB()
        getQnumDB()
        getTotalEssentialLectureCount()
    }
    
    func setBasicUserInfo() {
        self.namelbl.text = userName
        self.fieldlbl.text = userDeptName
    }
    
    func getTotalEssentialLectureCount() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/categories").observeSingleEvent(of: .value, with: { (snapshot) in
            let categories = snapshot.value as! Dictionary<String, Any>;()
            for category in categories {
                let cateogoryInfo = category.value as! Dictionary<String, Any>;()
                let categoryName = cateogoryInfo["title"] as! String
                if categoryName == "프로그래밍 언어" {
                    let lectureList = cateogoryInfo["lecture"] as! Dictionary<String, Any>;()
                    self.totalEssentialLectureCount = lectureList.count
                    self.getCurrentUserEssentialProgress()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCurrentUserEssentialProgress() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                print("Playlist is empty!!!!")
                return
            }
            let lectureDict = snapshot.value as! Dictionary<String, Any>;()
            for lecture in lectureDict {
                let lectureInfo = lecture.value as! Dictionary<String, Any>;()
                let isEssential = lectureInfo["requireYn"] as! String
                let state = lectureInfo["state"] as! String
                
                if isEssential == "Y" && state == "completed" {
                    self.userEssentialCount += 1
                }
            }
            self.calculateUserEssentialProgress()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func calculateUserEssentialProgress() {
        var essentialProgressValue:Float
        essentialProgressValue = Float(userEssentialCount / totalEssentialLectureCount)
        print(essentialProgressValue)
        essentialProgress.progress = essentialProgressValue
    }
    
    
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
    
    func getQnumDB(){ // 가입한 CoP 수
        clearArrays()
        let dataURL:String = "user/" + userNo + "/study"
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                self.questionlbl.text = "\(self.dbwriterArray.count)"
                print("CoP NULL!!!!")
                return
            }
            
            let studyCount = Int(snapshot.childrenCount)
            self.questionlbl.text = String(studyCount)
            
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
    
    @IBAction func onGoBack(_ sender: UIBarButtonItem) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logoutbtn(_ sender: UIButton) {
        
    }
    
}
