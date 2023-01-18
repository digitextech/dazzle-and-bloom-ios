//
//  BookmarkCell.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 16/10/22.
//

import UIKit

class BookmarkCell: UICollectionViewCell {

    @IBOutlet weak var delete: NativeCardView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var bgView: NativeCardView!
    static let reuseIdentifer = "bookmark-details-item-cell-reuse-identifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
