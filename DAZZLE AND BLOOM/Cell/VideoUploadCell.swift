//
//  VideoUploadCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/12/22.
//

import UIKit

@objc protocol VideoUrlDelegate: NSObjectProtocol{

    func valueTextField(textfieldValue: String , cellIndexPath: IndexPath)
    
}

class VideoUploadCell: UICollectionViewCell, UITextFieldDelegate {

    static let reuseIdentifer = "video-cell-reuse-identifier"

    @IBOutlet weak var thumbnail_image: UIImageView!
    @IBOutlet weak var textbox: UITextField!
    @IBOutlet weak var addVideoaction: NativeCardView!
    weak var tableViewDelegate: VideoUrlDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textbox.delegate = self
    }
    
    
    // UITextField Defaults delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
  
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     let currentText = textField.text! + string
     tableViewDelegate?.valueTextField(textfieldValue: currentText , cellIndexPath: indexPath!)
     return true
 }

}
