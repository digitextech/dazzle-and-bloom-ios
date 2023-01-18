//
//  ListingTypeVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit

class ListingTypeVC: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionOfSubmitButton(_ sender: UIButton) {
        
        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "ListingStartedVC") as?  ListingStartedVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
