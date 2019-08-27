//
//  VideoListViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//Video Info
//- thumbnail image
//- name
//- download Url

import UIKit
import XLPagerTabStrip
import KBRoundedButton
import DropDown

class VideoListViewController: UIViewController {
    var dropdown:DropDown?
    
    @IBOutlet weak var btn1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdown = DropDown()
        dropdown?.anchorView = btn1
        dropdown?.bottomOffset = CGPoint(x:0, y:(dropdown?.anchorView?.plainView.bounds.height)!)
        dropdown?.dataSource=["language","Server","Database","기현's Pick",]
        // Do any additional setup after loading the view.
        btn1.addTarget(self, action: #selector(dropdownButton), for: .touchUpInside)
        dropdown?.selectionAction = {[unowned self] (index: Int, item: String) in
            self.btn1.setTitle(item, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    @objc func dropdownButton(){
        dropdown?.show()
    }
}

extension VideoListViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "강좌리스트")
    }
}
