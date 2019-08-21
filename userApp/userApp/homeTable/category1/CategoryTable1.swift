//
//  CategoryTable1.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class CategoryTable1: UITableView, UITableViewDelegate, UITableViewDataSource  {
    
    let textArray = ["ios","android","AWS"]
    let authorArray = ["최강사","김강사","박강사"]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell1") as! VideoCell1
        
        cell.videoTitleLabel.text = textArray[indexPath.row]
        cell.videoAuthorLabel.text = authorArray[indexPath.row]
        
        return cell
    }
}
