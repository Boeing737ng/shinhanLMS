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

class VideoDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        print("DB function called")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("videos").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            for item in value! {
                print(item.key)
                var dict = item.value as! Dictionary<String, Any>;()
                print(dict["author"]!)
                print(dict["category"]!)
                print(dict["date"]!)
                print(dict["description"]!)
                print(dict["downloadURL"]!)
                print(dict["tags"]!)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // get URL dynamically
    func playVideo() {
        let url = "https://firebasestorage.googleapis.com/v0/b/shinhanlms.appspot.com/o/videos%2FTween_app_instruction.MP4?alt=media&token=ef53ac22-6729-4056-a9d8-a3f0e0c0b849"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
