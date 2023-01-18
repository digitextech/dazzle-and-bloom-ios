//
//  LeftViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {

    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var author_Icon: UIImageView!
    @IBOutlet weak var author_date: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.rounded(radius: 12)
        messageContainerView.backgroundColor = UIColor(red: 241/255.0, green: 243/255.0, blue: 240/255.0, alpha: 1.0)

        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
 
}
