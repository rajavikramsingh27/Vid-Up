//
//  LoginViewController.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import SVProgressHUD
import FacebookShare


class LoginViewController: UIViewController {

    @IBOutlet weak var view_Credentials: UIView!
    @IBOutlet weak var btn_SignIn: UIButton!
    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var txt_PWD: UITextField!

//    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func_Shadow()
        
        txt_UserName.text = "test@newteethcam.com"
        txt_PWD.text = "newteethcam"
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_ViewPWD(_ sender: UIButton) {
        if sender.isSelected {
            txt_PWD.isSecureTextEntry = false
        } else {
            txt_PWD.isSecureTextEntry = true
        }
        sender.isSelected = !(sender.isSelected)
    }
    
      @IBAction func btn_SignUp(_ sender: UIButton) {
        let SignUp_VC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp_ViewController")
        self.navigationController?.pushViewController(SignUp_VC!, animated: true)
    }
    
    @IBAction func btn_SignIn(_ sender: UIButton) {
        self.view .endEditing(true)
        
        if (txt_UserName.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Please fill the user name")
            return
        } else  if (txt_PWD.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Please fill the password")
            return
        }
        
        func_API_Login()
    }
    
    @IBAction func btn_ForgotPWD(_ sender: UIButton) {
        
        let forgotPassword_VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(forgotPassword_VC!, animated: true)
    }
}

extension LoginViewController
{
    func func_Shadow() {
        
        view_Credentials.layer.cornerRadius = 2
        view_Credentials.layer.shadowOpacity = 1.0
        view_Credentials.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view_Credentials.layer.shadowRadius = 3.0
        view_Credentials.layer.shadowColor = UIColor .lightGray.cgColor
        
        btn_SignIn.layer.cornerRadius = 2
        btn_SignIn.layer.shadowOpacity = 1.0
        btn_SignIn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn_SignIn.layer.shadowRadius = 3.0
        btn_SignIn.layer.shadowColor = UIColor .lightGray.cgColor
    }
    
    func func_API_Login() {
        Model_Login.sharedInstance.str_Email = txt_UserName.text!
        Model_Login.sharedInstance.str_PWD = txt_PWD.text!
        
        func_ShowHud()
        
        Model_Login .func_Login { (response) in
            print("response is:- ",response)
            
            DispatchQueue.main.async {
                self.func_HideHud()
            }
            
            let isSuccess = response["Success"] as! Bool
            if isSuccess
            {
                DispatchQueue.main.async {
                    let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController")
                    self.navigationController?.pushViewController(cameraVC!, animated: true)
                }
            }
        }
    }
    
}



