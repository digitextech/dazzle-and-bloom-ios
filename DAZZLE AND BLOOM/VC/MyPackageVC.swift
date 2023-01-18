//
//  MyPackageVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 16/10/22.
//

import UIKit
import Alamofire


class MyPackageVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        collectionView.register(UINib(nibName: "PackageDisplayCell", bundle: nil), forCellWithReuseIdentifier: PackageDisplayCell.reuseIdentifer)
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        statusBarColorChange()

    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension MyPackageVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageDisplayCell.reuseIdentifer, for: indexPath) as! PackageDisplayCell
        

        return cell
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 120)
    }

}
