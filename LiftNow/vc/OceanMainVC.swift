//
//  ViewController.swift
//  AmtexPOC
//
//  Created by Prithiviraj on 28/05/22.
//

import UIKit
import AVKit
import AVFoundation

class OceanMainVC: UIViewController {
    
    var player: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    @IBOutlet var textLabel: UILabel!
    
    var countdown = 10
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DispatchQueue.main.async {
        //            self.textLabel.text = "";
        //        }
      //  navigationController?.navigationBar.barStyle = .black
    //    self.navigationController?.navigationBar.tintColor = UIColor.blue
   //      self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.backgroundColor = UIColor.blue
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "MarkerFelt-Thin", size: 20)!
        ]
        self.navigationController?.navigationBar.isTranslucent = true
        
       
        
        playBackBG()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdown=5
        //        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //     timer?.invalidate()
    }
    
    func playBackBG() {
        let filepath: String? = Bundle.main.path(forResource: "ocean_waves", ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        let player = AVPlayer(url: fileURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.contentsGravity = .resizeAspect
        //  playerLayer.videoGravity = .resizeAspect
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(playerLayer, at: 0)
        videoView.backgroundColor = UIColor.black
        player.play()
    }
    
    @objc func updateLabel() {
        countdown = countdown - 1
        self.textLabel.text = "\(getText())"
    }
    
    func getText() -> String {
        var value = "";
        switch (countdown) {
        case 4:
            value = "What is your problem?"
            break;
        case 3:
            value = "What is your strength?"
            break
        case 2:
            value = "What is your weakness?"
            break
        case 1:
            value = "What is your goal?"
            break
        case 0:
            value = "Thanks for your answer will reach you shortly"
            break
        default:
            value = "No Questions"
            break
        }
        return value
    }
    
    //    func updateLabel() {
    //        iteration = iteration == Int.max ? 0 : (iteration + 1)
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    //                self.textLabel.text = "\(self.iteration)"
    //                self.updateLabel()
    //            })
    //
    //        }
    
    
    //    private func playVideo() {
    //        guard let path = Bundle.main.path(forResource: "ocean_waves", ofType:"mp4") else {
    //            debugPrint("ocean_waves.mp4 not found")
    //            return
    //        }
    //        let player = AVPlayer(url: URL(fileURLWithPath: path))
    //        let playerController = AVPlayerViewController()
    //        playerController.player = player
    //        //   playerController.contentOverlayView?.backgroundColor = UIColor.white
    //        present(playerController, animated: true) {
    //            player.play()
    //        }
    //    }
    //
    //    func initVideo() {
    //        //        let avPlayer = AVPlayer(url: fileURL)
    //        //
    //        //        let avPlayerController = AVPlayerViewController()
    //        //        avPlayerController.player = avPlayer
    //        //        avPlayerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    //        //        avPlayerController.showsPlaybackControls = false
    //        //        avPlayerController.hidesBottomBarWhenPushed = true
    //        //        avPlayerController.showsTimecodes = false
    //        //        avPlayerController.requiresLinearPlayback = false
    //        //        avPlayerController.player?.play()
    //        //   self.view.addSubview(avPlayerController.view)
    //
    //        //            let playerLayer = AVPlayerLayer(player: avPlayer)
    //        //   self.view.layer.addSublayer(playerLayer)
    //    }
    //
    //    func initializeVideoPlayerWithVideo() {
    //
    //        // get the path string for the video from assets
    //        let videoString:String? = Bundle.main.path(forResource: "SampleVideo_360x240_1mb", ofType: "mp4")
    //        guard let unwrappedVideoPath = videoString else {return}
    //
    //        // convert the path string to a url
    //        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
    //
    //        // initialize the video player with the url
    //        self.player = AVPlayer(url: videoUrl)
    //
    //        // create a video layer for the player
    //        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
    //
    //        // make the layer the same size as the container view
    //        layer.frame = videoViewContainer.bounds
    //
    //        // make the video fill the layer as much as possible while keeping its aspect size
    //        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    //
    //        // add the layer to the container view
    //        videoViewContainer.layer.addSublayer(layer)
    //    }
}

