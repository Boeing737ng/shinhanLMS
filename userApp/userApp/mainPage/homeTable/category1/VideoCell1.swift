//
//  VideoCell1.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class VideoCell1: UITableViewCell {
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoAuthorLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
