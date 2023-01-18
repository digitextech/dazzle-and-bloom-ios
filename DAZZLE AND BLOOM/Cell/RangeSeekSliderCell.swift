//
//  RangeSeekSliderCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 25/12/22.
//

import UIKit
import  RangeSeekSlider

class RangeSeekSliderCell: UICollectionViewCell {

    static let reuseIdentifer = "range-cell-reuse-identifier"
    
    @IBOutlet weak var priceRangeOutlet: RangeSeekSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
