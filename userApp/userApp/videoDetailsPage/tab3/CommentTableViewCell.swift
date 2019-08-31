//
//  CommentTableViewCell.swift
//  Charts
//
//  Created by user on 31/08/2019.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblWriter: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
