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
    let MAX_ARRAY_NUM = 10
    let PICKER_VIEW_COLUMN = 1
//    var textArray = ["","",""]
//    var authorArray = ["","",""]
//    var dataReceived:Bool = false
//
//    var playingVideoIdArray = Array<String>()
//    var playingTitleArray = Array<String>()
//    var playingAuthorArray = Array<String>()
    var study_name=["asd","asdasd","asdasdasd"]
    var imageArray=[UIImage?]()
    var imgfilename=["ID.png","PW.png","back.png"]
    var detail_txt=["dasdsasadasdadasdasdasdas","dasdsasadasdadasdasdasdaswqeqweqeqwe","dasdsasadasdadasdasdasdasasdasdasadasdsd"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return study_name.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return study_name[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        detail.text=detail_txt[row]
        imageview.image=imageArray[row]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< 3{
            let image = UIImage(named: imgfilename[i])
            imageArray.append(image)
        }
        detail.text=detail_txt[0]
        imageview.image=imageArray[0]
        // Do any additional setup after loading the view.
    }

}

extension GroupMainViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "CoP")
    }
}
