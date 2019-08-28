//
//  MyPageViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//User Info
//- Name
//- Department
//- Selected Tags
//- User's group list
//- User's Playlist

import UIKit

class MyPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var img = ["fall.jpg", "fall.jpg", "fall.jpg", "fall.jpg", "fall.jpg"]
    var item = ["AWS", "Java", "Swift", "C", "C++"]
    var item2 = ["은행 서비스 1팀 스터디", "은행 서비스 2팀 스터디", "은행 서비스 3팀 스터디", "은행 서비스 4팀 스터디", "은행 서비스 5팀 스터디"]
    //@IBOutlet weak var taglbl: UILabel!
    
    @IBOutlet weak var fieldlbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var edLecture: UILabel!
    @IBOutlet weak var imgLecture: UILabel!
    @IBOutlet weak var questionlbl: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return item.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        //cell.bounds.size.width
        let title = UILabel(frame: CGRect(x: 13, y: 15, width: 100, height: 40))
        title.textColor = UIColor.white
        title.backgroundColor = UIColor.blue
        title.text = item[(indexPath as NSIndexPath).row]
        title.textAlignment = .center
        cell.contentView.addSubview(title)
        
        
        //title.layer.cornerRadius = 100
        //  let v = UIView()
        //  v.frame.size(
        
        
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        thirdTable.delegate = self
        //        thirdTable.dataSource = self
        //        thirdTable.register(UITableViewCell.self, forCellReuseIdentifier: "classCell")
        //
        //        fourthTable.delegate = self
        //        fourthTable.dataSource = self
        //        fourthTable.register(UITableViewCell.self, forCellReuseIdentifier: "studyCell")
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
