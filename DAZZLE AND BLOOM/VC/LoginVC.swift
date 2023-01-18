//
//  LoginVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 15/10/22.
//

import UIKit
import Alamofire

class LoginVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var varifyBtnView: NativeCardView!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordViewOutlet: UIView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var phoneViewOutlet: UIView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailViewOutlet: UIView!
    @IBOutlet weak var logoViewOutlet: UIImageView!
    
    @IBOutlet weak var forgotPSWDViewOutlet: UIView!
    var loginResponseModel : LoginModelResponse!
    
    var isComingForPhone = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origImage = UIImage(named: "AppLogo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        logoViewOutlet.image = tintedImage
        logoViewOutlet.tintColor = .white
        
        
        if isComingForPhone {
            emailViewOutlet.isHidden = true
            passwordViewOutlet.isHidden = true
            phoneViewOutlet.isHidden = false
            
        }else{
            emailViewOutlet.isHidden = false
            passwordViewOutlet.isHidden = false
            phoneViewOutlet.isHidden = true
        }
        
        self.placeholderColourSet(fields: [passwordTxtField,phoneTxtField,emailTxtField])
        
        varifyBtnView.setOnClickListener {
            self.validateUserInput()
        }
        
        forgotPSWDViewOutlet.setOnClickListener {
            self.showAlertWithTextFields()
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
    
    
    func placeholderColourSet(fields: [UITextField]) {
        
        for item in fields {
            
            item.attributedPlaceholder =  NSAttributedString(string: item.placeholder!, attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlertWithTextFields() {
        
        let alertController = UIAlertController(title: "Forget Password", message: "You will get password reset link to your registered email", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Next", style: .default, handler: {
            alert -> Void in
            
            let emailTextField = alertController.textFields![0] as UITextField
            
            if emailTextField.text != "" {
                
                self.apiCallForgetPassword(email: emailTextField.text!)
                
            }else{
                
                Global.alertLikeToast(viewController: self, message: "Fields should not be empty, Please enter given info...")
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter email"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func apiCallForgetPassword(email : String)  {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.forget_password)\(email)")
        
        print(url)
        
        AF.request(url! , method: .get)
            .responseJSON { response in
                
                if response.response?.statusCode == 200 {
                    Global.alertLikeToast(viewController: self, message: "Password reset link has been sent to your registered email")
                }
            }
    }
    
    
    func validateUserInput() -> Bool {
        
        if isComingForPhone {
            guard phoneTxtField.text!.isEmpty == false else {
                Global.alertLikeToast(viewController: self, message: "Phone number required")
                return false
            }
            
        }else{
            guard emailTxtField.text!.isEmpty == false else {
                Global.alertLikeToast(viewController: self, message: "Email address required")
                return false
            }
            
            guard emailTxtField.text!.isValidEmail() == true else {
                Global.alertLikeToast(viewController: self, message: "Valid email address required")
                return false
            }
            guard passwordTxtField.text!.isEmpty == false else {
                Global.alertLikeToast(viewController: self, message: "Password required")
                return false
            }
            
        }
        if Global.isConnectedToNetwork() {
            
            Global.addLoading(view: self.view)
            
            if isComingForPhone {
                self.apiCallOTPVerification()
            }else{
                self.apiCallLoginUSer()
            }
        }else{
            Global.alertLikeToast(viewController: self, message: "Network connection required")
        }
        
        return true
    }
    
    
    func apiCallOTPVerification() {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.send_otp)")
        
        var phnNoFormat = String()
        
        if ((self.phoneTxtField.text?.contains("+44")) != nil) {
            phnNoFormat = self.phoneTxtField.text ?? ""
        }else{
            phnNoFormat = "+44" + (self.phoneTxtField.text ?? "")
        }
        
        let param = [
            "phone_number": "\(phnNoFormat)",
            "mode": "live",
            "action":"login"
        ] as [String : Any]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
        
            .responseJSON { response in
                Global.removeLoading(view: self.view)
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.result as? [String:Any] {
                        Global.alertLikeToast(viewController: self, message: "\(error.description)")
                    }else{
                        Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                    }
                }else  if response.response?.statusCode == 200 {
                    
                    Global.removeLoading(view: self.view)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let otpVC = storyBoard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    otpVC.phoneNumber = self.phoneTxtField.text ?? ""
                    otpVC.action = "login"
                    
                    self.navigationController?.pushViewController(otpVC, animated: true)
                    
                }else{
                    Global.removeLoading(view: self.view)
                    
                    Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                }
            }
    }
    
    func apiCallLoginUSer() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.login)")
        
        let param = [
            "username": "\(self.emailTxtField.text ?? "")",
            "password": "\(self.passwordTxtField.text ?? "")"
        ]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
        
            .responseDecodable(of: LoginModelResponse.self, decoder: decoder) { response in
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    self.loginResponseModel = value
                    DazzleUserdefault.setIsLoggedIn(val: true)
                    DazzleUserdefault.setUserPasswordAfterLogin(val: "\(self.passwordTxtField.text ?? "")")
                    DazzleUserdefault.setUserIDAfterLogin(val: self.loginResponseModel.ID ?? 0)
                    
                    DazzleUserdefault.setUserNameAfterLogin(val: self.loginResponseModel.data?.display_name ?? "")
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                    self.navigationController?.pushViewController(home, animated: true)
                    
                }
            }
            .responseJSON { response in
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    
                    switch response.result {
                    case .success(let value):
                        
                        if let json = value as? [String:Any] {
                            
                            if let message = json["message"] as? String {
                                Global.alertLikeToast(viewController: self, message: "\(message)")
                                
                            }
                        }
                    case .failure(let error):
                        print(error)
                        Global.removeLoading(view: self.view)
                        Global.alertLikeToast(viewController: self, message: "\(error.errorDescription)")
                    }
                    
                }
            }
    }
}
