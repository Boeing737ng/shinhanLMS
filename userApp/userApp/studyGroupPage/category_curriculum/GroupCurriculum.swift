
import UIKit
import Firebase
class GroupCurriculum: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var textArray = ["","","","",""]
    var authorArray = ["","","","",""]
    var dataReceived:Bool = false
    
    var curriculumVideoIdArray = Array<String>()
    var curriculumTitleArray = Array<String>()
    var curriculumAuthorArray = Array<String>()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        initcurriculum()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadcollection), name: NSNotification.Name(rawValue: "copchange"), object: nil)
    }
    @objc func reloadcollection() {
        getData()
        self.reloadData()
    }
    func initcurriculum()
    {
        initArrays()
        var index = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/11111/curriculum").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(curri)
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key
                print(videoId)
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.curriculumVideoIdArray.append(videoId)
                self.curriculumTitleArray.append(title)
                self.curriculumAuthorArray.append(author)
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
        ref.child("58/study/"+curri_send+"/curriculum").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? Dictionary<String,Any>;()
            for video in value! {
                let videoDict = video.value as! Dictionary<String, Any>;()
                let videoId = video.key
                print(videoId)
                let title = videoDict["title"] as! String
                let author = videoDict["author"] as! String
                self.curriculumVideoIdArray.append(videoId)
                self.curriculumTitleArray.append(title)
                self.curriculumAuthorArray.append(author)
                index += 1
            }
            self.dataReceived = true
            self.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func initArrays() {
        curriculumVideoIdArray.removeAll()
        curriculumAuthorArray.removeAll()
        curriculumTitleArray.removeAll()
        self.dataReceived = false
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoId = curriculumVideoIdArray[indexPath.row]
        selectedVideoId = videoId
        TabViewController().goToDetailPage()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurriculumCell", for: indexPath) as! CurriculumCell

        cell.video_title.text = textArray[indexPath.row]
        cell.video_author.text = authorArray[indexPath.row]
        
        if dataReceived {
            cell.video_title.text = curriculumTitleArray[indexPath.row]
            cell.video_author.text = curriculumAuthorArray[indexPath.row]
            print(curriculumVideoIdArray)
            cell.video_img.image = CachedImageView().loadCacheImage(urlKey: curriculumVideoIdArray[indexPath.row])
            //UIImage(named: "white.jpg")
                //CachedImageView().loadCacheImage(urlKey: curriculumVideoIdArray[indexPath.row])
        } else {
            cell.video_title.text = textArray[indexPath.row]
            cell.video_author.text = authorArray[indexPath.row]
            cell.video_img.image = UIImage(named: "white.jpg")
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
