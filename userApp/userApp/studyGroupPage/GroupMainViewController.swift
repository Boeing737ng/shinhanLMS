//
//  GroupMainViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE::-----
//Group List Info
//- Group Image
//- Group Name
//- Group's population

import UIKit
import Firebase
import XLPagerTabStrip
class GroupMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerImage: UIPickerView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var detail: UILabel!
    let MAX_ARRAY_NUM = 100
    let PICKER_VIEW_COLUMN = 1
//    var textArray = ["","",""]
//    var authorArray = ["","",""]
   var dataReceived:Bool = false
//
    var study_nameArray = ["ios CoP"]
//    var playingTitleArray = Array<String>()
//    var playingAuthorArray = Array<String>()
    //var playingVideoIdArray = Array<String>()
    //var playingTitleArray = Array<String>()
    //var playingAuthorArray = Array<String>()
    //var study_name=["asd","asdasd","asdasdasd"]
    var imageArray=[UIImage?]()
    var imgfilename=["ios.png","ID.png","PW.png"]
    var detail_txt=["""
iOS 앱 개발이라고 하면 마이너 하다거나 어렵게 생각하시는 분들이 많은 것 같아요
Swift, Objective-C, Xcode등 평소에 접하기 어려운 것들이 많아서 그런 것 같은데, 함께 스터디를 해보면 ‘생각보다 iOS 앱 개발이 쉽구나’라고 느낄 수 있을 겁니다.
재미있게 Cop를 참여하다 보면 실력은 따라오는 것 같아요.
비전공자분들이나, 이제 iOS 개발에 입문하는 분, 취미로 배워보는 분 등 모두가 참여할 수 있습니다.
개발 경험과 상관없이 무엇보다 재밌는 CoP를 함께 만들어 봅시다.
""","dasdsasadasdadasdasdasdas","dasdsasadasdadasdasdasdaswqeqweqeqwe"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return study_nameArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return study_nameArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        detail.text=detail_txt[row]
        imageview.image=imageArray[row]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.child("신한은행/study").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            for study in value! {
//                let studyDict = study.value as! Dictionary<String, Any>;()
//                let studyID = study.key as! String
//                let studytitle = studyDict["studyname"] as! String
//               // let author = videoDict["author"] as! String
////                self.playingVideoIdArray.append(videoId)
////                self.playingTitleArray.append(title)
////                self.playingAuthorArray.append(author)
//                  self.study_nameArray.append(studytitle)
//            }
//            self.dataReceived = true
//            self.pickerImage.reloadAllComponents()
//            //self.reloadData()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        for i in 0 ..< 2{
//            let image = UIImage(named: imgfilename[i])
//            imageArray.append(image)
//        }
//        detail.text=detail_txt[0]
//        imageview.image=imageArray[0]
//        // Do any additional setup after loading the view.
    }
}
extension GroupMainViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "CoP")
    }
}
