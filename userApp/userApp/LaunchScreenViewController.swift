//
//  LaunchScreenViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 05/09/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        launchFinished()
        // Do any additional setup after loading the view.
    }
    
    func launchFinished() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.performSegue(withIdentifier: "launchScreen", sender: self)
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
