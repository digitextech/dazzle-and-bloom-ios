//
//  BookmarkVC.swift
//  DAZZLE AND BLOOM
//
//  Created by Macbook on 16/10/22.
//

import UIKit
import Alamofire


class BookmarkVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    var wishlistItems = [ProductsListRes]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        collectionView.register(UINib(nibName: "BookmarkCell", bundle: nil), forCellWithReuseIdentifier: BookmarkCell.reuseIdentifer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        statusBarColorChange()
        
        
        self.wishlistItems.removeAll()
        self.wishlistItems = Global.isWishlistObjectFetched()
        if self.wishlistItems.count == 0 {
            Global.alertLikeToast(viewController: self, message: "Your wishlist is empty")
        }
        collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension BookmarkVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.wishlistItems.count > 0 ?  self.wishlistItems.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCell.reuseIdentifer, for: indexPath) as! BookmarkCell
        
        if self.wishlistItems.count > 0 {
            cell.imageIcon.layer.cornerRadius = 16
            cell.titleNameLbl.text = self.wishlistItems[indexPath.item].title
            cell.priceLbl.text = self.wishlistItems[indexPath.item].price
            
            if self.wishlistItems[indexPath.item].images.count > 0 {
                
                let imageURlString = self.wishlistItems[indexPath.item].images[0]
                if imageURlString != "" {
                    cell.imageIcon.downloadImage(url: URL(string: "\(imageURlString)")!, contentModeUIImage: .scaleAspectFit)
                }else{
                    cell.imageIcon.image =  UIImage(named: "noPhoto")
                }
            }else{
                cell.imageIcon.image =  UIImage(named: "noPhoto")
            }
            
            cell.delete.setOnClickListener {
                self.deleteWishlistItems(indexPath.item)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "ProductDetailsVC") as?  ProductDetailsVC
        vc?.title_item = self.wishlistItems[indexPath.row].title
        vc?.price_item = self.wishlistItems[indexPath.row].price
        vc?.description_item = self.wishlistItems[indexPath.row].content
        vc?.pic_item = self.wishlistItems[indexPath.row].images
        vc?.objectOfitem = self.wishlistItems[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func deleteWishlistItems(_ sender: Int) {
       
       self.wishlistItems.remove(at: sender)
       if Global.isWishlistObjectSaved(object: self.wishlistItems) {
           self.wishlistItemsLoaded()
           self.collectionView.reloadData()
       }
   }
    
     func wishlistItemsLoaded() {
        self.wishlistItems.removeAll()
        self.wishlistItems = Global.isWishlistObjectFetched()
        if self.wishlistItems.count == 0 {
            Global.alertLikeToast(viewController: self, message: "Your wishlist is empty")
        }
        collectionView.reloadData()
    }

}
