
//  Model_Login.swift
//  NewTeethCam

//  Created by Raja Vikram singh on 13/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.


import Foundation


class Model_Login {
    
    static let sharedInstance = Model_Login()
    
    var str_Email = ""
    var str_PWD = ""
    
    var str_User_ID = ""

    var dict_LoginData = [String:Any]()
    
    class func func_Login(completionHandler:@escaping ([String:Any])->()) {
        
        let str_FullURL = "\(kBaseURL)\(Model_Login.sharedInstance.str_Email)/\(Model_Login.sharedInstance.str_PWD)"
        
        print("str_FullURL is:- ",str_FullURL)
        
        API_NewTeethCam.func_API_GetMethod(str_URL: str_FullURL) { (response) in
                print(response)
                
                if "\(response["UserId"]!)" == "1" {
                    self.sharedInstance.str_User_ID = "\(response["UserId"]!)"
                }
            
            completionHandler(response)
        }

    }
}
