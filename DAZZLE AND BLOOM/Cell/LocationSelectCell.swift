//
//  LocationSelectCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/12/22.
//

import UIKit

class LocationSelectCell: UICollectionViewCell {
    
    static let reuseIdentifer = "location-cell-reuse-identifier"

    
    @IBOutlet weak var imgOfIcon: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
