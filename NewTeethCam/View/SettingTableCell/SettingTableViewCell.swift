//
//  SettingTableViewCell.swift
//  NewTeethCam
//
//  Created by Rajat Pathak on 09/07/18.
//  Copyright © 2018 Rajat Pathak. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var SettingsTitle: UILabel!
    @IBOutlet weak var settingsSubTitle: UILabel!
    @IBOutlet weak var socialImages: UIImageView!
    @IBOutlet weak var viewCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        socialImages.layer.cornerRadius = socialImages.frame.size.height/2
        socialImages.clipsToBounds = true
        
        viewCell.layer.cornerRadius = 2
        viewCell.layer.shadowOpacity = 1.0
        viewCell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        viewCell.layer.shadowRadius = 3.0
        viewCell.layer.shadowColor = UIColor .lightGray.cgColor
        
        viewCell.layer.borderColor = UIColor .lightGray .cgColor
        viewCell.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
