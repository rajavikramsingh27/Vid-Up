//
//  Share.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit
protocol shareViewDelegate {
    func socialConnectAction(_ sender: UIButton)
    func func_Share(_ sender: UIButton)
}

class Share: UIView {

    @IBOutlet weak var comentView: UITextView!
    
    var delegate:shareViewDelegate!
    
    @IBAction func socialConnectAction(_ sender: UIButton) {
        self.delegate.socialConnectAction(sender)
    }
    
    @IBAction func btn_Share(_ sender: UIButton) {
        self.delegate.func_Share(sender)
    }
    
    override func awakeFromNib() {
        comentView.layer.borderColor = UIColor.white.cgColor
    }
}
