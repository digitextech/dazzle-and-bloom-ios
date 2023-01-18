//
//  InitialWlcmVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 15/10/22.
//

import UIKit

class InitialWlcmVC: UIViewController {

    @IBOutlet weak var logoViewOutlet: UIImageView!
    @IBOutlet weak var goToEmailView: NativeCardView!
    @IBOutlet weak var goToPhoneView: NativeCardView!
    @IBOutlet weak var signupLbl: UILabel!
    @IBOutlet weak var skipViewOutlet: NativeCardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origImage = UIImage(named: "AppLogo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        logoViewOutlet.image = tintedImage
        logoViewOutlet.tintColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        signupLbl.isUserInteractionEnabled = true
        signupLbl.addGestureRecognizer(tap)
        
        skipViewOutlet.setOnClickListener {
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
            self.navigationController?.pushViewController(home, animated: true)
            
        }

        goToEmailView.setOnClickListener {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            home.isComingForPhone = false
            self.navigationController?.pushViewController(home, animated: true)
        }
        
        goToPhoneView.setOnClickListener {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            home.isComingForPhone = true
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}
