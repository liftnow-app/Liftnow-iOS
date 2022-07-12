//
//  BaseVC.swift
//  LiftNow
//
//  Created by Prithiviraj on 12/07/22.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      self.navigationController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0);
        
        //        var lineView = UIView(frame: CGRect(x: 0, y: 0, width:(tabBarController?.tabBar.frame.size.width)!, height: 1))
        //   lineView.backgroundColor = UIColor.grey
        //   tabBarController.tabBar.addSubview(lineView)
        
        //    self.navigationController?.tabBarController?.tabBar.addSubview(lineView)
        
        tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.9758436084, green: 0.591373086, blue: 0.1539243162, alpha: 1)
        tabBarController?.tabBar.unselectedItemTintColor = #colorLiteral(red: 0, green: 0.3607843137, blue: 0.6156862745, alpha: 1)
    }
}
