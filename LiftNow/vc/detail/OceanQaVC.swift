//
//  OceanMainVC.swift
//  AmtexPOC
//
//  Created by Prithiviraj on 28/05/22.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImageWebPCoder

class OceanQaVC: UIViewController, UITextFieldDelegate, PopupViewControllerDelegate, OkayActionDelegate {
    func okayAction() {
        self.navigationController?.popViewController(animated: true)
        //    orientationChange()
    }
    
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController) {
        self.navigationController?.popViewController(animated: true);
    }
    
    var homeModel: HomeModel?
    
    var player: AVPlayer?
    @IBOutlet var ivAnimate: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var qaView: UIView!
    @IBOutlet var answerBtn: UIButton!
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var ansLbl: UILabel!
    @IBOutlet var qaDesc: UILabel!
    @IBOutlet var mainAllView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    let customAlertVC = CustomAlertVC.instantiate()
    
    //    var qaTitleArray = [String]()
    //   var qaDescArray = [String]()
    
    var qaList = [QansModel]()
    
    var qaDescArray: [String] = ["How are you feeling today?", "Is Something making you scared?", "What do you like to do after coming from school? ", "What is your weakness?", "What is your favorite food?"];
    
    var completedCount: Int = 0;
    var nextQuesDelay: Int = 60 // 1 minute delay
    var characterDelayQues: Float = 0.2 // 0.2 second
    var qaAnsLabelDelay: Float = 0.6 // 0.6 second
    
    //Scrollview top spacing fix in iphone10 above
    private var scrollViewSafeAreaObserver: NSKeyValueObservation!
    @available(iOS 11.0, *)
    func scrollViewSafeAreaInsetsDidChange() {
        self.scrollView.contentInset.top = -self.scrollView.safeAreaInsets.top
    }
    
    deinit {
        self.scrollViewSafeAreaObserver?.invalidate()
        self.scrollViewSafeAreaObserver = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        self.setViewAni(view: self.bgView, hidden: true)
        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "ansBG.png")!)
        
        playBackBG()
        completedCount = 0;
        
        self.setViewAni(view: self.qaView, hidden: true)
        self.setViewAni(view: self.answerBtn, hidden: true)
        self.setViewAni(view: self.skipBtn, hidden: true)
        
        ansLbl.text = ""
        self.setPageQuestions(count: 0, delay: nextQuesDelay)
        let type = homeModel?.enumType?.rawValue
        print(type ?? 0)
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
        
        let str = textField.text
        textField.text = ""
        ansLbl.text = str
        
        let qa = QansModel()
        qa.question = qaDescArray[completedCount]
        qa.answer = str ?? ""
        qaList.append(qa)
        completedCount = completedCount+1
        UIView.transition(with: self.ansLbl, duration: TimeInterval(5),
                          options: .transitionCrossDissolve,
                          animations: {
            self.ansLbl.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // 4second delay to show the video
                self.answerCompletion()
                self.setPageQuestions(count: self.completedCount, delay: 0)
            }
        })
        return true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //       orientationChange()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        if (completedCount < 4) {
            completedCount = completedCount+1;
            answerCompletion()
            self.setPageQuestions(count: self.completedCount, delay: nextQuesDelay)
        } else {
            completedCount = completedCount+1;
            answerCompletion()
            showSuccess()
        }
    }
    
    @IBAction func answerNwAction(_ sender: Any) {
        self.textField.becomeFirstResponder()
        self.setViewAni(view: bgView, hidden: false)
        self.setViewAni(view: answerBtn, hidden: true)
        self.setViewAni(view: skipBtn, hidden: true)
    }
    
    func answerCompletion() {
        self.setViewAni(view: bgView, hidden: true)
        self.setViewAni(view: answerBtn, hidden: true)
        self.setViewAni(view: skipBtn, hidden: true)
        self.setViewAni(view: qaView, hidden: true)
        self.setViewAni(view: videoView, hidden: false)
        videoView.fadeIn()
    }
    
    func setPageQuestions(count: Int, delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) { // 2second
            self.completedCount = count
            self.setViewAni(view: self.answerBtn, hidden: true)
            self.setViewAni(view: self.skipBtn, hidden: true)
            self.setViewAni(view: self.qaView, hidden: false)
            
            DispatchQueue.main.async {
                self.ansLbl.text = ""
                let isIndexValid = self.qaDescArray.indices.contains(count)
                if (isIndexValid) {
                    self.qaDesc.animateLabel(newText:  self.qaDescArray[count], characterDelay: TimeInterval(self.characterDelayQues)) { Bool in
                        self.showAnsNowBtn()
                    }
                }
                self.showSuccess()
            }
        }
    }
    
    func showSuccess() {
        if (self.completedCount == qaDescArray.count) {
            self.setViewAni(view: qaView, hidden: true)
            if (qaList.count > 0) {
                CoreDataManager.shared.createRecord(qaList: qaList, homeModel: homeModel!)
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
            self.setViewAni(view: self.answerBtn, hidden: false)
            self.setViewAni(view: self.skipBtn, hidden: false)
            self.ansLbl.text = ""
        }
    }
    
    func playBackBG() {
//        let filepath: String? = Bundle.main.path(forResource:homeModel?.videoName, ofType: "mp4")
//        let fileURL = URL.init(fileURLWithPath: filepath!)
//        let item = AVPlayerItem(url: fileURL)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
//
//        player = AVPlayer(playerItem: item)
//        //   let player = AVPlayer(url: fileURL)
//        player?.isMuted = true
//        player?.volume = 0.0
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        playerLayer.contentsGravity = .resizeAspect
//        //  playerLayer.videoGravity = .resizeAspect
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        videoView.layer.insertSublayer(playerLayer, at: 0)
//        //      videoView.backgroundColor = UIColor.black
//        player?.seek(to: CMTime.zero)
//        player?.play()
        let fetcher = BundleURLFetcher()
        DispatchQueue.main.async {
            let imageUrl = fetcher.fetchURL(for: FileFormat.apng)
            self.ivAnimate.sd_setImage(with: imageUrl)
            self.ivAnimate.contentMode = .scaleAspectFill
            self.videoView.backgroundColor = #colorLiteral(red: 0.6352941176, green: 0.5176470588, blue: 0.368627451, alpha: 1)
            self.bgView.backgroundColor = #colorLiteral(red: 0.6352941176, green: 0.5176470588, blue: 0.368627451, alpha: 1)
        }
    }
    
    @objc func itemDidFinishPlaying(sender: Notification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    func setViewAni(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    func orientationChange() {
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func setScrollView() {
        if #available(iOS 11.0, *) {
            self.scrollViewSafeAreaObserver = self.scrollView.observe(\.safeAreaInsets) { [weak self] (_, _) in
                self?.scrollViewSafeAreaInsetsDidChange()
            }
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

