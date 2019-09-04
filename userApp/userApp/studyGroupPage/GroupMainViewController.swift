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
import Foundation

var curri = Array<String>()
var curri_send : String = ""
class GroupMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerImage: UIPickerView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var detail: UILabel!
    let MAX_ARRAY_NUM = 100
    let PICKER_VIEW_COLUMN = 1
    var dataReceived:Bool = false
    var study_nameArray = Array<String>()
    var study_detailtxt = Array<String>()
    //var study_img = Array<String>()
    var joinOn = true
    
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
        //curri=study_nameArray[row]
        detail.text = study_detailtxt[row]
        curri_send = curri[row]
        print(curri_send)
        imageview.image = CachedImageView().loadCacheImage(urlKey:curri_send)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "copchange"), object: nil)
        
    }
    @objc func refresh() {
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "addcop"), object: nil)
    }
    func getData() {
        initArrays()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print(userCompanyCode)
        
        ref.child(userCompanyCode + "/study").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.childrenCount == 0 {
                return
            }
            let value = snapshot.value as? Dictionary<String,Any>;()
            for study in value! {
                let studyDict = study.value as! Dictionary<String, Any>;()
                let studyID = study.key as! String
                curri.append(studyID)
                let studytitle = studyDict["studyname"] as! String
                let studydetail = studyDict["detail"] as! String
                //let studyimage = studyDict["img"] as! String
                self.study_nameArray.append(studytitle)
                self.study_detailtxt.append(studydetail)
                // self.study_img.append(studyimage)
            }
            self.dataReceived = true
            self.pickerImage.reloadAllComponents()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func CoPJoin(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/" + curri_send + "/member/").child(userNo).setValue([
            "name": userName,
            "department": userDeptName,
            "compNm": userCompanyName
            ])
        
        ref.child("user/" + userNo + "/study/").childByAutoId().setValue([
            "key": curri_send
            ])
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberAdd"), object: nil)
        
       /* if(joinOn==true) {
            let joinOn = UIAlertController(title: "알림", message: "이미 가입되었습니다", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            joinOn.addAction(onAction)
            present(jo)
        } else {
            
        }
 */
    }
    
    func initArrays() {
        study_nameArray.removeAll()
        study_detailtxt.removeAll()
        //study_img.removeAll()
    }
}
extension GroupMainViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "CoP")
    }
}
extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
