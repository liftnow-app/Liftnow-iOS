//
//  OceanMainVC.swift
//  AmtexPOC
//
//  Created by Prithiviraj on 28/05/22.
//

import UIKit
import AVKit
import AVFoundation

class OceanQaVC_OldBackup: UIViewController, UITextFieldDelegate, PopupViewControllerDelegate, OkayActionDelegate {
    func okayAction() {
        self.navigationController?.popViewController(animated: true);
    }
    
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController) {
        self.navigationController?.popViewController(animated: true);
    }
    
    var homeModel: HomeModel?
    
    var player: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var qaView: UIView!
    @IBOutlet var custNavBar: NavigationBar!
    @IBOutlet var answerBtn: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var ansLbl: UILabel!
    @IBOutlet var qaTitle: UILabel!
    @IBOutlet var qaDesc: UILabel!
    let customAlertVC = CustomAlertVC.instantiate()
    
    //    var qaTitleArray = [String]()
    //   var qaDescArray = [String]()
    
    var qaTitleArray: [String] = ["Question 1 out of 5", "Question 2 out of 5", "Question 3 out of 5", "Question 4 out of 5", "Question 5 out of 5"];
    
    var qaDescArray: [String] = ["How are you feeling today?", "Is Something making you scared?", "What is your strength?", "What is your weakness?", "What is your favorite food?"];
    
    var completedCount: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        bgView.isHidden = true;
        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "ansBG.png")!)
        custNavBar.leftButton.addTarget(self, action: #selector(onBackAction), for: .touchUpInside)
        custNavBar.rightSecondButton.addTarget(self, action: #selector(onSkipAction), for: .touchUpInside)
        
        self.custNavBar.pageCtrl.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .valueChanged)
        
        playBackBG()
        completedCount = 0;
        setPageQuestions(count: 0)
    }
    
    @objc func onBackAction() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func onSkipAction() {
        if (completedCount < 4) {
            completedCount = completedCount+1;
            self.setPageQuestions(count: self.completedCount)
        }
    }
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        //move page to wanted page
        let page: Int? = sender.currentPage
        print(page ?? 0)
        self.setPageQuestions(count: (page ?? 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        completedCount = completedCount+1;
        let str = textField.text;
        ansLbl.text = str;
        self.bgView.isHidden = true;
        self.answerBtn.isHidden = true;
        self.videoView.isHidden = false;
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2second
            self.setPageQuestions(count: self.completedCount)
        }
        return true
    }
    
    @IBAction func answerNwAction(_ sender: Any) {
        self.textField.becomeFirstResponder()
        self.bgView.isHidden = false;
        self.answerBtn.isHidden = true;
    }
    
    func setPageQuestions(count: Int) {
        completedCount = count;
        answerBtn.isHidden = true;
        self.ansLbl.text = ""
        
        let isIndexValid = qaTitleArray.indices.contains(count)
        
        if (isIndexValid) {
            qaTitle.text = qaTitleArray[count]
            qaDesc.text = qaDescArray[count]
        }
        self.custNavBar.pageCtrl.currentPage = count
        if (self.completedCount == qaTitleArray.count) {
            qaView.isHidden = true
            showSuccessScreen()
        } else {
            showAnsNowBtn()
        }
    }
    
    func showSuccessScreen() {
        guard let customAlertVC = customAlertVC else { return }
        customAlertVC.titleString = "Well done"
        customAlertVC.messageString = "Thanks for your answers"
        customAlertVC.delegate = self
        let popupVC = PopupViewController(contentController: customAlertVC, popupWidth: 366, popupHeight: 400)
        popupVC.delegate = self
        present(popupVC, animated: true, completion: {
            //   self.navigationController?.popViewController(animated: true);
        })
    }
    
    func showAnsNowBtn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 5second
            self.answerBtn.isHidden = false;
            self.ansLbl.text = "";
        }
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
}

