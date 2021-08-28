
//  Extenion-Facebook-Sharing.swift
//  NewTeethCam
//  Created by Raja Vikram singh on 06/09/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.



import Foundation
import Alamofire
import SVProgressHUD

import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

import FacebookCore
import FacebookLogin
import FacebookShare

import CloudrailSI



extension CameraViewController : FBSDKGraphRequestConnectionDelegate,FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print(sharer)
        print(results)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print(error)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print(sharer)
    }
    
    
    func func_Login_With_Facebook() {
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withPublishPermissions: ["publish_actions"], from: self) { (result, error) in
            print(result?.grantedPermissions)

            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }

        }


//        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
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
        
        
        
    }
    

    
    func func_UploadWithImage(endUrl: String, imageData: Data?, parameters: [String : Any], completionHandler:@escaping ([String:Any])->())
    {
        let url = URL (string: endUrl) /* your API url */

        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }

//            if let data = imageData{
//                multipartFormData.append(data, withName: "video_file_chunk", fileName: "video.png", mimeType: "image/png")
//            }

//            "video_file_chunk":"Hyperloop.mp4"

            
        }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: headers) { (result) in
            
            print(result)
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    do {
                        let json =  try JSONSerialization .jsonObject(with:response.data!
                            , options: .allowFragments)
                        print(json)
                        
//                        completionHandler(json as! [String:Any])
                    }
                    catch let error as NSError {
                        print("error is:-",error)
//                        completionHandler("false":"")
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func getFBUserData() {
        SVProgressHUD.show()
        
        print(FBSDKAccessToken.current().tokenString)
        let fb_Token_String = ""
        
//        FBSDKAccessToken.current().appID
//        FBSDKAccessToken.current().userID
        
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                print(error)
                if (error == nil) {
                    //everything works print the user data
                    print(result!)
                    
                    let resultJson : NSDictionary = result as! NSDictionary
                    let socialID = "\(resultJson["id"]!)"
                    let imageArray : NSDictionary = resultJson["picture"] as! NSDictionary
                    let data : NSDictionary = imageArray["data"] as! NSDictionary
                    let image_Url = "\(data["url"]!)"
                    let name = "\(resultJson["name"]!)"
//                  let DT = "\(UserDefaults.standard.object(forKey: "device_token")!)"
                    
                    self.uploadVideoOnFacebook()
                    
//                  self.uploadVideoToWall(fb_Token_String: fb_Token_String)
                }
            })
        }
    }

    
    func uploadVideoToWall (fb_Token_String:String)// (videoData: NSData)
    {
        var videoData: NSData
        
//        print(urlRecordedURL)
//
//        print(Bundle.main.path(forResource: "Hyperloop", ofType: ".mp4"))
//
////        guard
//            let localVideoPath = try? String (contentsOf: urlRecordedURL)  // Bundle.main.path(forResource: "Hyperloop", ofType: "mp4")
//        print(localVideoPath)
//
////        else {
////            print("local video not found")
////            return
////        }
//
//        print("local video path: \(localVideoPath)")
//
//        let localPathURL = URL(fileURLWithPath: "\(localVideoPath!)", isDirectory: false)
//        print("absolute string: \(localPathURL.absoluteString)")
        
        do {
            videoData = try NSData(contentsOf:urlRecordedURL )
//            print(videoData.bytes)
            
            var strDesc : String
            strDesc = "🤡🤡🤡 testing upload from test app 2"
            //Do no include "source" or "file_url" in the request parameters even though the FB documentation says so.
//            let videoObject: [String : Any] = ["contentType": "multipart/form-data", "title": "Testing yoooo", "description": strDesc, localPathURL.absoluteString: videoData]
            
            let videoObject: [String : Any] = ["access_token":fb_Token_String,"contentType": "multipart/form-data", "title": "Testing yoooo", "description": strDesc, "video": videoData]
            
            //self.view!.isUserInteractionEnabled = false
            
            let uploadVideoRequest = FBSDKGraphRequest(graphPath: "me/videos", parameters: videoObject, httpMethod: "POST")
            let connection = FBSDKGraphRequestConnection()
            connection.delegate = self
            connection.add(uploadVideoRequest, completionHandler: { (connection, result, error) in
                
                print("error is:-",error ?? "error is nil")
                print("result is:-",result ?? "result is nil")
                
//              print("connection is:-",connection ?? "connection is nil")
                
                if error != nil {
                    print("Error: \(String(describing: error))")
                } else {
                    print("Success")
                }
            })
            connection.start()
            
        } catch {
            print(error)
        }
    }
    
    func func_Sharing_Facebook(token:String) {
        
        let str_URL = "https://graph-video.facebook.com/v2.3/1533641336884006/videos"
        
        let parameters = [
            "access_token":token,
            "upload_phase":"transfer",
            "start_offset":"0",
            "upload_session_id":"391647784692123"
        ]
        
        func_UploadWithImage(endUrl: str_URL, imageData: nil, parameters: parameters) { (dicdsf) in
            
            print("asdf")
        }
    }
    
    
    func func_SharingVideo_CouldRail_SI() {
        
        //        func_ShowHud()
        func_ShowHud(with: "Uploading Video")
        do {
            let data = try Data(contentsOf:urlRecordedURL, options: .mappedIfSafe)
            print(data)
            
            CRCloudRail.setAppKey("5b912eca9dfc1256eddafa93")
            
            let service = Facebook(
                clientId: "391647784692123",
                clientSecret: "50428a8ca5e8fc9e977d3ad39aef8f1f"
            )
            
             try service .postVideo("Hello from CloudRail", video: .init(data: data), size: data.count, mimeType: "video/mp4")

        } catch {
            
        }
    }
    
    func uploadVideoOnFacebook() {
        
        let someImage = UIImage (named: "")
        
        let video_FB = FBSDKShareVideo()
        video_FB.videoURL = urlRecordedURL
        let content = FBSDKShareVideoContent()
        content.contentURL = urlRecordedURL
        
        FBSDKShareAPI .share(with: content, delegate: self)
        
        
        
//        UIImage *someImage = ...;
//        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//        content.photos = @[[FBSDKSharePhoto photoWithImage:someImage userGenerated:YES] ];
//
//        // Assuming self implements <FBSDKSharingDelegate>
//        [FBSDKShareAPI shareWithContent:content delegate:self];
        
//        var pathURL: URL
//        var videoData: Data
//        pathURL = urlRecordedURL //URL(string: "Your video url string")!
//        do {
//            videoData = try Data(contentsOf:urlRecordedURL)
//            print(videoData.count)
//            var strDesc : String
//            strDesc = ""
//            let videoObject: [String : Any] = ["title": "application Name", "description": strDesc, pathURL.absoluteString: videoData]
//            let uploadRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/videos", parameters: videoObject, httpMethod: "POST")
////            self.view!.isUserInteractionEnabled = false
//
//            uploadRequest.start { (ttte23, resdf, error123) in
//                print(error123)
//                print(resdf)
//            }
//
////            uploadRequest.start(completionHandler: {(connection: FBSDKGraphRequestConnection, result: AnyObject, error: NSError) -> Void in
////                if error == error {
////                    NSLog("\(error)")
////                }
////                else {
////                    NSLog("Success")
////                }
////            } as? FBSDKGraphRequestHandler)
//
//        } catch {
//            print(error)
//        }
        
    }
    
    
}
