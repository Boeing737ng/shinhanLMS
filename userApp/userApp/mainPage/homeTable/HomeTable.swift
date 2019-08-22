//
//  HomeTable.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class HomeTable: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        var cell:UITableViewCell = UITableViewCell.init()
        if row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        } else if row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell1") as! CategoryCell1
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell2") as! CategoryCell2
        }
        return cell
    }
    
}
