//
//  OTPVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 15/10/22.
//

import UIKit
import AEOTPTextField
import Alamofire

class OTPVC: UIViewController {

    @IBOutlet weak var numberDisplayOutlet: UILabel!
    @IBOutlet weak var otpTextField: AEOTPTextField!
    @IBOutlet weak var resentCodeLbl: UILabel!
    @IBOutlet weak var logoViewOutlet: UIImageView!
    @IBOutlet weak var otpSigninAction: NativeCardView!
    
    var otpString = String()
    
    let otpdisplay1 = "We sent a text with a security code to "
    let otpdisplay2 = " It may take a moment to arrive"
    
    var userID = Int()
    var phoneNumber = String()
    var email = String()
    var action = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        let origImage = UIImage(named: "AppLogo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        logoViewOutlet.image = tintedImage
        logoViewOutlet.tintColor = .white
        
        otpTextField.otpDelegate = self
        otpTextField.otpFontSize = 22
        otpTextField.otpTextColor = UIColor(named: "appBGColor")!
        otpTextField.otpCornerRaduis = 10
        otpTextField.otpFilledBorderColor = .white
        otpTextField.configure(with: 6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        resentCodeLbl.isUserInteractionEnabled = true
        resentCodeLbl.addGestureRecognizer(tap)
        
        otpSigninAction.setOnClickListener {
            
            if self.otpString.count == 6 {
                Global.addLoading(view: self.view)
                self.apiCallOTPVerification(user_id: self.userID, mobile_No: self.phoneNumber, otp: self.otpString)
            }else{
                Global.alertLikeToast(viewController: self, message: "You code is not correct")
            }
        }
        
        if !phoneNumber.isEmpty {
            
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Raleway-Medium", size:  15.0), NSAttributedString.Key.foregroundColor : UIColor.white]

            let attrs2 = [NSAttributedString.Key.font :UIFont(name: "Raleway-Bold", size:  15.0), NSAttributedString.Key.foregroundColor : UIColor.white]

                let attributedString1 = NSMutableAttributedString(string:"\(otpdisplay1)", attributes:attrs1)
            let attributedString2 = NSMutableAttributedString(string:"\(otpdisplay2)", attributes:attrs1)


            let attributedString3 = NSMutableAttributedString(string:"\(self.starifyNumber(number: self.phoneNumber)).", attributes:attrs2)

                attributedString1.append(attributedString3)
                attributedString1.append(attributedString2)
                self.numberDisplayOutlet.attributedText = attributedString1
        }
    }
    
    func starifyNumber(number: String) -> String {
            let intLetters = number.prefix(3)
            let endLetters = number.suffix(2)
            let numberOfStars = number.count - (intLetters.count + endLetters.count)
            var starString = ""
            for _ in 1...numberOfStars {
                starString += "*"
            }
            let finalNumberToShow: String = intLetters + starString + endLetters
            return finalNumberToShow
        }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            print("tap working")
            
            Global.addLoading(view: self.view)
            self.apiCallResendOTPVerification(user_id: userID, mobile_No: phoneNumber)
        }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func apiCallResendOTPVerification(user_id: Int, mobile_No:String) {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.send_otp)")
        
        let param = [
            "phone_number": "\(mobile_No)",
            "mode": "live",
            "email":"\(self.email)",
            "action":"\(self.action)"
        ] as [String : Any]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
          
            .responseJSON { response in
                Global.removeLoading(view: self.view)
                
                print(response)

                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.result as? [String:Any] {
                        Global.alertLikeToast(viewController: self, message: "\(error.description)")
                    }else{
                        Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                    }
                }else  if response.response?.statusCode == 200 {
                    
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "OTP has been sent to mobile successfully")
                }else{
                    Global.removeLoading(view: self.view)

                    Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                }
            }
    }
    
    
    func apiCallOTPVerification(user_id: Int, mobile_No:String, otp: String) {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.verify_otp)")
        
        let param = [
            "phone_number": "\(mobile_No)",
            "otp": "\(otp)"
        ] as [String : Any]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post , parameters: param)
          
            .responseJSON { response in
                Global.removeLoading(view: self.view)
                
                print(response)

                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.result as? [String:Any] {
                        Global.alertLikeToast(viewController: self, message: "\(error.description)")
                    }else{
                        Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                    }
                }else  if response.response?.statusCode == 200 {
                    
                    switch response.result {
                    case .success(let value):
                        
                        if let json = value as? [String:Any] {
                                
                            
                                if let data = json["data"] as? [String:Any] {
                                    
                                    self.userID = data["ID"] as? Int ?? 0
                                    if let name = data["display_name"] as? String {
                                        DazzleUserdefault.setUserNameAfterLogin(val: name)
                                    }
                                }
                                
                                if self.userID != 0 {
                                    Global.removeLoading(view: self.view)
                                    
                                    DazzleUserdefault.setUserIDAfterLogin(val: self.userID )
                                    DazzleUserdefault.setIsLoggedIn(val: true)
                                    
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                                    self.navigationController?.pushViewController(home, animated: true)
                                }else{
                                    Global.removeLoading(view: self.view)
                                    Global.alertLikeToast(viewController: self, message: "Something went wrong")

                                }
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                    
                }else{
                    Global.removeLoading(view: self.view)

                    Global.alertLikeToast(viewController: self, message: "This phone number is not associated with your account. Use exact same number")
                }
            }
    }
    
}

extension OTPVC: AEOTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        print(code)
        self.otpString = code
    }
}
