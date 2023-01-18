//
//  RegisterVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 15/10/22.
//

import UIKit
import Alamofire

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameViewOutlet: UIView!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var signupBtnView: NativeCardView!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var confirmPwdViewOutlet: UIView!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordViewOutlet: UIView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var phoneViewOutlet: UIView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailViewOutlet: UIView!
    @IBOutlet weak var logoViewOutlet: UIImageView!
    var loginResponseModel : LoginModelResponse!
    
    var userID = Int()
    var mobileNo = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origImage = UIImage(named: "AppLogo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        logoViewOutlet.image = tintedImage
        logoViewOutlet.tintColor = .white
        
        signupBtnView.setOnClickListener {
            self.validateUserInput()
        }
        
        self.placeholderColourSet(fields: [userNameTxtField,confirmPwdTextField,passwordTxtField,phoneTxtField,emailTxtField])
    }
    
    func placeholderColourSet(fields: [UITextField]) {
        
        for item in fields {
            
            item.attributedPlaceholder =  NSAttributedString(string: item.placeholder!, attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.phoneTxtField && textField.text == ""{
            textField.text = "+44"
        }
    }
    
    // UITextField Defaults delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateUserInput() -> Bool {
        
        guard userNameTxtField.text!.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Username required")
            return false
        }
        guard emailTxtField.text!.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Email address required")
            return false
        }
        
        guard emailTxtField.text!.isValidEmail() == true else {
            Global.alertLikeToast(viewController: self, message: "Valid email address required")
            return false
        }
        guard phoneTxtField.text!.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Phone number required")
            return false
        }
        
        guard passwordTxtField.text!.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Password required")
            return false
        }
        guard confirmPwdTextField.text == passwordTxtField.text else {
            Global.alertLikeToast(viewController: self, message: "Password mismatch")
            return false
        }
        
        if Global.isConnectedToNetwork() {
            Global.addLoading(view: self.view)
            self.apicallforRegisterUser()
        }else{
            Global.alertLikeToast(viewController: self, message: "Network connection required")
        }
        
        return true
    }
    
    func apiCallOTPVerification(user_id: Int, mobile_No:String) {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.send_otp)")
        
        let param = [
            "phone_number": "\(mobile_No)",
            "mode": "live",
            "email":"\(self.emailTxtField.text ?? "")",
            "action":"register"
        ] as [String : Any]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
        
            .responseJSON { response in
                Global.removeLoading(view: self.view)
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.result as? [String:Any] {
                        Global.alertLikeToast(viewController: self, message: "\(error["message"] as? String ?? "Email already exists, please try 'Reset Password'")")
                    }else{
                        Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                    }
                }else  if response.response?.statusCode == 200 {
                    
                    Global.removeLoading(view: self.view)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    otpVC.userID = self.userID
                    otpVC.phoneNumber = self.mobileNo
                    otpVC.action = "register"
                    
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    
                }else{
                    Global.removeLoading(view: self.view)
                    
                    Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                }
            }
    }
    
    func apicallforRegisterUser()  {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.signup)")
        
        var phnNoFormat = String()
        
        if ((self.phoneTxtField.text?.contains("+44")) != nil) {
            phnNoFormat = self.phoneTxtField.text ?? ""
        }else{
            phnNoFormat = "+44" + (self.phoneTxtField.text ?? "")
        }
        
        let param = [
            "username": "\(self.userNameTxtField.text ?? "")",
            "email": "\(self.emailTxtField.text ?? "")",
            "password": "\(self.passwordTxtField.text ?? "")",
            "phone_number": "\(phnNoFormat )"
        ]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
            .responseJSON { [self] response in
                
                switch response.result {
                    
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if response.response?.statusCode == 200 {
                            
                            if let mess = json["data"] as? [String:Any] {
                                
                                if let data = mess["data"] as? [String:Any] {
                                    self.userID = mess["ID"] as? Int ?? 0
                                    if let meta = data["meta"] as? [String:Any] {
                                        self.mobileNo = meta["user_phone"] as? String ?? ""
                                    }
                                }
                                
                                if self.userID != 0 && !self.mobileNo.isEmpty{
                                    self.apiCallOTPVerification(user_id: userID, mobile_No: mobileNo)
                                    
                                }else{
                                    Global.removeLoading(view: self.view)
                                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                                    
                                }
                            }else{
                                Global.removeLoading(view: self.view)
                                Global.alertLikeToast(viewController: self, message: "Something went wrong")
                                
                            }
                            
                        }else{
                            
                            Global.removeLoading(view: self.view)
                            
                            Global.alertLikeToast(viewController: self, message: "\(json["message"] as? String ?? "Email already exists, please try 'Reset Password'")")
                            
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    Global.alertLikeToast(viewController: self, message: "\(error)")
                    
                }
                
            }
    }
}

