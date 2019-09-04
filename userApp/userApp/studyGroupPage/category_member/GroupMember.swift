
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMember), name: NSNotification.Name(rawValue: "copchange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMember), name: NSNotification.Name(rawValue: "memberAdd"), object: nil)
    }
    
    @objc func reloadMember() {
        if(curri_send == "0"){
            initArrays()
            self.reloadData()
        }
        else {
            getData()
            self.reloadData()
        }
        
    }
    func getData()
    {
        initArrays()
        //var index = 0
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("58/study/" + curri_send + "/member").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount == 0 {
                return
            }
            let value = snapshot.value as? Dictionary<String,Any>;()
            for study in value! {
                let studyDict = study.value as! Dictionary<String, Any>;()
                let name = studyDict["name"] as! String
                let depart = studyDict["department"] as! String
                self.member_name.append(name)
                self.member_depart.append(depart)
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
        return member_name.count
    }
    func initArrays() {
        member_depart.removeAll()
        member_name.removeAll()
        self.dataReceived = false
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        cell.depart_txt.text = ""
        cell.member_txt.text = ""
        
        if dataReceived {
            cell.depart_txt.text = member_depart[indexPath.row]
            cell.member_txt.text = member_name[indexPath.row]
        } else {
            cell.depart_txt.text = textArray[indexPath.row]
            cell.member_txt.text = authorArray[indexPath.row]
        }
        
        return cell
    }
}
