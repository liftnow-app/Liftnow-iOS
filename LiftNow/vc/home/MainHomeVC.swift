//
//  ViewController.swift
//  AmtexPOC
//
//  Created by Prithiviraj on 06/06/22.
//

import UIKit
import AVKit
import AVFoundation

import UIKit

class HomeModel {
    var title: String? = ""
    var image: String? = ""
    var videoName: String? = ""
    var enumType: TypeEnum? = TypeEnum.ocean
}

enum TypeEnum: NSInteger, Codable {
    case ocean = 1
    case rain = 2
}

class MainHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    var array = [HomeModel]()
    var selectedHome: HomeModel?
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "homeCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let h1 = HomeModel()
        h1.title = "A very calm sea under the gentle rays of the sun."
        h1.image = "Ocean"
        h1.enumType =  TypeEnum.ocean
        h1.videoName = "ocean_waves"
        
        let h2 = HomeModel()
        h2.title = "The rain brings a richness to each hue and the browns"
        h2.image = "Rain"
        h2.enumType =  TypeEnum.rain
        h2.videoName = "rain_waves"
        
        array.append(h1)
        array.append(h2)
        
        tableView.register(UINib.init(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let height = screenSize.height
        print(height)
        //800 - 5.9 inch & above
        let rowHeight = height > 800 ? 310 : 350
        tableView.rowHeight = CGFloat(rowHeight)
        tableView.estimatedRowHeight = CGFloat(rowHeight)
        tableView.delegate = self
        tableView.dataSource = self
        
        //      self.navigationController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0);
        
        //        var lineView = UIView(frame: CGRect(x: 0, y: 0, width:(tabBarController?.tabBar.frame.size.width)!, height: 1))
        //   lineView.backgroundColor = UIColor.grey
        //   tabBarController.tabBar.addSubview(lineView)
        
        //    self.navigationController?.tabBarController?.tabBar.addSubview(lineView)
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
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell :HomeCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! HomeCell
        cell.btn.isHidden = true
        cell.title.text = self.array[indexPath.row].title
        cell.imgLbl.text = self.array[indexPath.row].image
        //  cell.img.image = UIImage(named:self.array[indexPath.row].image ?? "")
        cell.cellBtn.tag = indexPath.row
        cell.cellBtn.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        self.playBackBG(videoView: cell.innerView, videoName: self.array[indexPath.row].videoName ?? "")
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @objc func playAction(sender: UIButton) {
        // let indexPath = sender as? IndexPath
        let index = sender.tag
        selectedHome = array[index]
        performSegue(withIdentifier: "OceanQaVC", sender: self)
        appDelegate.deviceOrientation = .landscapeLeft
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func playBackBG(videoView: UIView, videoName: String) {
        let filepath: String? = Bundle.main.path(forResource: videoName, ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        let item = AVPlayerItem(url: fileURL)
        
        
        //    item.seek(to: CMTime.zero)
        let player = AVPlayer(playerItem: item)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //  let player = AVPlayer(url: fileURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.contentsGravity = .resizeAspect
        //  playerLayer.videoGravity = .resizeAspect
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(playerLayer, at: 0)
        //  videoView.backgroundColor = UIColor.black
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        player.play()
    }
    
    @objc func itemDidFinishPlaying(sender: Notification) {
        let obj = sender.object as? AVPlayerItem
        obj?.seek(to: CMTime.zero)
        //        obj?.seek(to: CMTime.zero, completionHandler: { Bool in
        //            print("completionHandler")
        //        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OceanQaVC {
            let vc = segue.destination as? OceanQaVC
            //    vc?.modalPresentationStyle = .fullScreen
            vc?.homeModel = self.selectedHome
        }
    }
}

