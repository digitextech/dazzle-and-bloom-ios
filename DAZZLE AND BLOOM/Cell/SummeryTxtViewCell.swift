//
//  SummeryTxtViewCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 27/11/22.
//

import UIKit

@objc protocol TextViewDelegateOfDetails: NSObjectProtocol{

    func afterClickingReturnInTextView(textfieldValue: String , cellIndexPath: IndexPath)
}

class SummeryTxtViewCell: UICollectionViewCell, UITextViewDelegate {
    
    static let reuseIdentifer = "summery-cell-reuse-identifier"
    
    @IBOutlet weak var txtViewOutlet: UITextView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    weak var tableViewDelegate: TextViewDelegateOfDetails?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtViewOutlet.delegate = self
    }
    
    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        self.tableViewDelegate?.afterClickingReturnInTextView(textfieldValue: updatedText , cellIndexPath: indexPath!)


        // make sure the result is under 16 characters
        return true
    }

}
