import UIKit
import XLPagerTabStrip
import Firebase

class VideoQnATableViewController: UITableViewController {
    
    var keyArray = Array<String>()
    var titleArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    var contentArray = Array<String>()
    //    var items = ["질문이 있는데요.", "이게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요?", "어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getQuestionFromDB()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getQuestionFromDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/qnaBoard").observeSingleEvent(of: .value, with: { (snapshot) in
            let questionInfo = snapshot.value as? Dictionary<String,Any>;()
            
            for question in questionInfo! {
                let questionDict = question.value as! Dictionary<String, Any>;()
                
                let questionId = question.key
                let title = questionDict["title"] as! String
                let content = questionDict["content"] as! String
                let date = String(questionDict["date"] as! Int)
                let writer = questionDict["writer"] as! String
                
                print(title)
                print(content)
                print(date)
                print(writer)
                print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ\n")
                
                self.keyArray.append(questionId)
                self.titleArray.append(title)
                self.contentArray.append(content)
                self.dateArray.append(date)
                self.writerArray.append(writer)
            }
            //self.dataReceived = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return keyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellThree", for: indexPath) as! TableViewCellThree
        
        cell.lblTitle.text = titleArray[(indexPath as NSIndexPath).row]
        cell.lblWriter.text = writerArray[(indexPath as NSIndexPath).row]
        cell.lblDate.text = dateArray[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
}
extension VideoQnATableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "질문답변")
    }
}
