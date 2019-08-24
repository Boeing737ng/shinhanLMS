//
//  ViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 19/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

// For test Commit
import UIKit
import Firebase
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
class ViewController: UIViewController {
    
    @IBOutlet weak var ID_textbox: UITextField!
    @IBOutlet weak var PW_textbox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ID_textbox.layer.addBorder([.bottom], color: .lightGray, width: 1.0)
        PW_textbox.layer.addBorder([.bottom], color: .lightGray, width: 1.0)
        // Do any additional setup after loading the view.
    }
}
