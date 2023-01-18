//
//  HomeListCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/11/22.
//

import UIKit

class HomeListCell: UICollectionViewCell {

    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var featured_icon: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var priceOutlet: UILabel!
    
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var categoryOutlet: UILabel!

    static let reuseIdentifer = "product-item-cell-reuse-identifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageOutlet.layer.cornerRadius = 12
    }

}
