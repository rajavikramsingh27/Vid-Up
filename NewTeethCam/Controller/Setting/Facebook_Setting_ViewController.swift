//
//  Facebook_Setting_ViewController.swift
//  NewTeethCam
//
//  Created by Raja Vikram singh on 12/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit

class Facebook_Setting_ViewController: UIViewController {
    //    MARK :- IBOoutlets

    @IBOutlet weak var txt_UserName: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    
    @IBOutlet weak var lbl_Pages: UILabel!

    @IBOutlet weak var btn_BizzCamTech: UIButton!
    
    @IBOutlet weak var btn_EveryOne: UIButton!
    @IBOutlet weak var btn_Friends: UIButton!
    @IBOutlet weak var btn_OnlyMe: UIButton!
 
    
//    MARK :- ViewController's lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let int_FacebookPrivacy = UserDefaults.standard.object(forKey: k_FACEBOOK_Privacy_DATA) as? Int {
            if int_FacebookPrivacy == enum_Facebook_Privacy.everyOne.rawValue {
                btn_EveryOne.isSelected = true
            } else if int_FacebookPrivacy == enum_Facebook_Privacy.friends.rawValue {
                btn_Friends.isSelected = true
            } else if int_FacebookPrivacy == enum_Facebook_Privacy.onlyMe.rawValue {
                btn_OnlyMe.isSelected = true
            }
        } else {
            UserDefaults .standard .setValue(enum_Facebook_Privacy.everyOne.rawValue, forKey: k_FACEBOOK_Privacy_DATA)
            btn_EveryOne.setImage(UIImage (named: k_Image_Select_FB_Privacy), for: .normal)
        }
        
        if let data_FACEBOOKData = UserDefaults.standard.object(forKey: k_FACEBOOK_DATA) as? Data {
            print(data_FACEBOOKData)
            let dict_FACEBOOKData = NSKeyedUnarchiver.unarchiveObject(with: data_FACEBOOKData) as? [String: Any]
            print(dict_FACEBOOKData ?? "nil")
            
            txt_UserName.text = dict_FACEBOOKData!["name"] as? String
            txt_Email.text = dict_FACEBOOKData!["email"] as? String
        }
        func_SetDesign()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    MARK :- IBActions
    @IBAction func btn_RemoveAccount(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: k_FACEBOOK_DATA)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_EveryOne(_ sender: UIButton) {
        btn_EveryOne .isSelected = true
        btn_Friends.isSelected = false
        btn_OnlyMe.isSelected = false
        
        func_Privacy(facebook_Privacy: enum_Facebook_Privacy.everyOne.rawValue)
    }
    
    @IBAction func btn_Friends(_ sender: UIButton) {
        btn_EveryOne.isSelected = false
        btn_Friends.isSelected = true
        btn_OnlyMe.isSelected = false
        
        func_Privacy(facebook_Privacy: enum_Facebook_Privacy.friends.rawValue)
    }
    
    @IBAction func btn_OnlyMe(_ sender: UIButton) {
        btn_EveryOne.isSelected = false
        btn_Friends.isSelected = false
        btn_OnlyMe.isSelected = true
        
        func_Privacy(facebook_Privacy: enum_Facebook_Privacy.onlyMe.rawValue)
    }
    
}

extension Facebook_Setting_ViewController {
    func func_SetDesign() {
        
        lbl_Pages.isHidden = true
        btn_BizzCamTech.isHidden = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.txt_UserName.frame.size.height))
        self.txt_UserName.leftView = paddingView
        self.txt_UserName.leftViewMode = .always
        
        let paddingView_Email = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.txt_Email.frame.size.height))
        self.txt_Email.leftView = paddingView_Email
        self.txt_Email.leftViewMode = .always
        
        btn_BizzCamTech.layer.cornerRadius = 2
        btn_BizzCamTech.layer.shadowOpacity = 1.0
        btn_BizzCamTech.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        btn_BizzCamTech.layer.shadowRadius = 1.0
        btn_BizzCamTech.layer.shadowColor = UIColor .lightGray.cgColor
        btn_BizzCamTech.layer.borderWidth = 1
        btn_BizzCamTech.layer.borderColor = UIColor .lightGray .cgColor
    }
    
    func func_Privacy(facebook_Privacy:Int) {
        // Set Value
//        let data_JSON = NSKeyedArchiver.archivedData(withRootObject: dict_JSON)
        
        if let _ = UserDefaults.standard.object(forKey: k_FACEBOOK_Privacy_DATA) {
            UserDefaults.standard.removeObject(forKey: k_FACEBOOK_Privacy_DATA)
            UserDefaults .standard .setValue(facebook_Privacy, forKey: k_FACEBOOK_Privacy_DATA)
        }
    }
    
}

enum enum_Facebook_Privacy:Int {
    case onlyMe
    case friends
    case everyOne
}


