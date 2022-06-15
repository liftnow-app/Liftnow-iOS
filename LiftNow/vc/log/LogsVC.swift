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
        
//        array = CoreDataManager.shared.fetchRecord()
//        
//        tableView.register(UINib.init(nibName: "LogCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
//        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 300
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        //     self.navigationController?.isNavigationBarHidden = false
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
        
        cell.dateLbl.text = self.array[indexPath.row].date?.description
        let qaList = self.array[indexPath.row].range?.ranges ?? []
        let isExpand = self.array[indexPath.row].isExpand
        cell.stackView.arrangedSubviews.forEach { cell.stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
        if (isExpand) {
            qaList.forEach {n in
                setDynamicLabel(cell: cell, ques: n.question, ans: n.answer)
            }
            cell.btn.setImage(UIImage(named: "logUP"), for: .normal)
     //       cell.btn.setTitle("Hide answers", for: .normal)
            cell.viewMoreLbl.text = "Hide answers"
        } else {
            setDynamicLabel(cell: cell, ques: qaList.first?.question ?? "", ans: qaList.first?.answer ?? "")
            cell.btn.setImage(UIImage(named: "logDown"), for: .normal)
         //   cell.btn.setTitle( "View more answers", for: .normal)
            cell.viewMoreLbl.text = "View more answers"
        }
        cell.btn.tag = indexPath.row
        cell.viewMoreLbl.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(playAction))
        cell.viewMoreLbl.isUserInteractionEnabled = true
        cell.viewMoreLbl.addGestureRecognizer(tap)
            
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
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

