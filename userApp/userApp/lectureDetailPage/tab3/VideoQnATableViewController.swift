import UIKit
import XLPagerTabStrip
import Firebase

var selectedQuestionId: String = ""

class VideoQnATableViewController: UITableViewController {
    
    var keyArray = Array<String>()
    var titleArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    var contentArray = Array<String>()
    var totalKeyArray = Array<String>()
    var totalTitleArray = Array<String>()
    var totalDateArray = Array<String>()
    var totalWriterArray = Array<String>()
    var totalContentArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getQuestionFromDB()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadQuestion), name: NSNotification.Name(rawValue: "questionAdd"), object: nil)
    }
    
    @objc func reloadQuestion() {
        getQuestionFromDB()
        self.tableView.reloadData()
    }
    
    func initArray() {
        self.keyArray.removeAll()
        self.titleArray.removeAll()
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        self.totalKeyArray.removeAll()
        self.totalTitleArray.removeAll()
        self.totalContentArray.removeAll()
        self.totalDateArray.removeAll()
        self.totalWriterArray.removeAll()
    }
    
    func getQuestionFromDB() {
        initArray()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId + "/qnaBoard/").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let dataSize = Int(snapshot.childrenCount) - 1
            
            for question in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let questionInfo = question.value as? [String : Any] {
                    self.totalKeyArray.append(question.key)
                    self.totalTitleArray.append(questionInfo["title"] as! String)
                    self.totalContentArray.append(questionInfo["content"] as! String)
                    self.totalWriterArray.append(questionInfo["writer"] as! String)
                    
                    let date: Double = questionInfo["date"] as! Double
                    let myTimeInterval = TimeInterval(date)
                    let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy/MM/dd HH:mm"
                    let formattedDate = formatter.string(from: ts as Date)
                    
                    self.totalDateArray.append(formattedDate)
                }
            }
            
            for i in 0...dataSize {
                self.keyArray.append(self.totalKeyArray[dataSize - i])
                self.titleArray.append(self.totalTitleArray[dataSize - i])
                self.contentArray.append(self.totalContentArray[dataSize - i])
                self.dateArray.append(self.totalDateArray[dataSize - i])
                self.writerArray.append(self.totalWriterArray[dataSize - i])
            }
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return keyArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionId = keyArray[indexPath.row]
        selectedQuestionId = questionId
        goToPostShowPage()
    }
    
    func goToPostShowPage() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "questionShowStoryboard")
        UIApplication.topViewController()!.present(viewController, animated: true, completion: nil)
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
