import UIKit
import XLPagerTabStrip
class VideoQnATableViewController: UITableViewController {
    
    var items = ["질문이 있는데요.", "이게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요? 이 게 뭘까요?", "어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요? 어떻게 해결할 수 있나요?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellThree", for: indexPath) as! TableViewCellThree
        
        cell.lblTitle.text = items[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
}
extension VideoQnATableViewController : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "질문답변")
    }
}
