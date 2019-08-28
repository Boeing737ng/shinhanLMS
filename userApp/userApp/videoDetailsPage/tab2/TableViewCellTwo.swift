//
//  TableViewCellTwo.swift
//  eeeeee
//
//  Created by 강희승 on 22/08/2019.
//  Copyright © 2019 강희승. All rights reserved.
//

import UIKit

class TableViewCellTwo: UITableViewCell {

    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblcontent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
