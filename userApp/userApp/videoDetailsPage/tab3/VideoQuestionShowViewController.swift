//
//  VideoQuestionShowViewController.swift
//  userApp
//
//  Created by user on 31/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

//var selectedQuestionId: String = "-Ln_SeugMAsLj5l1HKMc"

class VideoQuestionShowViewController: UIViewController {
    
    @IBOutlet weak var commentTableView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var tfComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        keyboardHandling(commentView)
        getQuestionFromDB()
    }
    
    
    func getQuestionFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard/" + selectedQuestionId).observeSingleEvent(of: .value, with: { (snapshot) in
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
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard/" + selectedQuestionId + "/comment").child(String(UInt(NSDate().timeIntervalSince1970 * 1000000))).setValue([
            "content": tfComment.text as? String,
            "date": Double(NSDate().timeIntervalSince1970),
            "writer": userName
            ])
        tfComment.text = ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "commentAdd"), object: nil)
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
    
    func keyboardHandling(_ sender: UIView) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        NSLog("====== keyboardWillShow ======")
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            print(self.view.frame.height)
            print(keyboardHeight)
            //print(self.view.frame.height)
            
            
            self.commentView.frame.origin.y = self.view.frame.height - keyboardHeight - commentView.frame.height - 5
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        NSLog("====== keyboardWillShow ======")
        self.commentView.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("====== textFieldShouldReturn ======")
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

