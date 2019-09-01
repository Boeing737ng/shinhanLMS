//
//  VideoListViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//Video Info
//- thumbnail image
//- name
//- download Url

import UIKit
import XLPagerTabStrip
import KBRoundedButton
import DropDown
import Firebase

var categoryDict1 = Dictionary<Int, String>()
var dropdownCategoryList1 = Array<String>()

class VideoaddViewController: UIViewController {
    var dropdown:DropDown?
    
    @IBOutlet weak var btn1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDropDown()
        setDropdownBarText()
        // Do any additional setup after loading the view.
    }
    @objc func dropdownButton(){
        dropdown?.show()
    }
    
    func setDropdownBarText() {
        var index:Int = 1
        var ref: DatabaseReference!
        dropdownCategoryList1.append("전체보기  ")
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/categories").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                let categoryInfo = video.value as? Dictionary<String,Any>;()
                dropdownCategoryList1.append(categoryInfo!["title"] as! String + "  ")
                categoryDict1[index] = video.key
                index += 1
            }
            print(categoryDict1)
            self.dropdown?.dataSource = dropdownCategoryList1
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initializeDropDown() {
        dropdown = DropDown()
        dropdown?.anchorView = btn1
        dropdown?.bottomOffset = CGPoint(x:0, y:(dropdown?.anchorView?.plainView.bounds.height)!)
        dropdown?.dataSource=[""]
        // Do any additional setup after loading the view.
        btn1.addTarget(self, action: #selector(dropdownButton), for: .touchUpInside)
        dropdown?.selectionAction = {[unowned self] (index: Int, item: String) in
            self.btn1.setTitle(item, for: .normal)
            selectedCategoryIndex = index
            self.categoryIsSeleceted()
        }
    }
    
    func categoryIsSeleceted() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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

extension VideoaddViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "CoP")
    }
  
    
}
