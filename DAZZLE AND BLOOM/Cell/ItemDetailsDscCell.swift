//
//  ItemDetailsDscCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/11/22.
//

import UIKit

class ItemDetailsDscCell: UICollectionViewCell {

    static let reuseIdentifer = "product-details-details-cell-reuse-identifier"
    
    @IBOutlet weak var descValue: UILabel!
    @IBOutlet weak var descLbl: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
