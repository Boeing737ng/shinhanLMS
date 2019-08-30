//
//  VideoReviewWriteViewController.swift
//  userApp
//
//  Created by user on 29/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class VideoQuestionWriteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var tvContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        if tvContent.text == "질문 내용을 작성해주세요." {
            tvContent.text = ""
            tvContent.textColor = UIColor.black
        }
        else if tvTitle.text == "질문 제목을 작성해주세요." {
            tvContent.text = ""
            tvContent.textColor = UIColor.black
        }
        else if tvContent.text == "" {
            tvContent.text = "질문 내용을 작성해주세요."
            tvContent.textColor = UIColor.lightGray
        }
        else if tvTitle.text == "" {
            tvContent.text = "질문 제목을 작성해주세요."
            tvContent.textColor = UIColor.lightGray
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormat.string(from: date)
        return dateString
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
    
    @IBAction func btnSend(_ sender: UIBarButtonItem) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard").childByAutoId().setValue([
            "content": tvContent.text as? String,
            "date": getCurrentDate(),
            "title": tvTitle.text as? String,
            "writer": userName
            ])
        
        onGoBack()
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        onGoBack()
    }
    
    func keyboardHandling(_ sender: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ sender: Notification) {
        NSLog("====== keyboardWillShow ======")
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        NSLog("====== keyboardWillShow ======")
        self.view.frame.origin.y = 0
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
