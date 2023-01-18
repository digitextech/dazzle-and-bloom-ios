//
//  PopupVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 18/12/22.
//

import UIKit
import IQKeyboardManagerSwift

class PopupVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var view_Main: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var viewBG_TxtView: UIView!
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var bg_HeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bidAmountTxt: UITextField!
    
    //MARK: Variables
    var isComingFor:String?
    var listingID: Int?
    var titleInput:String?
    var btnTitleInput:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up corner radius
        
        self.btnUpdate.setTitle("\(btnTitleInput ?? "")", for: .normal)
        self.lbl_Title.text = "\(titleInput ?? "")"
        
        view_Main.layer.cornerRadius = 25
        btnUpdate.layer.cornerRadius = 16
        
        viewBG_TxtView.layer.cornerRadius = 20
        viewBG_TxtView.layer.borderWidth = 1
        viewBG_TxtView.layer.borderColor = UIColor.lightGray.cgColor
        viewBG_TxtView.backgroundColor = .clear
        
        txtViewAbout.layer.cornerRadius = 20
        txtViewAbout.layer.borderWidth = 1
        txtViewAbout.layer.borderColor = UIColor.clear.cgColor
        txtViewAbout.backgroundColor = .clear

        
        //set background color
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    
        txtViewAbout.delegate = self
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if isComingFor == "Bid" {
            
            self.bidAmountTxt.isHidden = false
            self.bg_HeightConstant.constant = 400
            self.topConstant.constant = 74
            
        }else{
            self.bidAmountTxt.isHidden = true
            self.bg_HeightConstant.constant = 343
            self.topConstant.constant = 27
        }
    }
    
    //MARK: Functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("KH:\(keyboardSize)")
            self.view.frame.origin.y = 0
            let value = keyboardSize.height - 160
            print(value)
            self.view.frame.origin.y -= value
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //MARK: Action
    @IBAction func OnTapUpdate(_ sender: UIButton) {
        
        if self.txtViewAbout.text != "Type here.." && self.txtViewAbout.text != ""{
            
            self.dismiss(animated: true, completion: {
                IQKeyboardManager.shared.enable = false
                print("myabout:\(self.txtViewAbout.text ?? "")")
                if self.txtViewAbout.text != "Type here.." {
                    
                    if self.isComingFor == "Delete" {
                        NotificationCenter.default.post(name: Notification.Name("editprofile"), object:nil,userInfo: ["params":
                            [
                             "uid": DazzleUserdefault.getUserIDAfterLogin(),
                             "listing_id": self.listingID ?? 0,
                            "reason": "\(self.txtViewAbout.text ?? "")"
                            ], "type": [
                                "url": "Delete"
                          ]])
                    }else if self.isComingFor == "Note" {
                        NotificationCenter.default.post(name: Notification.Name("editprofile"), object:nil,userInfo: ["params":
                            [
                            "uid": DazzleUserdefault.getUserIDAfterLogin(),
                             "listing_id": self.listingID ?? 0,
                            "_notice_to_admin": "\(self.txtViewAbout.text ?? "")"
                       ], "type": [
                        "url": "Note"
                  ]])
                    }else if self.isComingFor == "Bid" && !self.bidAmountTxt.text!.isEmpty{
                        NotificationCenter.default.post(name: Notification.Name("productdetailsMsgbid"), object:nil,userInfo: ["params":
                            [
                            "uid": DazzleUserdefault.getUserIDAfterLogin(),
                             "listing_id": self.listingID ?? 0,
                            "message": "\(self.txtViewAbout.text ?? "")",
                            "bid": "\(self.bidAmountTxt.text ?? "")"
                       ], "type": [
                        "url": "Bid"
                  ]])
                    }else if self.isComingFor == "Contact"{
                        NotificationCenter.default.post(name: Notification.Name("productdetailsMsgbid"), object:nil,userInfo: ["params":
                            [
                            "uid": DazzleUserdefault.getUserIDAfterLogin(),
                             "listing_id": self.listingID ?? 0,
                            "message": "\(self.txtViewAbout.text ?? "")"
                       ], "type": [
                        "url": "Contact"
                  ]])
                    }else{
                        
                        Global.alertLikeToast(viewController: self, message: "Field can't be blank")
                    }
                }
            })
        }else{
            
            Global.alertLikeToast(viewController: self, message: "Field can't be blank")
        }

    }
    
    @IBAction func OnTapCancel(_ sender: UIButton) {
        IQKeyboardManager.shared.enable = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension PopupVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            if textView.text == "Type here.." {
                textView.text = ""
            }
            textView.text = textView.text
            return true
        }
        return true
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "Type here.."
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = text
        }

        else {
            return true
        }
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
