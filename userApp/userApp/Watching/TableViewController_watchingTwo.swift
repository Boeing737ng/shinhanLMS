//
//  TableViewController_watchingTwo.swift
//  userApp
//
//  Created by 강희승 on 23/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class TableViewController_watchingTwo: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath) as! TableViewCell_watchingTwo
        return cell
    }
    
}
extension TableViewController_watchingTwo : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "수강완료")
    }
}
