//
//  tagEditViewController.swift
//  userApp
//
//  Created by user on 24/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class tagEditViewController: UIViewController{
    
    //    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath)
    //        cell?.backgroundColor = UIColor.cyan
    //    }
    //    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath)
    //        cell?.backgroundColor = nil
    //    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //
    //    @IBAction func btn(_ sender: UIButton) {
    //        NSLog("===click===")
    //    }
    //
    @IBAction func onGoBack(_ sender: UIButton) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
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
