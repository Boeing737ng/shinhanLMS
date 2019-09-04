//
//  graphViewController.swift
//  userApp
//
//  Created by user on 29/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

import UIKit
import Charts
import Firebase
import Foundation


var textArray = ["","",""]
var authorArray = ["","",""]
var dataReceived:Bool = false

var dbStudyArray = Array<String>()
var dbCatArray = Array<String>()
var dbTeaArray = Array<String>()
var dbGoalArray = Array<Int>()

class graphViewController: UIViewController, ChartViewDelegate {

    var months: [String]!

    let copnum: Int = 0
    var studyTime: Int = 0
    var goalTime: Int = 0
    var staTime: Int = 0
    
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var timeStacklbl: UILabel!
    @IBOutlet weak var copStacklbl: UILabel!
    
    @IBOutlet weak var cat1lbl: UILabel!
    @IBOutlet weak var cat2lbl: UILabel!
    @IBOutlet weak var cat3lbl: UILabel!
    @IBOutlet weak var staTimelbl: UILabel!
    
    @IBOutlet weak var teac1lbl: UILabel!
    @IBOutlet weak var teac2lbl: UILabel!
    @IBOutlet weak var teac3lbl: UILabel!
    @IBOutlet weak var goalTimelbl: UILabel!
    
    let unitSold = [60, 20, 15, 25, 15, 45, 18]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        months = ["월", "화", "수", "목", "금", "토", "일"]
        for i in 0...unitSold.count-1{
            studyTime = studyTime + unitSold[i]
        }
        staTime = studyTime/7
        
        timeStacklbl.text = "Shinple과 함께 \(studyTime)분을 학습했습니다"
        goalTimelbl.text = "\(goalTime)분"
        getNamePartDB()
        mostCgDB()
        mostTeaDB()
        goalTimeDB()
        
        // Do any additional setup after loading the view.
        setChart(dataPoints: months, values: unitSold)
        
    }
    
    func getNamePartDB(){
        clearArrays()
        var dataURL:String = userCompanyCode + "/study/11111/member/" + userNo
        //        var dataURL:String = ""
        //        dataURL = "user/" + userNo
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() || snapshot.childrenCount == 0 {
                self.copStacklbl.text = "0개의 CoP에서 활동중"
                print("Playlist is empty!!!!")
                return
            }
            let value = snapshot.value as? Dictionary<String, Any>;()
            let nameD = value as! Dictionary<String, Any>;()
            let name = nameD["name"] as! String
            
            dbStudyArray.append(name)
            self.copStacklbl.text = "\(dbStudyArray.count)개의 CoP에서 활동중"

            dataReceived = true
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func mostCgDB(){
        clearArrays()
        var dataURL:String = ""
        dataURL = "user/" + userNo + "/playList"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for video in value! {

                let catD = video.value as! Dictionary<String, Any>;()
                let catId = video.key as! String
                let cat = catD["categoryNm"] as! String
//                print(cat)
                dbCatArray.append(cat)
            }
//            print(dbCatArray)
            dataReceived = true
            let stringRepresentation = dbCatArray.joined(separator: " ")
      //      print(stringRepresentation)
            print(self.wordCount(s: stringRepresentation))
            let classK = Array(self.wordCount(s: stringRepresentation).values)
            let classV = Array(self.wordCount(s: stringRepresentation).keys)
            print(classK)
            print(classV)

            var rank = [Int](repeating: 1, count: classK.count)
            for i in 0 ... classK.count-1 {
                for j in 0 ... classK.count-1 {
                    if classK[i] < classK[j] {
                        rank[i] += 1
                    }
                }
            }
            
           print(rank)
            var total = 0
            for i in 0...classK.count-1{
                total = classK[i] + total
            }
            
            for i in 0...classK.count-1{
                if rank[i] == 1{
                    var per = (classK[i]*100)/total
                    print("1위: \(classV[i]) \(per)%")
                    self.cat1lbl.text = "1위: \(classV[i]) \(per)%"
                }else if rank[i] == 2{
                    var per = (classK[i]*100)/total
                    print("2위: \(classV[i]) \(per)%")
                    self.cat2lbl.text = "2위: \(classV[i]) \(per)%"
                }else if rank[i] == 3{
                    var per = (classK[i]*100)/total
                    print("3위: \(classV[i]) \(per)%")
                    self.cat3lbl.text = "3위: \(classV[i]) \(per)%"
                }
                
                
//                if rank[i] == 1 && rank[i+1] == 1 && rank[i+2] == 1{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("1위: \(classV[i+1]) \(per)%")
//                    print("1위: \(classV[i+2]) \(per)%")
//                    self.cat1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.cat2lbl.text = "1위: \(classV[i+1]) \(per)%"
//                    self.cat3lbl.text = "1위: \(classV[i+2]) \(per)%"
//                    return
//                }else if rank[i+1] == 1 && rank[i+2] != 1{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("1위: \(classV[i+1]) \(per)%")
//                    print("3위: \(classV[i+2]) \(per)%")
//                    self.cat1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.cat2lbl.text = "1위: \(classV[i+1]) \(per)%"
//                    self.cat3lbl.text = "3위: \(classV[i+2]) \(per)%"
//                    return
//                }else if rank[i+1] != 1 && rank[i+2] != 3{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("2위: \(classV[i+1]) \(per)%")
//                    print("2위: \(classV[i+2]) \(per)%")
//                    self.cat1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.cat2lbl.text = "2위: \(classV[i+1]) \(per)%"
//                    self.cat3lbl.text = "2위: \(classV[i+2]) \(per)%"
//                    return
//                }else{
//                    if rank[i] == 1{
//                        var per = (classK[i]*100)/total
//                        print("1위: \(classV[i]) \(per)%")
//                        self.cat1lbl.text = "1위: \(classV[i]) \(per)%"
//                    }else if rank[i] == 2{
//                        var per = (classK[i]*100)/total
//                        print("2위: \(classV[i]) \(per)%")
//                        self.cat2lbl.text = "2위: \(classV[i]) \(per)%"
//                    }else if rank[i] == 3{
//                        var per = (classK[i]*100)/total
//                        print("3위: \(classV[i]) \(per)%")
//                        self.cat3lbl.text = "3위: \(classV[i]) \(per)%"
//                    }                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func mostTeaDB(){
        clearArrays()
        var dataURL:String = ""
        dataURL = "user/" + userNo + "/playList"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for video in value! {
                let catD = video.value as! Dictionary<String, Any>;()
                let catId = video.key as! String
                let cat = catD["author"] as! String
//                print(cat)
                dbTeaArray.append(cat)
            }
//            print(dbTeaArray)
            dataReceived = true
            let stringRepresentation = dbTeaArray.joined(separator: " ")
      //      print(stringRepresentation)
      //      print(self.wordCount(s: stringRepresentation))
            
            print(self.wordCount(s: stringRepresentation))
            let classK = Array(self.wordCount(s: stringRepresentation).values)
            let classV = Array(self.wordCount(s: stringRepresentation).keys)
            print(classK)
            print(classV)
            
            var rank = [Int](repeating: 1, count: classK.count)
            for i in 0 ... classK.count-1 {
                for j in 0 ... classK.count-1 {
                    if classK[i] < classK[j] {
                        rank[i] += 1
                    }
                }
            }
            
            print(rank)
            var total = 0
            for i in 0...classK.count-1{
                total = classK[i] + total
            }
            
            for i in 0...classK.count-1{
                if rank[i] == 1{
                    var per = (classK[i]*100)/total
                    print("1위: \(classV[i]) \(per)%")
                    self.teac1lbl.text = "1위: \(classV[i]) \(per)%"
                }else if rank[i] == 2{
                    var per = (classK[i]*100)/total
                    print("2위: \(classV[i]) \(per)%")
                    self.teac2lbl.text = "2위: \(classV[i]) \(per)%"
                }else if rank[i] == 3{
                    var per = (classK[i]*100)/total
                    print("3위: \(classV[i]) \(per)%")
                    self.teac3lbl.text = "3위: \(classV[i]) \(per)%"
                }
//                if rank[i] == 1 && rank[i+1] == 1 && rank[i+2] == 1{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("1위: \(classV[i+1]) \(per)%")
//                    print("1위: \(classV[i+2]) \(per)%")
//                    self.teac1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.teac2lbl.text = "1위: \(classV[i+1]) \(per)%"
//                    self.teac3lbl.text = "1위: \(classV[i+2]) \(per)%"
//                    return
//                }else if rank[i+1] == 1 && rank[i+2] != 1{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("1위: \(classV[i+1]) \(per)%")
//                    print("3위: \(classV[i+2]) \(per)%")
//                    self.teac1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.teac2lbl.text = "1위: \(classV[i+1]) \(per)%"
//                    self.teac3lbl.text = "3위: \(classV[i+2]) \(per)%"
//                    return
//                }else if rank[i+1] != 1 && rank[i+2] != 3{
//                    var per = (classK[i]*100)/total
//                    print("1위: \(classV[i]) \(per)%")
//                    print("2위: \(classV[i+1]) \(per)%")
//                    print("2위: \(classV[i+2]) \(per)%")
//                    self.teac1lbl.text = "1위: \(classV[i]) \(per)%"
//                    self.teac2lbl.text = "2위: \(classV[i+1]) \(per)%"
//                    self.teac3lbl.text = "2위: \(classV[i+2]) \(per)%"
//                    return
//                }else{
//                    if rank[i] == 1{
//                        var per = (classK[i]*100)/total
//                        print("1위: \(classV[i]) \(per)%")
//                        self.teac1lbl.text = "1위: \(classV[i]) \(per)%"
//                    }else if rank[i] == 2{
//                        var per = (classK[i]*100)/total
//                        print("2위: \(classV[i]) \(per)%")
//                        self.teac2lbl.text = "2위: \(classV[i]) \(per)%"
//                    }else if rank[i] == 3{
//                        var per = (classK[i]*100)/total
//                        print("3위: \(classV[i]) \(per)%")
//                        self.teac3lbl.text = "3위: \(classV[i]) \(per)%"
//                    }                }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
 
    func wordCount(s: String) -> Dictionary<String, Int>{
        var words = s.components(separatedBy: .whitespaces)
        var WordD = Dictionary<String, Int>()
        for word in words{
            if let count = WordD[word]{
                WordD[word] = count + 1
            }else{
                WordD[word] = 1
            }
        }
        return WordD
    }

    func goalTimeDB(){
        clearArrays()
        var dataURL:String = "user/" + userNo
        //        var dataURL:String = ""
        //        dataURL = "user/" + userNo
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(dataURL).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, Any>;()
            let goalD = value as! Dictionary<String, Any>;()
            let goal = goalD["goalTime"] as! Int
            print(goal)
            dbGoalArray.append(goal)
            dataReceived = true
            
            self.goalTimelbl.text = "\(goal)분"
            
            if(goal<self.staTime){
                self.staTimelbl.text = "목표 달성"
                self.staTimelbl.textColor = UIColor.blue
                print(goal)
                print(self.staTime)
            }else{
                self.staTimelbl.text = "목표 미달성"
                self.staTimelbl.textColor = UIColor.red
            }
            
            let ll = ChartLimitLine(limit: Double(goal)
                , label: "목표")
            self.chartView.rightAxis.removeAllLimitLines()
           self.chartView.rightAxis.addLimitLine(ll)
            self.chartView.delegate = self
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func clearArrays() {
        dbStudyArray.removeAll()
        dbCatArray.removeAll()
        dbTeaArray.removeAll()
    }
    
    @IBAction func onGoBack(_ sender: UIBarButtonItem) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func setGoal(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var dataURL:String = "user/" + userNo + "/goalTime"
        
        let timeA = UIAlertController(title: "목표 시간을 선택해 주세요", message: " ", preferredStyle: UIAlertController.Style.alert)
        
        let A10 = UIAlertAction(title: "10분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 10
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:10]
            ref.updateChildValues(updates)
        })
        let A20 = UIAlertAction(title: "20분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 20
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:20]
            ref.updateChildValues(updates)
        })
        let A30 = UIAlertAction(title: "30분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 30
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:30]
            ref.updateChildValues(updates)
        })
        let A40 = UIAlertAction(title: "40분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 40
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:40]
            ref.updateChildValues(updates)
        })
        let A50 = UIAlertAction(title: "50분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 50
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:50]
            ref.updateChildValues(updates)
        })
        let A60 = UIAlertAction(title: "60분", style: UIAlertAction.Style.default, handler: {ACTION in self.goalTime = 60
            self.setChart(dataPoints: self.months, values: self.unitSold)
            self.goalTimelbl.text = "\(self.goalTime)분"
            let updates = [dataURL:60]
            ref.updateChildValues(updates)
        })
        timeA.addAction(A10)
        timeA.addAction(A20)
        timeA.addAction(A30)
        timeA.addAction(A40)
        timeA.addAction(A50)
        timeA.addAction(A60)
        present(timeA, animated: true, completion: nil)
        goalTimelbl.text = "\(goalTime)분"
    }
    
    func setChart(dataPoints: [String], values: [Int]){
        //        barChartView.noDataText = "you need to provide datafor the chart"
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0 ..< dataPoints.count{
            let dataEntry = BarChartDataEntry(x: Double(Int(i)), y: Double(values[i]))
            dataEntries.append(dataEntry)
            
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "학습량")
            let chartData = BarChartData(dataSet: chartDataSet)
            //            chartDataSet.colors = ChartColorTemplates.material()
            chartDataSet.colors = [UIColor(red: 0/255, green: 170/255, blue: 255/255, alpha: 1)]
            chartView.data = chartData
            
            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
            //            barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            chartView.animate(xAxisDuration: 2, yAxisDuration: 2)
            
            let ll = ChartLimitLine(limit: Double(goalTime), label: "목표")
            chartView.rightAxis.removeAllLimitLines()
            chartView.rightAxis.addLimitLine(ll)
            chartView.delegate = self
        }
        
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
