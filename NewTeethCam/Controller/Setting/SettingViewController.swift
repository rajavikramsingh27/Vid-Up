//
//  SettingViewController.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class SettingViewController: UIViewController {
    
    @IBOutlet weak var tbl_SettingVC: UITableView!

    let socialTitle = ["Facebook","LinkedIn","Youtube"]
    let socialImage = ["facebooklogo","linkedinlogo","youtubelogo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        tbl_SettingVC.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Info(_ sender: UIButton) {
        let faq_ViewController = self.storyboard?.instantiateViewController(withIdentifier: "Faq_ViewController")
        self.navigationController?.pushViewController(faq_ViewController!, animated: true)
    }
    
}


extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingTableViewCell
        
        cell.SettingsTitle.text = self.socialTitle[indexPath.row]
        cell.socialImages.image = UIImage(named: self.socialImage[indexPath.row])
        
        if indexPath.row == 0 {
            if let _ = UserDefaults.standard.object(forKey: k_FACEBOOK_DATA) as? Data {
                cell.settingsSubTitle.text = "logged in"
            } else {
                cell.settingsSubTitle.text = "not logged in"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let data_FACEBOOKData = UserDefaults.standard.object(forKey: k_FACEBOOK_DATA) as? Data {
                let facebook_VC = self.storyboard?.instantiateViewController(withIdentifier: "Facebook_Setting_ViewController")
                self.navigationController?.pushViewController(facebook_VC!, animated: true)
            } else {
                  func_LoginWithFaceBook()
            }
        }
    }
    
            
}

