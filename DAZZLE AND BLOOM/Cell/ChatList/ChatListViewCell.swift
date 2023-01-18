//
//  ChatListViewCell.swift
//  ChatSample
//
//  Created by Hafiz on 22/10/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit

class ChatListViewCell: UITableViewCell {

   
    @IBOutlet weak var chatImageView: UIImageView!
    
    @IBOutlet weak var bidLeadingAlignment: NSLayoutConstraint!
    @IBOutlet weak var bid: NativeCardView!
    @IBOutlet weak var unread_view: NativeCardView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var author_img: UIImageView!
    @IBOutlet weak var author_Name: UILabel!
    @IBOutlet weak var author_Date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImageView.rounded(radius: 12)
    }
}
