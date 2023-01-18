//
//  AllListingItemCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 12/12/22.
//

import UIKit

class AllListingItemCell: UICollectionViewCell {
    
    static let reuseIdentifer = "allListing-cell-reuse-identifier"
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var listingID: UILabel!
    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var explbl: UILabel!
    @IBOutlet weak var listStatus: UILabel!
    
    @IBOutlet weak var listStackView: UIStackView!
    @IBOutlet weak var edit_listingViewOutlet: UIView!
    
    @IBOutlet weak var delete_listingViewOutlet: UIView!
    @IBOutlet weak var note_listingViewOutlet: UIView!
    @IBOutlet weak var publish_listingViewOutlet: UIView!
    @IBOutlet weak var preview_listingViewOutlet: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileIcon.layer.cornerRadius = 10
    }

}
