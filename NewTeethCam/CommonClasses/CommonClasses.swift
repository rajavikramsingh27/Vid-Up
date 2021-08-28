//
//  CommonClasses.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 13/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


class CommonClasses {
    
    //     MARK: funcIsValidEmail
    class func func_IsValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}



extension UIViewController {
    
    func func_ShowHud(with Message:String) {
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(UIColor .lightGray)
            SVProgressHUD.show(withStatus: Message)
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func func_ShowHud()  {
        DispatchQueue.main.async {
            
            SVProgressHUD.setBackgroundColor(UIColor .lightGray)
            SVProgressHUD .show()
            
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func func_HideHud()  {
        DispatchQueue.main.async {
            SVProgressHUD .dismiss()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func func_ShowHud_Error(with str_Error:String) {
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(UIColor .lightGray)
            SVProgressHUD.showError(withStatus: str_Error)
            self.view .isUserInteractionEnabled = false
        }
    }
    
    func func_ShowHud_With_Message(with msg:String)  {
        DispatchQueue.main.async {
            SVProgressHUD.setBackgroundColor(UIColor .lightGray)
            SVProgressHUD.showProgress(2.0, status: msg)
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func func_IsValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


extension UIColor {
    class func func_DefaultColor() -> UIColor {
        return UIColor (red: 255.0/255.0, green: 113.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
}

