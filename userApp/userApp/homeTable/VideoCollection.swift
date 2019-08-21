//
//  VideoCollection.swift
//  userApp
//
//  Created by Kihyun Choi on 21/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit

class VideoCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let textArray = ["ios","android","AWS","Network","Web"]
    let authorArray = ["최강사","김강사","박강사","오강사","유강사"]
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
        cell.textLabel.text = textArray[indexPath.row]
        cell.authorLabel.text = authorArray[indexPath.row]
        
        
        return cell
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
