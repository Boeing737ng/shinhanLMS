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

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    var img = ["fall.jpg", "fall.jpg", "fall.jpg", "fall.jpg", "fall.jpg"]
    var item = ["AWS", "AWS", "AWS", "AWS", "AWS"]
    var item2 = ["은행 서비스 1팀 스터디", "은행 서비스 2팀 스터디", "은행 서비스 3팀 스터디", "은행 서비스 4팀 스터디", "은행 서비스 5팀 스터디"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
        cell.textLabel?.text = item[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: img[(indexPath as NSIndexPath).row])

        
        return cell
    }

    @IBOutlet weak var secondCollection: UICollectionView!
    @IBOutlet weak var thirdTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
