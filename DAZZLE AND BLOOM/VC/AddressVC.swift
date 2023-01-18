//
//  AddressVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 15/10/22.
//


import UIKit
import Alamofire


class AddressVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
   
   // var addtoAddress = [Constant.Address]()
    var total = Double()
    var grandTotal = Double()
    var isFlatRate = Bool()
    
    let arrImages = ["Image1"]
    let categoryHeaderId = "categoryHeaderId"
    let headerId = "CategoryHeaderView"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        collectionView.register(UINib(nibName: "AddressDetailsCell", bundle: nil), forCellWithReuseIdentifier: AddressDetailsCell.reuseIdentifer)
                
        collectionView.register(UINib(nibName: "CategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderView")

        collectionView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        statusBarColorChange()
        //self.apiCallAddressDetails()

    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension AddressVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressDetailsCell.reuseIdentifer, for: indexPath) as! AddressDetailsCell
        
        cell.addressDetailsLbl.text = "Not found. Please update your address."

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header : CategoryHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CategoryHeaderView
        
        if indexPath.section == 0{
            header.leftTitleLbl.text = "Billing Details"
        }else{
            header.leftTitleLbl.text = "Shipping Details"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 55)
    }

}
