//
//  Model_Register.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 13/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation

class Model_Register {
    
    static let sharedInstance = Model_Register()
    
    var str_UserName = ""
    var str_Email = ""
    var str_PWD = ""
    var str_SecretKey = "uMAdcUink6PGrOT3HEgrrw"
    
    
    class func func_Register(completionHandler:@escaping ([String:Any])->()) {

        let dict_Param = [param_Reg_SECRETKY:Model_Register.sharedInstance.str_SecretKey,
                          param_Reg_EMAIL:Model_Register.sharedInstance.str_Email,
                          param_Reg_PASSWORD:Model_Register.sharedInstance.str_PWD,
                          param_Reg_FIRSTNAME:Model_Register.sharedInstance.str_UserName,
                          param_Reg_LASTNAME:""] as [String:Any]
        
        print("dict_Param is:- ",dict_Param)
        
        API_NewTeethCam.func_API_PostMethod(params: dict_Param, str_URL:baseURL) { (response) in
            print("response is:- ",response)
            
            completionHandler([:])
        }
    }

}
