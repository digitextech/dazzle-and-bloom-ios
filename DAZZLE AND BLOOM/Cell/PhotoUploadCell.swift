//
//  PhotoUploadCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/12/22.
//

import UIKit

class PhotoUploadCell: UICollectionViewCell {

    static let reuseIdentifer = "photo-cell-reuse-identifier"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var img8Outlet: UIImageView!
    @IBOutlet weak var img7Outlet: UIImageView!
    @IBOutlet weak var img6Outlet: UIImageView!
    @IBOutlet weak var img5Outlet: UIImageView!
    @IBOutlet weak var img4Outlet: UIImageView!
    @IBOutlet weak var img3Outlet: UIImageView!
    @IBOutlet weak var img2Outlet: UIImageView!
    @IBOutlet weak var img1Outlet: UIImageView!
    
    @IBOutlet weak var img_Delete8Outlet: UIImageView!
    @IBOutlet weak var img_Delete7Outlet: UIImageView!
    @IBOutlet weak var img_Delete6Outlet: UIImageView!
    @IBOutlet weak var img_Delete5Outlet: UIImageView!
    @IBOutlet weak var img_Delete4Outlet: UIImageView!
    @IBOutlet weak var img_Delete3Outlet: UIImageView!
    @IBOutlet weak var img_Delete2Outlet: UIImageView!
    @IBOutlet weak var img_Delete1Outlet: UIImageView!
    
    @IBOutlet weak var upperStackOutlet: UIStackView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
