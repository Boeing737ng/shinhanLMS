//
//  HomeTable.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeTable: UITableViewController  {
    
    func viewDidload() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func reloadTable() {
        print("reload")
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell:UITableViewCell
        if row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        } else if row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell1") as! CategoryCell1
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell2") as! CategoryCell2
        }
        return cell
    }
    
    @IBAction func goToRecommendedVideoList(_ sender: UIButton) {
        performSegue(withIdentifier: "recommendListSegue", sender: self)
    }
    
    @IBAction func goToPlayingVideoList(_ sender: UIButton) {
        performSegue(withIdentifier: "playingListSegue", sender: self)
    }
    
    @IBAction func goToPopularVideoList(_ sender: UIButton) {
        performSegue(withIdentifier: "popularListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recommendListSegue" {
            segueId = "recommendListSegue"
        } else if segue.identifier == "playingListSegue" {
            segueId = "playingListSegue"
        } else {
            segueId = "popularListSegue"
        }
    }
    
}
extension HomeTable : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "Home")
    }
}
