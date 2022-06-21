//
//  LogsVC.swift
//  LiftNow
//
//  Created by Prithiviraj on 15/06/22.
//

import UIKit
import AVKit
import AVFoundation

class LogsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var array = [QusAns]()
    var selectedQA: QusAns?
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "logCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "LogCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        array = CoreDataManager.shared.fetchRecord()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :LogCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! LogCell
        
        let lHeight = indexPath.row == 0 ? 55 : 0
        cell.lineViewTopConst.constant = CGFloat(lHeight)
        
//        if ((indexPath.row / 2) != 0) {
//            cell.circleView.backgroundColor = #colorLiteral(red: 0.5098039216, green: 0.6509803922, blue: 0.5411764706, alpha: 1)
//            cell.innerView.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.7803921569, blue: 0.7529411765, alpha: 1)
//        } else {
//            cell.circleView.backgroundColor = #colorLiteral(red: 0.431372549, green: 0.7450980392, blue: 0.7764705882, alpha: 1)
//            cell.innerView.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.8274509804, blue: 0.8470588235, alpha: 1)
//        }
//        if (indexPath.row == 0) {
//            cell.circleView.backgroundColor = #colorLiteral(red: 0.5098039216, green: 0.6509803922, blue: 0.5411764706, alpha: 1)
//            cell.innerView.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.7803921569, blue: 0.7529411765, alpha: 1)
//        }
        let dateStr = self.array[indexPath.row].date?.description ?? ""
        let dateTime = formattedDateFromString(dateString: dateStr, withFormat: "dd MMM yyyy h:mm a")
        cell.dateLbl.text = dateTime
        let qaList = self.array[indexPath.row].range?.ranges ?? []
        let isExpand = self.array[indexPath.row].isExpand
        cell.stackView.arrangedSubviews.forEach { cell.stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
        if (isExpand) {
            qaList.forEach {n in
                setDynamicLabel(cell: cell, ques: n.question, ans: n.answer)
            }
            cell.btn.setImage(UIImage(named: "logUP"), for: .normal)
            cell.viewMoreLbl.text = "Hide answers"
        } else {
            setDynamicLabel(cell: cell, ques: qaList.first?.question ?? "", ans: qaList.first?.answer ?? "")
            cell.btn.setImage(UIImage(named: "logDown"), for: .normal)
            cell.viewMoreLbl.text = "View more answers"
        }
        let viewType =  self.array[indexPath.row].viewType
        switch (viewType) {
        case 1:
            cell.imgLbl.text = "Ocean"
            break
        case 2:
            cell.imgLbl.text = "Rain"
            break
        default:
            cell.imgLbl.text = "Ocean"
        }
        
        cell.viewMoreBtn.tag = indexPath.row
        cell.btn.tag = indexPath.row
        cell.viewMoreBtn.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        cell.btn.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        //      cell.viewMoreLbl.tag = indexPath.row
//        let tap = UITapGestureRecognizer(target: self, action: #selector(playAction))
//        tap.view?.tag = indexPath.row;
//        cell.viewMoreLbl.isUserInteractionEnabled = true
//        cell.viewMoreLbl.addGestureRecognizer(tap)
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        //2022-06-17 08:00:40 +0000
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func setDynamicLabel(cell: LogCell, ques: String, ans: String) {
        let qlabel = UILabel()
        qlabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let alabel = UILabel()
        alabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        qlabel.numberOfLines = 2
        alabel.numberOfLines = 2
        qlabel.text = ques
        alabel.text = ans
        qlabel.textColor = #colorLiteral(red: 0, green: 0.1411764706, blue: 0.3333333333, alpha: 0.6759463028)
        alabel.textColor = #colorLiteral(red: 0, green: 0.1411764706, blue: 0.3333333333, alpha: 1)
        qlabel.font = UIFont(name:"NotoSans-Regular", size:14)
        alabel.font = UIFont(name:"NotoSans-Regular", size:16)
        
        cell.stackView.addArrangedSubview(qlabel)
        cell.stackView.addArrangedSubview(alabel)
        let emptyView = UIView()
        // emptyView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        cell.stackView.addArrangedSubview(emptyView)
    }
    
    @objc func playAction(sender: AnyObject) {
        let index = sender.tag
        selectedQA = array[index ?? 0]
        array[index ?? 0].isExpand = !(array[index ?? 0].isExpand)
        let indexPath = IndexPath(item: index ?? 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

