

//  Faq_ViewController.swift
//  NewTeethCam
//  Created by Raja Vikram singh on 12/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.


import UIKit

class Faq_ViewController: UIViewController {

    @IBOutlet weak var web_View: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let shadowPath_History = UIBezierPath(rect: web_View.bounds)
        web_View.layer.masksToBounds = true
        web_View.layer.shadowColor = UIColor.lightGray.cgColor
        web_View.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        web_View.layer.shadowOpacity = 1.0
        web_View.layer.shadowRadius = 1.0
        web_View.layer.shadowPath = shadowPath_History.cgPath
        web_View.layer.cornerRadius = 14
        
        let str_WebView = "\(kGLOBAL_URL)"+"/faq.html"
        print("str_WebView is:- ",str_WebView)
        
        let url = URL(string:str_WebView)
        let requestObj = URLRequest(url: url! as URL)
        web_View.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    MARK :- IBActions
    @IBAction func btn_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
