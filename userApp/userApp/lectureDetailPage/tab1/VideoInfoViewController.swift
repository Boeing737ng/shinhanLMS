//
//  TestViewController.swift
//  eeeeee
//
//  Created by user on 23/08/2019.
//  Copyright © 2019 강희승. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase

var videoDescription:String = ""

class VideoInfoViewController: UIViewController {
    
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoViewCount: UILabel!
    @IBOutlet weak var videoAuthor: UILabel!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLectureDescriptionFromDB()
//        self.tv.layer.borderWidth = 1.0
//        self.tv.layer.borderColor = UIColor.black.cgColor
//        self.tv.layer.cornerRadius = 4
//        self.tv.layer.masksToBounds = true
        
        
        // Do any additional setup after loading the view.
    }
    
    func getLectureDescriptionFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId).observeSingleEvent(of: .value, with: { (snapshot) in
            let videoInfo = snapshot.value as! Dictionary<String, Any>;()
            self.videoDescriptionLabel.text = videoInfo["description"]! as? String
            self.videoTitle.text = videoInfo["title"]! as? String
            self.videoAuthor.text = videoInfo["author"]! as? String
            self.videoViewCount.text = videoInfo["view"] as? String
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
extension VideoInfoViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "강좌소개")
    }
}
