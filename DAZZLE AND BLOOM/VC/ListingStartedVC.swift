//
//  ListingStartedVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 28/11/22.
//

import UIKit

class ListingStartedVC: UIViewController {
    
    @IBOutlet weak var submitOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitOutlet.layer.cornerRadius = 10

        self.statusBarColorChange()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        if  DazzleUserdefault.getUserIDAfterLogin() == 0 || DazzleUserdefault.getUserIDAfterLogin() == nil {
            
            DazzleUserdefault.setIsLoggedIn(val: false)
            DazzleUserdefault.setIsLoginGuest(val: false)
            Switcher.updateRootVC()
            
        }else{
            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = stortboard.instantiateViewController(identifier: "NewlistingVC") as?  NewCreatelistingVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
