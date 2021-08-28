//
//  Extension-LINKEDIN-Sharing.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 07/09/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import UIKit


//import li
//import IOSLinkedInAPIFix



extension CameraViewController {
    func shareinLinkd(in strvideo: String?) {
        let permissions = ["r_basicprofile", "w_share"]
        
        LISDKSessionManager.createSession(withAuth: permissions, state: nil, showGoToAppStoreDialog: true, successBlock: { returnState in
            print(returnState)
            
            print("\("success called!")")
            let session = LISDKSessionManager.sharedInstance().session
            if let aDescription = session?.description {
                print("Session : \(aDescription)")
            }
            
            let url = "https://api.linkedin.com/v1/people/~/shares"
            
            var liprivacy: String
            if (UserDefaults.standard.value(forKey: "li-privacy") as AnyObject).length() == 0 {
                liprivacy = "connections-only"
            } else {
                liprivacy = UserDefaults.standard.value(forKey: "li-privacy") as? String ?? ""
            }
            let uploadString = "{\"comment\":\"\",\"content\":{\"title\":\"Check out our latest video via bizzCam\",\"description\":\"Enjoy this video ! \",\"submitted-url\":\"\(strvideo ?? "")\",\"submitted-image-url\":\"\"},\"visibility\":{ \"code\":\"\(liprivacy)\" }}"
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().postRequest(url, stringBody: uploadString, success: { response in
                    if let aData = response?.data {
                        print("Response is \(aData)")
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.func_ShowHud(with: "Finished Sharing New Teeth Cam Clip")
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                            self.func_HideHud()
                        })
                    })
                    
                }, error: { apiError in
                    if let aDescription = apiError?.description {
                        print("Error is\(aDescription)")
                    }
                })
            }
        }, errorBlock: { error in
            if let anError = error {
                print("error :\(anError)")
            }
        })
    }
}




