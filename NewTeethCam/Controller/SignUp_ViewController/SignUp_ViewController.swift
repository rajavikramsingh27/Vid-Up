//
//  SignUp_ViewController.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 11/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import SVProgressHUD


class SignUp_ViewController: UIViewController {
    
    @IBOutlet weak var view_Credentials: UIView!
    @IBOutlet weak var btn_SignUp: UIButton!
    
    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_PWD: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func_Shadow()
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func btn_SignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_SignUp(_ sender: UIButton) {

        if (txt_UserName.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Please fill the user name")
            return
        } else  if (txt_Email.text?.isEmpty)!  {
            SVProgressHUD.showError(withStatus: "Please fill the email")
            return
        } else  if !(txt_Email.text?.isEmpty)!  {
            let isEmailValid =  CommonClasses.func_IsValidEmail(testStr: txt_Email!.text!)
            if !isEmailValid {
                SVProgressHUD.showError(withStatus: "Please fill the proper email")
                return
            }
        }  else if (txt_PWD.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "Please fill the password")
        }

        func_API_CreateUser()
        
//        let cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController")
//        self.navigationController?.pushViewController(cameraVC!, animated: true)
    }
}


extension SignUp_ViewController
{
    func func_Shadow() {
        
        view_Credentials.layer.cornerRadius = 2
        view_Credentials.layer.shadowOpacity = 1.0
        view_Credentials.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view_Credentials.layer.shadowRadius = 3.0
        view_Credentials.layer.shadowColor = UIColor .lightGray.cgColor
        
        btn_SignUp.layer.cornerRadius = 2
        btn_SignUp.layer.shadowOpacity = 1.0
        btn_SignUp.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn_SignUp.layer.shadowRadius = 3.0
        btn_SignUp.layer.shadowColor = UIColor .lightGray.cgColor
    }
    
    func func_API_CreateUser() {
        
        Model_Register.sharedInstance.str_SecretKey = "uMAdcUink6PGrOT3HEgrrw"
        Model_Register.sharedInstance.str_UserName = txt_UserName.text!
        Model_Register.sharedInstance.str_Email = txt_Email.text!
        Model_Register.sharedInstance.str_PWD = txt_PWD.text!
        
        func_ShowHud()
        Model_Register .func_Register { (response) in
            
            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
                self.func_HideHud()
            }
            print("response is:- ",response)
        }
    }
}

