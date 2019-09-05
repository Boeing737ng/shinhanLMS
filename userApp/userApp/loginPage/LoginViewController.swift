//
//  LoginViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 26/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Firebase
import BEMCheckBox

class LoginViewController: UIViewController {
    
    var urlDict = [String: String]()
    var autoLoginIsSelected = false
    var id:String = ""
    var pwd:String = ""
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keyboardHandling(idTextField)
        LoadingView().setLoadingStyle(self)
        checkLoginUser()
    }
   
    @IBAction func onClickLoginBtn(_ sender: UIButton) {
        if idTextField.text == "" || pwdTextField.text == "" {
            return
        } else {
            login(id:idTextField.text!, pwd:pwdTextField.text!)
        }
    }
    
    func checkLoginUser() {
        if let userId = UserDefaults.standard.string(forKey: "id") {
            self.id = userId
            self.pwd = UserDefaults.standard.string(forKey: "pwd")!
            login(id:userId, pwd: self.pwd)
        } else {
            return
        }
    }
    
    // TODO:: Authentication funcion needs to be added
    func login(id:String, pwd:String) {
        LoadingView().startLoading(self)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/").observeSingleEvent(of: .value, with: { (snapshot) in
            let userData = snapshot.value as! Dictionary<String, Any>;()
            for user in userData {
                let userDict = user.value as! Dictionary<String, Any>;()
                let userNumber = user.key
                if userNumber == id && pwd == "1234" {
                    userNo = user.key
                    userName = userDict["name"] as! String
                    userCompanyCode = userDict["compCd"] as! String
                    userCompanyName = userDict["compNm"] as! String
                    userDeptCode = String(describing: userDict["department"])
                    userDeptName = userDict["department"] as! String
                    
                    if self.autoLoginIsSelected {
                        UserDefaults.standard.set(id, forKey: "id")
                        UserDefaults.standard.set(pwd, forKey: "pwd")
                    }
                    print("로그인 성공")
                    self.getThumbnailURL()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func imageCachingCompleted() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "imageCached"), object: nil)
    }
    
    @IBAction func saveOnOff(_ sender: BEMCheckBox) {
        if sender.on {
            autoLoginIsSelected = true
        } else {
            autoLoginIsSelected = false
        }
    }
    func keyboardHandling(_ sender: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -30
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func getThumbnailURL() {
        LoadingView().startLoading(self)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/thumbnailUrl").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for video in value! {
                //let videoDict = video.value as! Dictionary<String, Any>;()
                let title = video.key as! String
                let url = video.value as! String
                self.urlDict[title] = url
            }
            ref.child(userCompanyCode + "/study_url").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if !snapshot.exists() || snapshot.childrenCount == 0 {
                    self.setThumbnailCache(withCompletion: self.isCachingCompleted)
                    return
                }
                let value = snapshot.value as? NSDictionary
                for video in value! {
                    //let videoDict = video.value as! Dictionary<String, Any>;()
                    let title = video.key as! String
                    let url = video.value as! String
                    self.urlDict[title] = url
                }
                self.setThumbnailCache(withCompletion: self.isCachingCompleted)
            }) { (error) in
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
       
    }

    func setThumbnailCache(withCompletion completion: () -> Void) {
        for (id, url) in urlDict {
            let imageURL = URL(string: url)
            URLSession.shared.dataTask(with: imageURL!) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data)!
                CachedImageView().setImageCache(item: image, urlKey: id)
                }.resume()
        }
        completion()
        print("Caching completed!!!")
    }
    func isCachingCompleted() {
        print(urlDict)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            LoadingView().stopLoading()
            self.performSegue(withIdentifier: "onSuccessLogin", sender: self)
        }
    }

}
