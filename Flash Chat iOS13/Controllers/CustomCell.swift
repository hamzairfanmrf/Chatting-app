//
//  CustomCell.swift
//  Flash Chat iOS13
//
//  Created by Mac on 08/10/2024.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var MessageBubble: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    override func awakeFromNib() {
        MessageLabel.layer.cornerRadius = MessageLabel.frame.size.height / 5
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
