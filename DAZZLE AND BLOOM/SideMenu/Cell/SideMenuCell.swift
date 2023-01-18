//
//  SideMenuCell.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var externalLink: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        self.backgroundColor = .clear
        
        // Icon
        self.iconImageView.tintColor = .black
        
        // Title
        self.titleLabel.textColor = .black
    }
}
