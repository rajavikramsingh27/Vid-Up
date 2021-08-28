//
//  Extension-CameraViewController.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 25/08/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
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


extension CameraViewController {
    
    //    MARK:- function upload the video
    func func_UploadVideos(str_URL:String,param:[String:Any])  {
        self.view_PopUp.isHidden = true
        
        let url = URL(string: str_URL)!
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: param)
        request.httpBody =  jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            do {
                let json =  try JSONSerialization .jsonObject(with:data!
                    , options: .allowFragments)
                print("json is:-",json)
                
                DispatchQueue.main.async {
//                  http://newteethcam.azurewebsites.net/encoder.aspx?userid=0&key=q9uemJN08aj1NCgKh
                    
                    let str_FullURL = "http://newteethcam.azurewebsites.net/encoder.aspx?userid=\(Model_Login.sharedInstance.str_User_ID)&key=q9uemJN08aj1NCgKh"
                    print(str_FullURL)
                    
                    self.apiCall_GET(apiName: str_FullURL, completionHandler: { (dictJSON) in
                        print(dictJSON)
                        
                        if "\(dictJSON["success"]!)" == "1" {
                            self.str_UploadedVideo = dictJSON["mp4"] as! String
                        }
                        
                        DispatchQueue.main.async {
                            self.func_HideHud()
                            
                            let alertController = UIAlertController(title: "Video has been uploaded to your website successfully!", message: "", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            }))
                            self.present(alertController, animated: true)
                            
                            self.view_Down.isUserInteractionEnabled = true
                            self.view_Down_Landscape.isUserInteractionEnabled = true
                        }
                    })
                }
            }
            catch _ as NSError {
                DispatchQueue.main.async {
                    self.func_HideHud()
                    
                    let alertController = UIAlertController(title: "Something went wrong", message: "Please try again", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    }))
                    self.present(alertController, animated: true)
                    
                    self.view_Down.isUserInteractionEnabled = true
                    self.view_Down_Landscape.isUserInteractionEnabled = true
                }
            }
        }
        task.resume()
    }
    
    func func_BeforeUploadVideos() {
        
//        func_ShowHud()
        func_ShowHud(with: "Uploading Video")
        do {
            let data = try Data(contentsOf:urlRecordedURL, options: .mappedIfSafe)
            print(data)
            
            let strBase64 = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            
            let k_API_UPLOADVIDEOBASE = "/ws/bc.svc/uploadvideobase/"
            let kGLOBAL_URL = "http://newteethcam.azurewebsites.net"
            let url = kGLOBAL_URL+k_API_UPLOADVIDEOBASE
            
            let param = ["FileExt":"mov","AppKey":"133","File":strBase64]
            
            self.func_UploadVideos(str_URL: url, param: param)
        } catch  {
            
        }
    }
    
    //    MARK:- apiCall_GET
    func apiCall_GET(apiName:String,completionHandler:@escaping ([String:Any])->())
    {
        let request = NSMutableURLRequest (url: URL (string: apiName)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request as URLRequest, completionHandler:
            {
                (data, response, error) in
                print("error:-",error ?? "error nil")
                
                if error == nil
                {
                    do
                    {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        print("json data is:- \(jsonData)")
                        
                        completionHandler(jsonData as! [String:Any])
                    }
                    catch
                    {
                        print("Error info: \(error)")
                        completionHandler(["success":false])
                    }
                }
                else
                {
                    completionHandler(["success":false])
                }
        }).resume()
    }

    
}


extension CameraViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Comments ..." {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Comments ..."
            textView.textColor = UIColor.white
        }
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}




//  MARK:- YouTube methods
extension CameraViewController {
    
    @IBAction func uploadBtnClicked(sender : UIButton) {
        
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        
    }
    
    @IBAction func pauseUploadClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func stopUploadClicked(_ sender: Any) {
        
    }
    
    @IBAction func restartUploadClicked(_ sender: Any) {
        
    }
    
    func uploadVideoFile() {
        
        let status = GTLRYouTube_VideoStatus()
        status.privacyStatus = kGTLRYouTube_VideoStatus_PrivacyStatus_Public
        let snippet = GTLRYouTube_VideoSnippet()
        snippet.title = "VidUp"
        let desc = "\(txt_CommentView.text)"
        
        snippet.descriptionProperty = desc
        let tagsStr = ""
        if tagsStr.count > 0 {
            snippet.tags = tagsStr.components(separatedBy: ",")
        }
        let video = GTLRYouTube_Video()
        video.status = status
        video.snippet = snippet
        
        //            uploadVideowithVideoObject(video, resumeUploadLocationURL: urlRecordedURL)
        
        uploadVideowithVideoObject(video, resumeUploadLocationURL: nil)
    }
    
    func uploadVideowithVideoObject(_ video: GTLRYouTube_Video?, resumeUploadLocationURL locationURL: URL?) {
        //method definition...
        //            let fileToUploadURL = URL(fileURLWithPath: "\(uploadPathField)")
        let fileToUploadURL = URL(fileURLWithPath: "\(urlRecordedURL)")
        
        let _: Error?
        let filename = fileToUploadURL.lastPathComponent
        let mimeType = mimeTypeforFilename(filename, defaultMIMEType: "video/mp4")
        let uploadParameters = GTLRUploadParameters(fileURL: fileToUploadURL, mimeType: mimeType!)
        uploadParameters.uploadLocationURL = locationURL
        let query: GTLRYouTubeQuery? = GTLRYouTubeQuery_VideosInsert.query(withObject: video!, part: "snippet,status", uploadParameters: uploadParameters)
        query?.executionParameters.uploadProgressBlock = { progressTicket, totalBytesUploaded, totalBytesExpectedToUpload in
            
            print("total bytes = \(totalBytesUploaded)")
            print("uploaded bytes = \(totalBytesExpectedToUpload)")
        }
        uploadFileTicket = self.service.executeQuery(query!, delegate: self, didFinish: #selector(self.displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    func mimeTypeforFilename(_ filename: String?, defaultMIMEType defaultType: String?) -> String? {
        let result = defaultType
        return result
    }
    
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_Video,
        error : NSError?) {
        
        if let error = error {
            print(error)
        } else {
            print("upload sucessfull")
            self.hideProgressBar(self) {
                
            }
        }
    }
    
    //        MARK:- Hide Show progressbar methhods
    func displayProgressBarWithProgress(_ progres:Float,sender:UIViewController) -> (UIProgressView) {
        //create an alert controller
        let alertController = UIAlertController(title: "Processing...", message: "\n"+"Please stay in this screen...", preferredStyle: UIAlertControllerStyle.alert)
        
        self.progressbar = UIProgressView.init(progressViewStyle: .default)
        self.progressbar.center = CGPoint(x: 135.0, y: 100)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 150)
        alertController.view.addConstraint(height);
        self.progressbar.progress = progres
        self.progressbar.tintColor =  UIColor.init(red: 2/255.0, green: 133/255.0, blue: 198/255.0, alpha: 1.0)
        alertController.view.addSubview(self.progressbar)
        sender.present(alertController, animated: false, completion: nil)
        return self.progressbar;
    }
    
    func hideProgressBar(_ sender:UIViewController, completion : @escaping ()->()) {
        sender.dismiss(animated: true, completion: completion)
    }
}





//    MARK:- MSwiftyCamViewController delegate methods
extension CameraViewController : SwiftyCamViewControllerDelegate{
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = PhotoViewController(image: photo)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        urlRecordedURL = url
        print(urlRecordedURL)
        
        func_ShowHud(with: "Encoding Video...")
        self.view .isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.func_HideHud()
            
            self.view.isUserInteractionEnabled = true
            self.view_Down.isUserInteractionEnabled = false
            self.view_Down_Landscape.isUserInteractionEnabled = false
            self.view_PopUp.isHidden = false
            //            self.captureButton.isUserInteractionEnabled =
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
}

