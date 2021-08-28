//
//  Extension-SettingViewController.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 25/08/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import UIKit



import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit



import Google
import GoogleAPIClientForREST
import GoogleSignIn



extension SettingViewController {
    
    //    MARK:- Login with facebook
    func func_LoginWithFaceBook() {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.email,.publicProfile,.pagesShowList], viewController: self) { loginResult in
            
            print("loginResult is:- ",loginResult)
            switch loginResult {
            case .failed(let error):
                print(error)
            case  .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                print("grantedPermissions is:-",grantedPermissions.description)
                print("declinedPermissions is:-",declinedPermissions)
                print("accessToken is:-",accessToken)
                
                self.func_GetUserProfile()
            }
        }
    }
    
    func func_GetUserProfile () {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath:"/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: "2.8")) { httpResponse, result in
            print("result == ", result)
            
            switch result {
            case .success(let response):
                
                // Set Value
                let data_FACEBOOK = NSKeyedArchiver.archivedData(withRootObject: response.dictionaryValue!)
                UserDefaults .standard .setValue(data_FACEBOOK, forKey: k_FACEBOOK_DATA)
                
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}



extension SettingViewController:GIDSignInDelegate, GIDSignInUIDelegate {

    func func_GoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if error != nil {
            print(user.userID)
            print(user.profile.name)
            print(user.profile.email)
        } else {
            print("error is:-",error)
        }
    }
    
}



