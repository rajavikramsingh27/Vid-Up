//
//  File.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 06/09/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import Alamofire


//  MARK:- POST VIDEO TO YOUTUBE
extension CameraViewController {
    
    func func_YouTube_SharingRaja() {
        
        func_POST_UPLOAD_VIDEO_YOUTUBE(videoUrl: urlRecordedURL, token: youTubeToken, title: "VidUp", innoId: 1, videoTags: "") { (status) in
            print(status)
            DispatchQueue.main.async {
                self.func_HideHud()
                if status {
                    self.func_ShowHud(with: "Video Uploaded")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.func_HideHud()
                    })
                } else {
                    self.func_ShowHud(with: "Video not uploaded try again")
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.func_HideHud()
                    })
                }
            }
        }
    }
    
    func func_POST_UPLOAD_VIDEO_YOUTUBE(videoUrl: URL, token: String,title:String,innoId:Int,videoTags:String,callback: @escaping (Bool) -> Void) {
        do {
            let headers = ["Authorization": "Bearer \(token)"]
            let videoData = try Data(contentsOf: videoUrl)
            
            upload(multipartFormData: { multipartFormData in
                multipartFormData.append("{'snippet':{'title' : '\(title)', 'description': ''}}".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "snippet", mimeType: "application/json")
                multipartFormData.append("{'status' : {'privacyStatus':'unlisted'}}".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "status",mimeType: "application/json")
                multipartFormData.append(videoData, withName: "video", fileName: "video.mp4", mimeType: "application/octet-stream")
            }, usingThreshold: 1, to: URL(string: "https://www.googleapis.com/upload/youtube/v3/videos?part=snippet&status")!, method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        print("Post video to url --->\(response)")
                        if let json = response.result.value as? [String : Any] {
//                            let videoId = json["id"] as! String
                            
                        }
                        
                        callback(true)
                    }
                    break
                case .failure(_):
                    callback(false)
                    break
                }
            })
        }
        catch {
             callback(false)
        }
    }
    
}

