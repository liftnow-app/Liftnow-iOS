//
//  OceanMainVC.swift
//  AmtexPOC
//
//  Created by Prithiviraj on 28/05/22.
//

import UIKit
import AVKit
import AVFoundation

class OceanQaVC: UIViewController, UITextFieldDelegate, PopupViewControllerDelegate, OkayActionDelegate {
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
    @IBOutlet var answerBtn: UIButton!
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var ansLbl: UILabel!
    @IBOutlet var qaDesc: UILabel!
    
    let customAlertVC = CustomAlertVC.instantiate()
    
    //    var qaTitleArray = [String]()
    //   var qaDescArray = [String]()
    
    var qaList = [QansModel]()
    
    var qaDescArray: [String] = ["How are you feeling today?", "Is Something making you scared?", "What do you like to do after coming from school? ", "What is your weakness?", "What is your favorite food?"];
    
    var completedCount: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        bgView.isHidden = true;
        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "ansBG.png")!)
        
        playBackBG()
        completedCount = 0;
        setPageQuestions(count: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ansLbl.text = "\(textField.text ?? "")\(string)"
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let str = textField.text;
        textField.text = ""
        ansLbl.text = str;
        
        let qa = QansModel()
        qa.question = qaDescArray[completedCount];
        qa.answer = str ?? "";
        qaList.append(qa)
        
        answerCompletion()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2second
            self.setPageQuestions(count: self.completedCount)
        }
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func skipAction(_ sender: Any) {
        if (completedCount < 4) {
            completedCount = completedCount+1;
            answerCompletion()
            self.setPageQuestions(count: self.completedCount)
        } else {
            completedCount = completedCount+1;
            answerCompletion()
            showSuccess()
        }
    }
    
    @IBAction func answerNwAction(_ sender: Any) {
        self.textField.becomeFirstResponder()
        self.bgView.isHidden = false;
        self.answerBtn.isHidden = true;
        self.skipBtn.isHidden = true;
    }
    
    func answerCompletion() {
        self.bgView.isHidden = true;
        self.answerBtn.isHidden = true;
        self.skipBtn.isHidden = true;
        self.videoView.isHidden = false;
    }
    
    func setPageQuestions(count: Int) {
        completedCount = count;
        answerBtn.isHidden = true;
        self.skipBtn.isHidden = true;
        self.ansLbl.text = ""
        
        let isIndexValid = qaDescArray.indices.contains(count)
        if (isIndexValid) {
            qaDesc.animateLabel(newText:  qaDescArray[count], characterDelay: 0.1) { Bool in
                self.showAnsNowBtn()
            }
        }
        showSuccess()
    }
    
    func showSuccess() {
        if (self.completedCount == qaDescArray.count) {
            qaView.isHidden = true
            if (qaList.count > 0) {
                CoreDataManager.shared.createRecord(qaList: qaList)
            }
            showSuccessScreen()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1second
            self.answerBtn.isHidden = false;
            self.skipBtn.isHidden = false;
            self.ansLbl.text = "";
        }
    }
    
    func playBackBG() {
        let filepath: String? = Bundle.main.path(forResource:homeModel?.videoName, ofType: "mp4")
        let fileURL = URL.init(fileURLWithPath: filepath!)
        let item = AVPlayerItem(url: fileURL)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        player = AVPlayer(playerItem: item)
        //   let player = AVPlayer(url: fileURL)
        player?.isMuted = true
        player?.volume = 0.0
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.contentsGravity = .resizeAspect
        //  playerLayer.videoGravity = .resizeAspect
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(playerLayer, at: 0)
        //      videoView.backgroundColor = UIColor.black
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    @objc func itemDidFinishPlaying(sender: Notification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
}

