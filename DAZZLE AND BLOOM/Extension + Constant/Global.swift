//
//  Global.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 24/11/22.

import Foundation
import UIKit
import SystemConfiguration
import NVActivityIndicatorView

var backView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))

class Global: NSObject {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    class func showAlert(viewController: UIViewController, title: String? = Constant.AppName, message: String?, actionBlock: (() -> Void)?) {
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { action in
            if let actionBlock = actionBlock {
                actionBlock()
            }
        }
        
        self.showAlert(viewController: viewController, title: title, message: message, alertActions: [okAction])
        
    }
    
    class func showAlertFor2Options(viewController: UIViewController, title: String? = Constant.AppName, message: String?, cancelBlock: (() -> Void)?, syncBlock: (() -> Void)?) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { action in
            if let cancelBlock = cancelBlock {
                cancelBlock()
            }
        }
        let syncAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { action in
            if let syncBlock = syncBlock {
                syncBlock()
            }
        }
        
        self.showAlert(viewController: viewController, title: title, message: message, alertActions: [cancelAction,syncAction])
        
    }
    
    
    class func showAlert(viewController: UIViewController, title: String?, message: String?, alertActions:[UIAlertAction]) {
        
        DispatchQueue.main.async {
            if viewController.view.window != nil {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                
                for act in alertActions {
                    
                    alertController.addAction(act)
                }
                
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    class func showUnderDevAlert(viewController: UIViewController){
        self.showAlert(viewController: viewController, title: Constant.AppName, message: "This section is under developement", actionBlock: nil)
    }
    
    
    class func showAlertTouch(viewController: UIViewController, title: String?, message: String?, actionBlock: (() -> Void)?) {
        if viewController.view.window != nil {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { action in
                if let actionBlock = actionBlock {
                    actionBlock()
                }
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { action in
                if let actionBlock = actionBlock {
                    actionBlock()
                }
            }
            alertController.addAction(okAction)
            alertController.addAction(noAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func alertLikeToast(viewController: UIViewController, message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        if message != "" {
            viewController.present(alert, animated: true, completion: nil)
        }
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    class func showActivityIndicatory(uiView: UIView , activityIndicator: UIActivityIndicatorView) {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.medium
        uiView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    class func removeActivityIndicatory(uiView: UIView, activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //MARK: Showing loader
    class func addLoading(view:UIView) -> Void {
        backView = UIView(frame: view.frame)
        let dimAlphaGrayColor =  UIColor.lightGray.withAlphaComponent(0.5)
        backView.backgroundColor = dimAlphaGrayColor
        
        let xAxis = backView.center.x
        let yAxis = backView.center.y
        
        let frame = CGRect(x: (xAxis - 20), y: (yAxis - 50), width: 45, height: 45)

        let loadingView = NVActivityIndicatorView(frame: frame, type: .lineScaleParty  , color: UIColor(named: "appBGColor"), padding: 0)
        loadingView.startAnimating()
        backView.addSubview(loadingView)
        view.addSubview(backView)
        view.isUserInteractionEnabled = false
    }
    class func removeLoading(view:UIView) -> Void {
        backView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidDomain(testStr:String) -> Bool {
        // // print("validate calendar: \(testStr)")
        let domainRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let domainTest = NSPredicate(format:"SELF MATCHES %@", domainRegEx)
        return domainTest.evaluate(with: testStr)
    }
    
    class func isCartObjectSaved(object: [Constant.AddToCart]) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedCartInfo")
            return true
        }else{
            return false
        }
    }
    
    class func isCartObjectFetched() -> [Constant.AddToCart] {
        
        let defaults = UserDefaults.standard

        if let savedCartInfo = defaults.object(forKey: "SavedCartInfo") as? Data {
            let decoder = JSONDecoder()
            if let loadedCartInfo = try? decoder.decode([Constant.AddToCart].self, from: savedCartInfo) {
                return loadedCartInfo
            }else{
                return []
            }
        }else{
            return []
        }
    }
    
    class func isWishlistObjectSaved(object: [ProductsListRes]) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedWishlistInfo")
            return true
        }else{
            return false
        }
    }
    
    class func isWishlistObjectFetched() -> [ProductsListRes] {
        
        let defaults = UserDefaults.standard

        if let savedCartInfo = defaults.object(forKey: "SavedWishlistInfo") as? Data {
            let decoder = JSONDecoder()
            if let loadedCartInfo = try? decoder.decode([ProductsListRes].self, from: savedCartInfo) {
                return loadedCartInfo
            }else{
                return []
            }
        }else{
            return []
        }
    }
    
    class func isAddressObjectSaved(object: [Constant.Address]) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedAddressInfo")
            return true
        }else{
            return false
        }
    }
    
    class func isAddressObjectFetched() -> [Constant.Address] {
        
        let defaults = UserDefaults.standard
        if let savedCartInfo = defaults.object(forKey: "SavedAddressInfo") as? Data {
            let decoder = JSONDecoder()
            if let loadedCartInfo = try? decoder.decode([Constant.Address].self, from: savedCartInfo) {
                return loadedCartInfo
            }else{
                return []
            }
        }else{
            return []
        }
    }
    
}
extension UIView {
    
    func addShadow(radious: CGFloat, color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = radious
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func addCornerRadious(radious: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radious
    }
    
    func addBorder(borderWidth: CGFloat, color: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
}
extension String {
    func getFullyTrimmedString()->String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func getFullyTrimmedStringLength()->Int{
        return self.getFullyTrimmedString().count
    }
    
    func checkURL() -> Bool {
        guard (self.getFullyTrimmedStringLength()) > 0 else{
            return  false
        }
        
        let urlRegEx = "^http(?:s)?://(?:w{3}\\.)?(?!w{3}\\.)(?:[\\p{L}a-zA-Z0-9\\-]+\\.){1,}(?:[\\p{L}a-zA-Z]{2,})/(?:\\S*)?$"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        
        return urlTest.evaluate(with: self)
    }
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
}

extension UILabel {
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: 1.15, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UINavigationController {
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
}

