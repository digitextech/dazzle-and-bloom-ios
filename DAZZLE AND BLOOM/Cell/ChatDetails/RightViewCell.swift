//
//  RightViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class RightViewCell: UITableViewCell {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    @IBOutlet weak var author_Icon: UIImageView!
    @IBOutlet weak var author_date: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.rounded(radius: 12)
        messageContainerView.backgroundColor = UIColor(red: 247/255.0, green: 220/255.0, blue: 234/255.0, alpha: 1.0)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
}
