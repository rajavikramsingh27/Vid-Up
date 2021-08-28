//
//  ForgotPasswordViewController.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import SVProgressHUD


class ForgotPasswordViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var btn_SendPWD: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_SendPWD.layer.cornerRadius = 2
        btn_SendPWD.clipsToBounds = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_SendPWD(_ sender: UIButton) {
        if (txt_UserName.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Enter email ")
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
                SVProgressHUD.dismiss()
                
                return
            }
        } else {
            self.func_API_Forgot_PWD()
        }
        
//        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
//        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    
    func func_API_Forgot_PWD() {
        Model_Forgot_PWD.sharedInstance.str_Email = txt_UserName.text!

//        SVProgressHUD.show()
        func_ShowHud()
        Model_Forgot_PWD .func_Forgot_PWD { (response) in
            print("response is:- ",response)
            
            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
                self.func_HideHud()
            }
            
            let isSuccess = response["Success"] as! Bool
            
            DispatchQueue.main.async {
                if isSuccess
                {
                   SVProgressHUD.showSuccess(withStatus: "Password reset done")
                } else {
                    SVProgressHUD.showError(withStatus: "Password reset not done")
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view .endEditing(true)
        return true
    }
}





