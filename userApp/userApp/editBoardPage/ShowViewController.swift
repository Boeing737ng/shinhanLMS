//
//  ShowViewController.swift
//  userApp
//
//  Created by user on 24/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "showIdentifier", for: indexPath)
        
        //cell.lblreply.text = "1"
        
        //tableView.dequeueReusableCell(withIdentifier: "showIdentifier") as! ShowTableViewCell

        return cell
    }
    
    
    @IBOutlet weak var tv: UITextView!
    @IBOutlet weak var replyTable: ShowTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        replyTable.delegate = self
        replyTable.dataSource = self
//        replyTable.tableFooterView =
        
        self.tv.layer.borderWidth = 1.0
        self.tv.layer.borderColor = #colorLiteral(red: 0.8525683257, green: 0.8610095963, blue: 0.8610095963, alpha: 1)
        self.tv.layer.cornerRadius = 4
        self.tv.layer.masksToBounds = true
        
//        self.replyTable.layer.borderWidth = 1.0
//        self.replyTable.layer.borderColor = #colorLiteral(red: 0.8525683257, green: 0.8610095963, blue: 0.8610095963, alpha: 1)
//        self.replyTable.layer.cornerRadius = 4
//        self.replyTable.layer.masksToBounds = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
