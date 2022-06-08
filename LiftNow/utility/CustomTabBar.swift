//
//  CustomTabBar.swift
//  LiftNow
//
//  Created by Prithiviraj on 07/06/22.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    let roundedView = UIView(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedView.layer.masksToBounds = true
   //     roundedView.layer.cornerRadius = 24
   //     roundedView.layer.borderWidth = 1.0
        roundedView.isUserInteractionEnabled = false
        roundedView.backgroundColor =  UIColor(named: "#DFE5E8")
        roundedView.layer.borderColor = UIColor.white.cgColor
        self.addSubview(roundedView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 0.0
        let position = CGPoint(x: margin, y: 0)
        let size = CGSize(width: self.frame.width - margin * 2, height: self.frame.height)
        roundedView.frame = CGRect(origin: position, size: size)
    }
    
    @IBInspectable var height: CGFloat = 70.0
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            
            if #available(iOS 11.0, *) {
                sizeThatFits.height = height + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
    }
    
    //    @IBInspectable var height: CGFloat = 0.0
    //
    //    override func sizeThatFits(_ size: CGSize) -> CGSize {
    //        var sizeThatFits = super.sizeThatFits(size)
    //        if height > 0.0 {
    //            sizeThatFits.height = height
    //        }
    //        return sizeThatFits
    //    }
}
