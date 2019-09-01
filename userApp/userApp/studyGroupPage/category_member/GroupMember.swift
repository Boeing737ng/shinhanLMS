
import UIKit
import Firebase
class GroupMember: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var textArray = ["","","","",""]
    var authorArray = ["","","","",""]
    var dataReceived:Bool = false
    var member_depart = Array<String>()
    var member_name = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        initmember()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadcollection), name: NSNotification.Name(rawValue: "copchange"), object: nil)
    }
    @objc func reloadcollection() {
        getData()
        self.reloadData()
    }
    func initmember()
    {
        initArrays()
        var index = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/11111/member").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>;()
            for study in value! {
                let studyDict = study.value as! Dictionary<String, Any>;()
                let name = studyDict["name"] as! String
                let depart = studyDict["department"] as! String
                self.member_name.append(name)
                self.member_depart.append(depart)
                index += 1
            }
            self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func getData()
    {
        initArrays()
        var index = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/"+curri_send+"/member").observeSingleEvent(of: .value, with: { (snapshot) in
        let value = snapshot.value as? Dictionary<String,Any>;()
            for study in value! {
                let studyDict = study.value as! Dictionary<String, Any>;()
                let name = studyDict["name"] as! String
                let depart = studyDict["department"] as! String
                self.member_name.append(name)
                self.member_depart.append(depart)
                index += 1
            }
            self.dataReceived = true
            self.reloadData()
    }) { (error) in
        print(error.localizedDescription)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let videoId = recentVideoIdArray[indexPath.row]
//        selectedVideoId = videoId
//        TabViewController().goToDetailPage()
//    }
    func initArrays() {
        member_depart.removeAll()
        member_name.removeAll()
        self.dataReceived = false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        cell.depart_txt.text = textArray[indexPath.row]
        cell.member_txt.text = authorArray[indexPath.row]
        
        if dataReceived {
            cell.depart_txt.text = member_depart[indexPath.row]
            cell.member_txt.text = member_name[indexPath.row]
            //cell.video_img.image = CachedImageView().loadCacheImage(urlKey: recentVideoIdArray[indexPath.row])
        } else {
            cell.depart_txt.text = textArray[indexPath.row]
            cell.member_txt.text = authorArray[indexPath.row]
            //cell.video_img.image = UIImage(named: "white.jpg")
        }
        
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
