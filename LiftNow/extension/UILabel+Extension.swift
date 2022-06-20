//
//  UILabel+Extension.swift
//  LiftNow
//
//  Created by Prithiviraj on 07/06/22.
//

import Foundation
import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    
                }
            }
        }
    }
    
    func animateLabel(newText: String, characterDelay: TimeInterval, onCompletion : @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    if (newText.count-1 == index) {
                        onCompletion(true)
                    }
                }
            }
        }
    }
}
