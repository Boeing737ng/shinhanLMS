//
//  GroupCreate2ViewController.swift
//  userApp
//
//  Created by user on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase

class GroupCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var studyImg: UIImageView!
    @IBOutlet weak var studyName: UITextField!
    @IBOutlet weak var studyDetail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textFieldSetupView()
        }
        
        func textFieldEndEditing(_ textField: UITextField) {
            if textField.text == "" {
                textFieldSetupView()
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textField.resignFirstResponder()
            }
            return true
        }
        
        func textFieldSetupView() {
            if studyDetail.text == "질문 내용을 작성해주세요." {
                studyDetail.text = ""
                studyDetail.textColor = UIColor.black
            }
            else if studyDetail.text == "" {
                studyDetail.text = "질문 내용을 작성해주세요."
                studyDetail.textColor = UIColor.lightGray
            }
        }
        
        studyDetail.delegate = self
        studyName.delegate = self
        picker.delegate = self
        // Do any additional setup after loading the view.
        keyboardHandling(studyDetail)
    }
    
    @IBAction func btnSend(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/").childByAutoId().setValue([
            "detail": studyDetail.text as? String,
            "studyname": studyName.text as? String,
            ])
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addcop"), object: nil)
    }
    
    func openLibrary(){
        
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
        
    }
    
    //사진 이미지를 출력
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            studyImg.image = image
            awakeFromNib()
        }
        dismiss(animated: true, completion: nil)
    }
    // 경고 메시지
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    //카메라 오픈
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
            
        } else {
            self.myAlert("camera inaccessable", message: "Application cannot access the camera")
        }
        
    }
    // 사진 가져오기
    @IBAction func studyAdd(_ sender: UIButton) {
        let alert =  UIAlertController(title: "사진 위치", message: "선택", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
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
    
    func keyboardHandling(_ sender:UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // 키보드 보여주고, 화면을 올려준다
    @objc func keyboardWillShow(_ sender: Notification)
    {
        NSLog("===show===")
        self.view.frame.origin.y = -150
    }
    // 키보드 숨기고, 화면을 원상태로
    @objc func keyboardWillHide(_ sender: Notification){
        NSLog("===hids===")
        self.view.frame.origin.y = 0
    }
    
    // 엔터로 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("==return==")
        textField.resignFirstResponder()
        return true
    }
    //여백 클릭 시 키보드 숨기기
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
    // 이미지 둥글게 하는것
    override func awakeFromNib() {
        super.awakeFromNib()
        studyImg?.contentMode = UIView.ContentMode.scaleAspectFill
        studyImg?.layer.cornerRadius = 20.0
        studyImg?.layer.masksToBounds = true
    }
    
}
