//
//  VideoQuestionShowViewController.swift
//  userApp
//
//  Created by user on 31/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

//var selectedCopPostId: String = ""

class CoPQuestionShowViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var commentTableView: UIView!
    
    
    var keyboardSettingHeight: CGFloat = 0
    var originalTf: CGFloat = 0
    var originalBtn: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //keyboardHandling(tfComment)
        getQuestionFromDB()
        
        tfComment.returnKeyType = .done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        keyboardHandling(tfComment)
    }
    
    func getQuestionFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/study/" + selectedStudyId + "/board/" + selectedCopPostId).observeSingleEvent(of: .value, with: { (snapshot) in
            let QuestionInfo = snapshot.value as! Dictionary<String, Any>;()
            
            self.lblTitle.text = QuestionInfo["title"]! as? String
            self.lblWriter.text = QuestionInfo["writer"]! as? String
            self.lblContent.text = QuestionInfo["content"] as? String
            
            let date: Double = QuestionInfo["date"] as! Double
            let myTimeInterval = TimeInterval(date)
            let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
            let formatter = DateFormatter()
            formatter.dateFormat = "yy/MM/dd HH:mm"
            let formattedDate = formatter.string(from: ts as Date)
            
            self.lblDate.text = formattedDate
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/study/" + selectedStudyId + "/board/" + selectedCopPostId + "/comment").child(String(UInt(NSDate().timeIntervalSince1970 * 1000000))).setValue([
            "content": tfComment.text as? String,
            "date": Double(NSDate().timeIntervalSince1970),
            "writer": userName
            ])
        tfComment.text = ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CopCommentAdd"), object: nil)
    }
    
    func onGoBack() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        onGoBack()
    }
    
    func keyboardHandling(_ sender:UITextField) {
        // 키보드가 보일때~
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),name:UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질때~
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // 키보드 보이기
    @objc func keyboardWillShow(_ sender: Notification) {
        NSLog("===== keyboardWillShow =====")
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            originalTf = self.tfComment.frame.origin.y
            originalBtn = self.btnSubmit.frame.origin.y
            keyboardSettingHeight = self.view.frame.height - keyboardHeight - tfComment.frame.height - 5
            
            //print(self.view.frame.height)
            //print(keyboardHeight)
            
            self.tfComment.translatesAutoresizingMaskIntoConstraints = true
            self.btnSubmit.translatesAutoresizingMaskIntoConstraints = true
            self.tfComment.frame.origin.y = keyboardSettingHeight
            self.btnSubmit.frame.origin.y = keyboardSettingHeight
        }
    }
    
    // 키보드 숨기기
    @objc func keyboardWillHide(_ sender: Notification) {
        NSLog("===== keyboardWillHide =====")
        self.tfComment.frame.origin.y = originalTf
        self.btnSubmit.frame.origin.y = originalBtn
    }
    
    // 엔터로 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("textFieldShouldReturn")
        
        textField.resignFirstResponder()
        return true
    }
    
    // 아무데나 선택 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}
