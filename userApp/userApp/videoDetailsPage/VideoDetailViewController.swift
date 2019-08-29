//
//  VideoDetailViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//Video Info
//- Everything about selected video

import UIKit
import Firebase
import AVKit

var selectedVideoId:String = ""
var videoURL:String = ""

class VideoDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVideoInfoFromDB()
        // Do any additional setup after loading the view.
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
    
    func getVideoInfoFromDB() {
        LoadingView().startLoading(self)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId).observeSingleEvent(of: .value, with: { (snapshot) in
            let videoInfo = snapshot.value as! Dictionary<String, Any>;()
            videoURL = videoInfo["downloadURL"] as! String
            LoadingView().stopLoading()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // get URL dynamically
    func playVideo() {
        let url = videoURL
        let player = AVPlayer(url: URL(string: url)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func seg(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            self.segView.addSubview()
        }
        else if sender.selectedSegmentIndex == 1 {
        }
        else if sender.selectedSegmentIndex == 2 {
        }
    }
}
