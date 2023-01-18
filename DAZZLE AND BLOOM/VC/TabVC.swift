//
//  TabVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 21/10/22.
//

import UIKit

class TabVC: UITabBarController {
    
    var indexSelect = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(named: "appBGColor")
        self.tabBar.unselectedItemTintColor = .black
        self.selectedIndex = indexSelect
    }

}
