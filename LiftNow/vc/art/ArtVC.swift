//
//  ArtVC.swift
//  LiftNow
//
//  Created by Prithiviraj on 12/07/22.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

class ArtVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var centerFlowLayout: SJCenterFlowLayout {
        return collectionView.collectionViewLayout as! SJCenterFlowLayout
    }
    var scrollToEdgeEnabled: Bool = true
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "categoryColCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(UINib(nibName: "CategoryColCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Configure the required item size (REQURED)
        centerFlowLayout.itemSize = CGSize(
            width: view.bounds.width * 1.0,
            height:  view.bounds.height * 0.3
        )
        
        centerFlowLayout.animationMode = SJCenterFlowLayoutAnimation.scale(sideItemScale: 0.6, sideItemAlpha: 0.6, sideItemShift: 0.0)
    }
}

// MARK: - Actions
extension ArtVC {
    @IBAction func swtChangeAction(_ sender: UISwitch){
        switch sender.tag {
        case 1:
            if sender.isOn {
                centerFlowLayout.animationMode =  SJCenterFlowLayoutAnimation.rotation(sideItemAngle: 45, sideItemAlpha: 1, sideItemShift: 0)
            }else{
                centerFlowLayout.animationMode = SJCenterFlowLayoutAnimation.scale(sideItemScale: 0.6, sideItemAlpha: 0.6, sideItemShift: 0.0)
            }
            collectionView.reloadData()
            break
        case 2:
            self.scrollToEdgeEnabled =  sender.isOn
            break
        default:
            centerFlowLayout.scrollDirection = sender.isOn ? .horizontal : .vertical
            break
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ArtVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let height = view.frame.size.height
        //        let width = view.frame.size.width
        //        // in case you you want the cell to be 40% of your controllers view
        //  return CGSize(width: 700.0, height: 700.0)
        let size = UIScreen.main.bounds
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CategoryColCell
        //       cell.imgv.image = UIImage(named: "\(indexPath.row + 1)")
        cell.img.image = UIImage(named: "image-"+"\(indexPath.row + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.scrollToEdgeEnabled, let cIndexPath = centerFlowLayout.currentCenteredIndexPath,
           cIndexPath != indexPath {
            centerFlowLayout.scrollToPage(atIndex: indexPath.row)
        }
    }
}
