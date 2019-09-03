//
//  CoPCommentTableViewCell.swift
//  userApp
//
//  Created by user on 02/09/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class CoPCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWriter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
