//
//  CameraViewController.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

import FacebookShare
import FacebookCore
import FBSDKCoreKit
import FacebookShare
import FBSDKShareKit
import SVProgressHUD
import FBSDKLoginKit

import Google
import GoogleAPIClientForREST
import GoogleSignIn

import LinkedinSwift
import GTMSessionFetcher
import Alamofire


class CameraViewController: SwiftyCamViewController,CountdownTimerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate,GIDSignInDelegate, GIDSignInUIDelegate {

    
//    MARK:- IBOutlet
    @IBOutlet weak var view_PopUp: UIView!
    @IBOutlet weak var txt_CommentView: UITextView!
    
    @IBOutlet weak var shareViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var viewForSupport: UIView!
    @IBOutlet weak var viewForSupport_Landscape: UIView!

    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var btn_SharingYouTube: UIButton!
    
    @IBOutlet weak var img_PlayButton: UIImageView!
    
    @IBOutlet weak var captureButton : SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    @IBOutlet weak var flashButton : UIButton!
    @IBOutlet weak var btn_PlayVedio : UIButton!
    @IBOutlet weak var btn_PlayVedio_Landscape : UIButton!
    @IBOutlet weak var btn_StopVideoRecording : UIButton!
    
    
    @IBOutlet weak var progressBar: ProgressBar!
//    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var counterView: UIStackView!
    @IBOutlet weak var counterView_Landscape: UIStackView!

    @IBOutlet weak var view_Upper: UIView!
    @IBOutlet weak var view_Down: UIView!

    @IBOutlet weak var view_Upper_Landscape: UIView!
    @IBOutlet weak var view_Down_Landscape: UIView!

    @IBOutlet weak var img_Logo_portrait: UIImageView!
    @IBOutlet weak var img_Logo_Landscape: UIImageView!
    
    @IBOutlet weak var shareButtonAction:UIButton!

    
    var progressbar : UIProgressView!

    var youTubeToken = ""
    var youTube_ID = ""
    
    
    
//    MARK:- Vars
//    MARK:- YouTube vars
   
    let output = UITextView()
    
    private let scopes = [kGTLRAuthScopeYouTube,kGTLRAuthScopeYouTubeForceSsl, kGTLRAuthScopeYouTubeUpload,kGTLRAuthScopeYouTubeYoutubepartner]
    
    let service : GTLRYouTubeService = GTLRYouTubeService()
    let signInButton = GIDSignInButton()
    
    var uploadTitleField = "Testing"
    var uploadPathField = ""
    var uploadFileTicket: GTLRServiceTicket?
    
    var uploadLocationURL : URL? = nil
    
    @IBOutlet weak var selectVideoBtn : UIButton!
    
//    MARK:- Other vars
    
    var countdownTimerDidStart = false
    var urlRecordedURL:URL! = nil
    var fbURL:URL!
    
    var cameraOn: Int = 0
    var changeOrder: Int = 0
    var change_p: Int = 0
    var change_l: Int = 0
    var recordingCount: Int = 0
    
    var isYouTubeSharing = false
    var isLinkedInSharing = false
    var isSharing = false
    
    
    var str_UploadedVideo = ""
    
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    // Test, for dev
    let selectedSecs:Int = 120
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont .boldSystemFont(ofSize: 24)
        
        label.textColor = UIColor.white
        label.textAlignment = .center

        return label
    }()
    
    //    MARK:- ViewController's lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view_Upper_Landscape.backgroundColor = UIColor .clear
        btn_StopVideoRecording.isHidden = true
        
        if UIDevice.current.orientation.isLandscape {
            view_Upper.isHidden = true
            view_Down.isHidden = true
            
            view_Upper_Landscape.isHidden = false
            view_Down_Landscape.isHidden = false
            
        } else {
            view_Upper.isHidden = false
            view_Down.isHidden = false
            
            view_Upper_Landscape.isHidden = true
            view_Down_Landscape.isHidden = true
        }
        
        view_PopUp.isHidden = true
        
        loginOutButton .addTarget(self, action:#selector(btn_LogOut(_:)), for:.touchUpInside)
        
        if UIDevice.current.orientation.isLandscape {
            loginOutButton.setImage(UIImage(named: "25"), for: .normal)
        } else {
            loginOutButton.setImage(UIImage(named: "27"), for: .normal)
        }
        
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: 29)
        progressBar.setProgressBar(hours: 0, minutes: 0, seconds: 29)
        
        view.addSubview(messageLabel)

        
        messageLabel.isHidden = true
        counterView.isHidden = false
        counterView_Landscape.isHidden = false
        
        func_ForOrientation()
        
        
        //ayush
        
        let fileManager = FileManager.default
        var _ : NSError?
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let destinationPath = doumentDirectoryPath.appendingPathComponent("Hyperloop.mp4")
       
        uploadPathField = destinationPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        img_Logo_portrait.layer.cornerRadius = 4
        img_Logo_portrait.clipsToBounds = true
        
        img_Logo_Landscape.layer.cornerRadius = 4
        img_Logo_Landscape.clipsToBounds = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        btn_StopVideoRecording.layer.cornerRadius = btn_StopVideoRecording.frame.size.height/2
        btn_StopVideoRecording.clipsToBounds = true
        
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        img_PlayButton.isHidden = true
        
        counterView.isHidden = true
        counterView_Landscape.isHidden = true
        
        if UIScreen .main .bounds .size .height == 812 {
            view_Upper.backgroundColor = UIColor .white
            view_Upper_Landscape.backgroundColor = UIColor.white
        } else {
            view_Upper.backgroundColor = UIColor .clear
            view_Upper_Landscape.backgroundColor = UIColor.clear
        }
        
        if view_PopUp.isHidden {
            view_Down.isUserInteractionEnabled = true
            view_Down_Landscape.isUserInteractionEnabled = true
            captureButton.isUserInteractionEnabled = true
        } else {
            view_Down.isUserInteractionEnabled = false
            view_Down_Landscape.isUserInteractionEnabled = false
            captureButton.isUserInteractionEnabled = false
        }
        view_PopUp.layer.cornerRadius = 20
        view_PopUp.clipsToBounds = true
        
        self.shareViewConstraint.constant = 0
        shareView.isHidden = true
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        func_ForOrientation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        shareButtonAction.isSelected = false
        shareView.isHidden = true
        viewForSupport.backgroundColor = UIColor .white
        viewForSupport_Landscape.backgroundColor = UIColor .white
        
        UIView.animate(withDuration: 0.5) {
            self.shareViewConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureButton.delegate = self
//        shareView.isHidden = true
        viewForSupport.backgroundColor = UIColor .white
        viewForSupport_Landscape.backgroundColor = UIColor .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK:- IBAction
    @IBAction func shareButtonAction(_ sender: UIButton)
    {
        self.view .endEditing(true)
        
        if sender.isSelected {
          UIView.animate(withDuration: 0.5) {
                self.shareViewConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }
            
            shareView.isHidden = true
            viewForSupport.backgroundColor = UIColor .white
            viewForSupport_Landscape.backgroundColor = UIColor .white
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.shareViewConstraint.constant = self.view.frame.height / 2
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }, completion: nil)
            
            shareView.isHidden = false
            viewForSupport.backgroundColor = UIColor .func_DefaultColor()
        }
        sender.isSelected = !(sender.isSelected)
    }
    
    @IBAction func btn_Info(_ sender: UIButton) {
        guard isVideoRecording != true else {
            print("video is recording ... ")
            return
        }
        
        let faq_ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Faq_ViewController")
        self.navigationController?.pushViewController(faq_ViewController!, animated: true)
    }
    
    @IBAction func btn_Flash(_ sender: Any) {
        print("currentCamera is:-",currentCamera)
        
        switch currentCamera {
        case .front:
            print("front camera has not flash facility")
            
        case .rear:
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            if (device?.hasTorch)! {
                try? device?.lockForConfiguration()
                let torchOn = !(device?.isTorchActive)!
                try?  device?.setTorchModeOn(level: 1.0)
                device?.torchMode = torchOn ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
                device?.unlockForConfiguration()
            }
        }
    }
    
    @IBAction func btn_YouTubeShare(_ sender: UIButton) {
        
        isYouTubeSharing = !isYouTubeSharing
        sender.isSelected  = !(sender.isSelected)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = self.scopes
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func btn_LinkedIn_Share(_ sender: UIButton) {
        
//        if str_UploadedVideo == "" {
//            SVProgressHUD.showError(withStatus: "Upload Video Frist")
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
//                SVProgressHUD.dismiss()
//
//                return
//            }
//        } else {
//        isLinkedInSharing = !isLinkedInSharing
//        sender.isSelected = !(sender.isSelected)
        
            shareinLinkd(in: "https://s3.amazonaws.com/newteethcam-encode/videos/mp4/200p/baf16347-fc27-4eb8-acb3-f089e1b2b3060.mp4")
            
//        let configuration = LinkedinSwiftConfiguration (clientId: "81r8b2gfku6rn3", clientSecret: "OpjF3HsgG7g2Q5VI", state: "5291715", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://dev.example.com/auth/linkedin/callback")
//
//        let linkedinHelper = LinkedinSwiftHelper(configuration: configuration!)
//        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
//            print("isToken is:- ",lsToken)
//            self.func_FetchLinkedInDetails()
//        }, error: { (error) -> Void in
//            print("error is:- ",error)
//        }, cancel: { () -> Void in
//            print("cancel")
//        })
//        }
        
    }
    
    func func_FetchLinkedInDetails()  {
        
        let configuration = LinkedinSwiftConfiguration (clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF45DIWOERCM", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "")

        let linkedinHelper = LinkedinSwiftHelper(configuration: configuration!)
        linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json",requestType: LinkedinSwiftRequestGet, success: {
            (response) -> Void in
            print(response)
            print("response is:- ",response.jsonObject)
        }) { [unowned self] (error) -> Void in
                print(error)
        }
    }
    
    @IBAction func btn_Share(_ sender: UIButton) {
        print(urlRecordedURL)
        
        if urlRecordedURL == nil {
            SVProgressHUD.showError(withStatus: "Record / Upload Video Frist")
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                SVProgressHUD.dismiss()
                
                return
            }
        } else {
            do {
                let data = try Data(contentsOf:urlRecordedURL, options: .mappedIfSafe)
                print(data)
                
                func_ShowHud(with: "Uploading on Youtube")
                func_YouTube_SharingRaja()
            } catch  {
                
            }
        }
    }
    
 
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
          
        } else {
            service.authorizer = user?.authentication.fetcherAuthorizer()
            
            youTube_ID = user.userID
            youTubeToken = user.authentication.accessToken
        }
    }

    @IBAction func btn_SocialConnectAction(_ sender: UIButton) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func btn_PlayVedio(_ sender: UIButton) {

        if UIDevice.current.orientation.isLandscape {
            counterView.isHidden = true
            counterView_Landscape.isHidden = true
            btn_PlayVedio.setImage(UIImage (named: "videoplay"), for: .normal)
            btn_PlayVedio.backgroundColor = UIColor .clear
            btn_PlayVedio.layer.cornerRadius =  0
            btn_PlayVedio.clipsToBounds = true
        } else {
            let alertController = UIAlertController(title: "Oops! To film, rotate camera to landscape mode.", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
         }
    }
    
    @IBAction func btn_PlayVedio_Landscape(_ sender: UIButton) {
        
        btn_StopVideoRecording.isHidden = false
        if UIDevice.current.orientation.isLandscape {
            
            guard isVideoRecording != true else {
                print("video is recording ... ")
                return
            }
            
            startTimer()
            
            btn_PlayVedio_Landscape.setImage(UIImage (named: ""), for: .normal)
            btn_PlayVedio_Landscape.backgroundColor = UIColor (red: 234.0/255.0, green: 68.0/255.0, blue: 36.0/255.0, alpha: 1.0)
            btn_PlayVedio_Landscape.layer.cornerRadius =  btn_PlayVedio_Landscape.frame.size.height/2
            btn_PlayVedio_Landscape.clipsToBounds = true
            
            startVideoRecording()
            
            counterView.isHidden = false
            counterView_Landscape.isHidden = false
        } else {
            let alertController = UIAlertController(title: "Oops! To film, rotate camera to landscape mode.", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }
    
    @IBAction func btn_StopVedio(_ sender: UIButton) {
       func_StopVideo()
    }
    
    func func_StopVideo() {
        btn_PlayVedio_Landscape.setImage(UIImage (named: "videoplay"), for: .normal)
        btn_PlayVedio_Landscape.backgroundColor = UIColor .clear
        btn_PlayVedio_Landscape.layer.cornerRadius =  0
        btn_PlayVedio_Landscape.clipsToBounds = true
        
        stopVideoRecording()
        self.counterView.isHidden = true
        counterView_Landscape.isHidden = true
        btn_StopVideoRecording.isHidden = true
        stopTimer()
    }
    
    @IBAction func btn_UploadPopUp(_ sender: Any) {
        func_BeforeUploadVideos()
    }
    
    @IBAction func btn_CancelPop(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Proceed", message: "You will lose the video if not uploaded, do you want to proceed?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style:.cancel, handler: { (alert) in
            
            self.view_PopUp.isHidden = true
            self.captureButton.isUserInteractionEnabled = true
            self.view_Down.isUserInteractionEnabled = true
            self.view_Down_Landscape.isUserInteractionEnabled = true
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    @IBAction func btn_PlayPopUp(_ sender: Any) {
        let newVC = VideoViewController(videoURL: urlRecordedURL)
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_LogOut(_ sender: UIButton) {
        UserDefaults .standard .removeObject(forKey: k_LOGIN_DATA)
        
        let login_VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        present(login_VC!, animated: true, completion: nil)
    }
    
    @IBAction func shareVideoOnFacebook(_ sender :UIButton) {
        
        
        func_Login_With_Facebook()
        
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
//            if (error == nil){
//                let fbloginresult : FBSDKLoginManagerLoginResult = result!
//                // if user cancel the login
//                if (result?.isCancelled)!{
//                    return
//                }
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    self.getFBUserData()
//                    fbLoginManager.logOut()
//                }
//            }
//        }

        
        
//        fbURL = URL(string: "https://s3.amazonaws.com/newteethcam-encode/videos/mp4/200p/8608e6ca-db61-4e5b-8085-be9a108810ad0.mp4")
//        var params : [AnyHashable : Any] = ["video_filename.MOV":"" ,"title":"My Vidup Video","description":"raja hai hum"] as [AnyHashable : Any]
//
//        var videoPath = fbURL
//        var videoData: Data? = try? Data(contentsOf: videoPath!)
//
//        FBSDKGraphRequest(graphPath: "/me/videos", parameters: params, httpMethod: "POSt").start { (connection, result, error) in
//            if error == nil{
//                print("success")
//                print(result)
//            } else {
//                print(error)
//                print("error")
//            }
//        }
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.shareViewConstraint.constant = self.view.frame.height / 2 + 90
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }, completion: nil)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {

            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                self.shareViewConstraint.constant = self.view.frame.height / 2
                self.view.layoutIfNeeded()
                self.view.setNeedsLayout()
            }, completion: nil)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    //    MARK :- Fisnish
}

// MARK:- extension

extension CameraViewController {
     func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
     func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        }
    }
    
     func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
//        view.addSubview(focusView)

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
   
    //MARK: - Countdown Timer Delegate
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        print(time.minutes)
        print(time.seconds)
        
//        hours.text = time.hours
        minutes.text = time.minutes
        seconds.text = time.seconds
        
        let str_Second = "\(time.seconds)"
        
        if Int(str_Second) == 0
        {
            func_StopVideo()
        }
    }
    
    func countdownTimerDone() {
        
        counterView.isHidden = true
        counterView_Landscape.isHidden = true
        
        messageLabel.isHidden = false
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        
//        stopBtn.isEnabled = false
//        stopBtn.alpha = 0.5
//        startBtn.setTitle("START",for: .normal)
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        print("countdownTimerDone")
    }
    
    
    
//    MARK: - IBActions
     func startTimer() {

        messageLabel.isHidden = true
        counterView.isHidden = false
        counterView_Landscape.isHidden = false
        
//        stopBtn.isEnabled = true
//        stopBtn.alpha = 1.0

        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
//            startBtn.setTitle("PAUSE",for: .normal)

        } else {
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
//            startBtn.setTitle("RESUME",for: .normal)
        }
    }

     func stopTimer() {
        countdownTimer.stop()
        progressBar.stop()
        countdownTimerDidStart = false
    }
    
    //  MARK:- func_ForOrientation
    func func_ForOrientation()
    {
        if UIDevice.current.orientation.isLandscape {
            loginOutButton.setImage(UIImage(named: "25"), for: .normal)
            
            view_Upper.isHidden = true
            view_Down.isHidden = true
            
            view_Upper_Landscape.isHidden = false
            view_Down_Landscape.isHidden = false
            viewForSupport.isHidden = true
            viewForSupport_Landscape.isHidden = false
            viewForSupport_Landscape.backgroundColor = UIColor .white
           
        } else {
            loginOutButton.setImage(UIImage(named: "27"), for: .normal)
            
            view_Upper.isHidden = false
            view_Down.isHidden = false
            
            view_Upper_Landscape.isHidden = true
            view_Down_Landscape.isHidden = true
            
            viewForSupport.isHidden = false
            viewForSupport_Landscape.isHidden = true
            
            guard isVideoRecording != true else {
                print("video is recording ... ")
                func_StopVideo()
                return
            }
        }
        captureButton .isHidden = true
    }
    
    

    // MARK:- Finish
}





