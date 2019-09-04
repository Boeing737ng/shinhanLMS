//
//  PlayingLectureViewController.swift
//  userApp
//
//  Created by user on 04/09/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlayingLectureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension PlayingLectureViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수강중")
    }
}
