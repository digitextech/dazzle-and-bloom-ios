//
//  ContactEditCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit

@objc protocol TableViewDelegate: NSObjectProtocol{
    
    func afterClickingReturnInTextField(textfieldValue: String , cellIndexPath: IndexPath)
    func afterClickingSelect(cellIndexPath: IndexPath)
    
}

class ContactEditCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var valueTxtField: UITextField!
    static let reuseIdentifer = "listing-cell-reuse-identifier"
    weak var tableViewDelegate: TableViewDelegate?
    var indexPath: IndexPath?
    var displayArray = [StaticKeyWithValue]()
    var typeOfDisplayField = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // UITextField Defaults delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (indexPath?.section == 0 && indexPath?.row == 1 || indexPath?.section == 0 && indexPath?.row == 2  || indexPath?.section == 1 && indexPath?.row == 2 || indexPath?.section == 4 && indexPath?.row == 0)  && typeOfDisplayField != "text"{
            tableViewDelegate?.afterClickingSelect(cellIndexPath: indexPath!)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if typeOfDisplayField == "phone" && textField.text == ""{
            textField.text = "+44" 
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text! + string
        tableViewDelegate?.afterClickingReturnInTextField(textfieldValue: currentText , cellIndexPath: indexPath!)
        return true
    }
    
    
}

