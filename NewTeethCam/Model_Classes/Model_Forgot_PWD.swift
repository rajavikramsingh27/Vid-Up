//
//  Model_Forgot_PWD.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 17/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation


class Model_Forgot_PWD {
    
    static let sharedInstance = Model_Forgot_PWD()
    
    var str_Email = ""
    
    class func func_Forgot_PWD(completionHandler:@escaping ([String:Any])->()) {
        
        let dict_Param = [param_Forgot_PWD_LoginUserName:Model_Forgot_PWD.sharedInstance.str_Email] as [String:Any]
        
        API_NewTeethCam.func_API_PostMethod(params: dict_Param, str_URL: kForgot_PWD) { (response) in
            completionHandler(response)
        }
        
    }
}
