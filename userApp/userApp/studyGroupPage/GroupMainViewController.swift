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
var CoPcheck : Int  = 0
class GroupMainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerImage: UIPickerView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var detail: UILabel!
    let MAX_ARRAY_NUM = 100
    let PICKER_VIEW_COLUMN = 1
    var dataReceived:Bool = false
    var study_nameArray = Array<String>()
    var study_detailtxt = Array<String>()
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
        
        print(curri_send)
        if(row==0){
            imageview.image = UIImage(named: "default.png")
            curri_send = "0"
        }
        else{
            curri_send = curri[row-1]
            check_CoP()
            imageview.image = CachedImageView().loadCacheImage(urlKey:curri_send)}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "copchange"), object: nil)
    }
    @objc func refresh() {
        //initArrays()
        self.viewDidLoad()
        pickerImage.selectedRow(inComponent: 0)
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
            }
            self.dataReceived = true
            self.pickerImage.reloadAllComponents()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
//    @IBAction func board(_ sender: UIButton) {
//        if(CoPcheck==1)
//        {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier:) as! ResultViewController
//        }
//        else
//        {
//            let dialog = UIAlertController(title: "알림", message: "이미가입된CoP입니다!", preferredStyle: .alert)
//            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
//            dialog.addAction(action)
//            self.present(dialog, animated: true, completion: nil)
//        }
//    }
    @IBAction func CoPJoin(_ sender: UIButton) {
        print(CoPcheck)
        if(CoPcheck==0)
        {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("58/study/" + curri_send + "/member/").child(userNo).setValue([
                "name": userName,
                "department": userDeptName,
                "compNm": userCompanyName
                ])
            ref.child("user/"+userNo+"/study").childByAutoId().setValue(["key": curri_send])
            let dialog = UIAlertController(title: "가입되었습니다!", message: "CoP게시판을 활용해보세요!", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
            CoPcheck = 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memberAdd"), object: nil)
        }
        else{
            let dialog = UIAlertController(title: "알림", message: "이미가입된CoP입니다!", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
        }
    }
    func check_CoP()
    {
        CoPcheck = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/"+userNo+"/study").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.childrenCount == 0 {
                return
            }
            let value = snapshot.value as? Dictionary<String,Any>;()
            for study in value! {
                let studyDict = study.value as! Dictionary<String, Any>;()
                let cop = studyDict["key"] as! String
                if(cop==curri_send)
                {
                    CoPcheck = 1
                    return
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func initArrays() {
        study_nameArray.removeAll()
        study_nameArray.append("CoP선택")
        study_detailtxt.removeAll()
        study_detailtxt.append(" ")
        curri.removeAll()
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
