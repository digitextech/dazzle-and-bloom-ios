//
//  ItemDetailsTitleCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/11/22.
//

import UIKit

class ItemDetailsTitleCell: UICollectionViewCell {

    static let reuseIdentifer = "product-details-title-cell-reuse-identifier"
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
