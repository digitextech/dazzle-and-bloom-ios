//
//  Switcher.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 04/12/22.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = DazzleUserdefault.getIsLoggedIn()
        var rootVC : UIViewController
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabVC") as! TabVC
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialWlcmVC") as! InitialWlcmVC
        }
        let sharedSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let nav1 = UINavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [rootVC]
        sharedSceneDelegate?.window?.rootViewController = nav1
        sharedSceneDelegate?.window?.makeKeyAndVisible()
    }
}

