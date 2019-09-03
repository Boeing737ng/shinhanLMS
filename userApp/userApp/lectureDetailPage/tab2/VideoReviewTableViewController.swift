import UIKit
import XLPagerTabStrip
import Firebase

class VideoReviewTableViewController: UITableViewController {

    var totalContentArray = Array<String>()
    var totalDateArray = Array<String>()
    var totalWriterArray = Array<String>()
    var contentArray = Array<String>()
    var dateArray = Array<String>()
    var writerArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getReviewFromDB()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadReview), name: NSNotification.Name(rawValue: "reviewAdd"), object: nil)
    }
    
    @objc func reloadReview() {
        getReviewFromDB()
        self.tableView.reloadData()
    }
    
    func initArray() {
        self.contentArray.removeAll()
        self.dateArray.removeAll()
        self.writerArray.removeAll()
        self.totalContentArray.removeAll()
        self.totalDateArray.removeAll()
        self.totalWriterArray.removeAll()
    }
    
    func getReviewFromDB() {
        initArray()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/videos/" + selectedVideoId + "/review/").queryOrdered(byChild: "date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount == 0 {
                return
            }
            
            let dataSize = Int(snapshot.childrenCount) - 1
            
            for review in snapshot.children.allObjects as! [DataSnapshot] {
                if let reviewInfo = review.value as? [String : Any] {
                    self.totalContentArray.append(reviewInfo["content"] as! String)
                    
                    let date: Double = reviewInfo["date"] as! Double
                    let myTimeInterval = TimeInterval(date)
                    let ts = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yy/MM/dd HH:mm"
                    let formattedDate = formatter.string(from: ts as Date)

                    self.totalDateArray.append(formattedDate)
                    self.totalWriterArray.append(reviewInfo["writer"] as! String)
                }
            }
            
            for i in 0...dataSize {
                self.contentArray.append(self.totalContentArray[dataSize - i])
                self.dateArray.append(self.totalDateArray[dataSize - i])
                self.writerArray.append(self.totalWriterArray[dataSize - i])
            }
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath) as! TableViewCellTwo
        
        cell.lblcontent.text = contentArray[indexPath.row]
        cell.lblDate.text = dateArray[indexPath.row]
        cell.lblWriter.text = writerArray[indexPath.row]
        
        return cell
    }
    
}

extension VideoReviewTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "수강후기")
    }
}
