//
//  LogCell.swift
//  LiftNow
//
//  Created by Prithiviraj on 15/06/22.
//

import UIKit
class LogCell: UITableViewCell {
    
    @IBOutlet var innerView: UIView!
    @IBOutlet var circleView: UIView!
    @IBOutlet var lineViewTopConst: NSLayoutConstraint!
    @IBOutlet var lineView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var btn: UIButton!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var viewMoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//    let titleLabel = UILabel()
//        let stackView = UIStackView()
//        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
//            commonInit()
//        }
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            commonInit()
//        }
//        func commonInit() {
//            titleLabel.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(titleLabel)
//
//            stackView.axis = .vertical
//            stackView.distribution = .fillEqually
//            stackView.alignment = .fill
//            stackView.spacing = 0
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(stackView)
//
//            titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        }
//        func setup(names: [QansModel]) {
//            stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
//            names.forEach {n in
//                let qlabel = UILabel()
//                let label = UILabel()
//                qlabel.text = n.question
//                label.text = n.answer
//                stackView.addArrangedSubview(qlabel)
//                stackView.addArrangedSubview(label)
//            }
//        }
}
