//
//  AccountCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit

class AccountCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var mypackageLbl: UILabel!
    static let reuseIdentifer = "account-cell-reuse-identifier"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
