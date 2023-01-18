//
//  SocialMediaCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 27/11/22.
//

import UIKit

@objc protocol SocialMediaDelegate: NSObjectProtocol{
    
    func socialMediaTextField(textfieldValue: String , fieldTag: Int)
    
}

class SocialMediaCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var twittertxtField: UITextField!
    @IBOutlet weak var instragramtxtField: UITextField!
    @IBOutlet weak var facebooktxtField: UITextField!
    @IBOutlet weak var youtubetxtField: UITextField!
    
    
    static let reuseIdentifer = "socialMedia-cell-reuse-identifier"
    weak var tableViewDelegate: SocialMediaDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        twittertxtField.delegate = self
        twittertxtField.tag = 102
        
        instragramtxtField.delegate = self
        instragramtxtField.tag = 104
        
        facebooktxtField.delegate = self
        facebooktxtField.tag = 101
        
        youtubetxtField.delegate = self
        youtubetxtField.tag = 103
        
    }
    
    
    // UITextField Defaults delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text! + string
        tableViewDelegate?.socialMediaTextField(textfieldValue: currentText, fieldTag: textField.tag)
        
        return true
    }

}
