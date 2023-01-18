//
//  ProductDetailsVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit
import Alamofire

class ProductDetailsVC: UIViewController {
    
    @IBOutlet weak var productDetailsCol: UICollectionView!
    @IBOutlet weak var contactSellerView: NativeCardView!
    @IBOutlet weak var addFabview: NativeCardView!
    @IBOutlet weak var profileAction: UIImageView!
    @IBOutlet weak var notificationAction: UIImageView!
    @IBOutlet weak var backAction: UIImageView!
    
    var title_item = String()
    var price_item = String()
    var description_item = String()
    var pic_item = [String]()
    var listofRelatedArray = [ProductsListRes]()

    var objectOfitem = ProductsListRes()
    
    //MARK: - Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailsCol.register(CategoryHeaderViewRelated.self, forSupplementaryViewOfKind: "categoryHeaderId", withReuseIdentifier: "headerId")

        productDetailsCol.register(UINib(nibName: "ItemDetailsPicCell", bundle: nil), forCellWithReuseIdentifier: ItemDetailsPicCell.reuseIdentifer)
        
        productDetailsCol.register(UINib(nibName: "ItemDetailsTitleCell", bundle: nil), forCellWithReuseIdentifier: ItemDetailsTitleCell.reuseIdentifer)
        
        productDetailsCol.register(UINib(nibName: "ItemDetailsDscCell", bundle: nil), forCellWithReuseIdentifier: ItemDetailsDscCell.reuseIdentifer)
        
        productDetailsCol.register(UINib(nibName: "HomeListCell", bundle: nil), forCellWithReuseIdentifier: HomeListCell.reuseIdentifer)
        
        //Notification center
        NotificationCenter.default.addObserver(self, selector: #selector(msgBidprofile(notification:)), name: Notification.Name("productdetailsMsgbid"), object: nil)
        
        
        productDetailsCol.collectionViewLayout = createCompositionalLayout()
        productDetailsCol.reloadData()
        
        backAction.tappable = true
        backAction.callback = {
            
            self.navigationController?.popViewController(animated: true)
        }
    
        notificationAction.isHidden = true
        
        profileAction.tappable = true
        profileAction.callback = {
            
            if  DazzleUserdefault.getUserIDAfterLogin() == 0 || DazzleUserdefault.getUserIDAfterLogin() == nil {
                
                DazzleUserdefault.setIsLoggedIn(val: false)
                DazzleUserdefault.setIsLoginGuest(val: false)
                Switcher.updateRootVC()
                
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                home.indexSelect = 4
                self.navigationController?.pushViewController(home, animated: true)
            }
        }
        
        self.addFabview.setOnClickListener {
           
            /*if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.definesPresentationContext = true
                vc.titleInput = "Bid Proposal"
                vc.btnTitleInput = "Send"
                vc.isComingFor = "Bid"
                SceneDelegate.delApp.window?.rootViewController?.present(vc, animated: true, completion: nil)
            } */
            
            if !self.objectOfitem.phone_number.withoutSpecialCharacters.isEmpty {
                if let url = URL(string: "tel://\(self.objectOfitem.phone_number.withoutSpecialCharacters)"),
                  UIApplication.shared.canOpenURL(url) {
                     if #available(iOS 10, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler:nil)
                      } else {
                          UIApplication.shared.openURL(url)
                      }
                  } else {
                      Global.alertLikeToast(viewController: self, message: "Device cannot place a call at this time. SIM might be removed")
                  }
            }else{
                Global.alertLikeToast(viewController: self, message: "Contact number is not valid")
            }
            
        }
        
        
        self.contactSellerView.setOnClickListener {
            
            if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.definesPresentationContext = true
                vc.titleInput = "Message to seller"
                vc.btnTitleInput = "Send"
                vc.isComingFor = "Contact"
                vc.listingID = self.objectOfitem.id
                SceneDelegate.delApp.window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
        
        Global.addLoading(view: self.view)
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.relatedlisting)")!

        self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
    }
    
    @objc func msgBidprofile(notification:Notification) {
        
        if ((notification.userInfo?["params"] as? [String:AnyObject]) != nil) == true {
            if let params = notification.userInfo?["type"] as? [String:Any]{
                
                if params["url"] as! String == "Bid" {
                    if let params = notification.userInfo?["params"] as? [String:Any]{
                        Global.addLoading(view: self.view)
                        
                        let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.send_message)")!
                        self.apiCallForMsgBid(url: status_urlstr, param: params)
                    }
                }else  if params["url"] as! String == "Contact" {
                    if let params = notification.userInfo?["params"] as? [String:Any]{
                        Global.addLoading(view: self.view)
                        
                        let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.send_message)")!
                        self.apiCallForMsgBid(url: status_urlstr, param: params)
                    }
                }
            }
            
            
        }
    }
    
    func apiCallForMsgBid(url: URL, param: [String:Any])  {
        
        print(url)
        print(param)
        
        AF.request(url , method: .post, parameters: param)
            .responseJSON { response in
                
                
                print(response)
                Global.removeLoading(view: self.view)
                
                
                var displayMsg = String()
                
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if let msg = json["message"] as? [String:Any] {
                            displayMsg = msg["messages"] as? String ?? ""
                        }
                      
                    }
                case .failure(let error):
                    print(error)
                    displayMsg = error.localizedDescription
                }
                
                Global.alertLikeToast(viewController: self, message: "\(displayMsg)")
            }
    }
    
    func apiCallNewArrivalProductList(url: URL, isLoadMore: Bool)  {
        
        let param = [
            
            "paged": 1,
            "per_page": 20,
            "order":"ASC",
            "order_by":"title",
            "id": self.objectOfitem.id
        ] as [String:Any]
        
        print(param)
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { response in
                
                Global.removeLoading(view: self.view)
                
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if !isLoadMore {
                            self.listofRelatedArray.removeAll()
                            self.productDetailsCol.reloadData()
                        }
                        
                        if let mess = json["listings"] as? [[String:Any]] {
                            if mess.count > 0 {
                                
                                for item in mess {
                                    
                                    let name = item["title"] as? String
                                    let price = item["price"] as? String
                                    let id = item["ID"] as? Int
                                    let isFeatured = item["featured"] as? Int
                                    let location = item["location"] as? String
                                    let content = item["post_content"] as? String
                                    let categories = item["categories"] as? String
                                    let images = item["images"] as? [String]
                                    let status = item["status"] as? String
                                    let listing_type = item["listing_type"] as? String
                                    let whatsapp_number = item["whatsapp_number"] as? String
                                    let phone_number = item["phone_number"] as? String
                                    let additional_info = item["additional_info"] as? String
                                    let facebook_link = item["facebook_link"] as? String
                                    let twitter_link = item["twitter_link"] as? String
                                    let youtube_link = item["youtube_link"] as? String
                                    let instagram_link = item["instagram_link"] as? String
                                    let linkedin_link = item["linkedin_link"] as? String
                                    let zip = item["zip"] as? String
                                    let address_line_2 = item["address_line_2"] as? String
                                    let address_line_1 = item["address_line_1"] as? String
                                    let post_excerpt = item["post_excerpt"] as? String
                                    let website = item["website"] as? String
                                    let contact_email = item["contact_email"] as? String
                                    let website_link = item["website_link"] as? String
                                    let uid = item["uid"] as? String
                                    let attached_video_id = item["attached_video_id"] as? String
                                    
                                    
                                    var t_id = [Int]()
                                    var t_name = [String]()
                                    
                                    if let tags = item["tags"] as? [[String:Any]] {
                                        
                                        if tags.count > 0 {
                                            
                                            for item in tags {
                                                t_name.append(item["name"] as? String ?? "")
                                                t_id.append(item["term_id"] as? Int ?? 0)
                                            }
                                        }
                                    }
                                    
                                    
                                    let itemObj = ProductsListRes(title: name ?? "",content: content ?? "",price: price ?? "",location: location ?? "",category: categories ?? "",status: status ?? "",images: images ?? [], id: id ?? 0, address_line_1: address_line_1 ?? "", address_line_2: address_line_2 ?? "", zip : zip ?? "",linkedin_link: linkedin_link ?? "", instagram_link: instagram_link ?? "", youtube_link: youtube_link ?? "", twitter_link: twitter_link ?? "", facebook_link: facebook_link ?? "",additional_info: additional_info ?? "",phone_number: phone_number ?? "N/A", whatsapp_number: whatsapp_number ?? "", listing_type: listing_type ?? "", website: website ?? "", contact_email: contact_email ?? "", attached_video_id: attached_video_id ?? "", uid: uid ?? "", tags: t_name ,tags_id: t_id,post_excerpt: post_excerpt ?? "",website_link: website_link ?? "",is_featured: isFeatured ?? 0)
                                    
                                   self.listofRelatedArray.append(itemObj)
                                }
                                Global.removeLoading(view: self.view)
                                self.productDetailsCol.reloadData()
                                
                            }else{
                                Global.removeLoading(view: self.view)
                            }
                        }else{
                            Global.removeLoading(view: self.view)
                        }
                        
                        self.productDetailsCol.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    @IBAction func submitListingAction(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
        home.indexSelect = 2
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return self.firstLayoutSection()
            }else if sectionNumber == 1 {
                return self.secondLayoutSection()
            }else if sectionNumber == 2{
                return self.thirdLayoutSection()
            }else {
                return self.fourthLayoutSection()
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 0
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 0
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func thirdLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 0
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func fourthLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.7))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 10
        let section = NSCollectionLayoutSection(group: group)
        // 2. Magic: Horizontal Scroll.
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        section.contentInsets.leading = 0
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: "categoryHeaderId", alignment: .top)
        ]
        return section
    }
}

//MARK: - UICollectionViewDataSource Methods
extension ProductDetailsVC: UICollectionViewDataSource, ButtonActionFromImageCell {
    
    func actionButtonType(type: String) {
        
        if type == "Share" {
            let webUrl = self.objectOfitem.website_link
            let shareAll = [webUrl] as [String]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }else{
            
            var addtoWishlistProducts: [ProductsListRes] = Global.isWishlistObjectFetched()
            if addtoWishlistProducts.count > 0 {
                let idExists = !addtoWishlistProducts.filter{ $0.id == self.objectOfitem.id }.isEmpty
                
                if idExists {
                    Global.alertLikeToast(viewController: self, message: "The product is already in your wishlist!")
                }else{
                    
                    addtoWishlistProducts.append(self.objectOfitem)
                    
                    if Global.isWishlistObjectSaved(object: addtoWishlistProducts){
                        Global.alertLikeToast(viewController: self, message: "The product is successfully added to wishlist")
                    }else{
                        Global.alertLikeToast(viewController: self, message: "The product is not added to wishlist")
                    }
                }
                
            }else{
                
                addtoWishlistProducts.append(self.objectOfitem)
                
                if Global.isWishlistObjectSaved(object: addtoWishlistProducts){
                    Global.alertLikeToast(viewController: self, message: "The product is successfully added to wishlist")
                }else{
                    Global.alertLikeToast(viewController: self, message: "The product is not added to wishlist")
                }
            }
            
            self.productDetailsCol.reloadData()
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if self.listofRelatedArray.count > 0 {
            return 4
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 3 {
            return self.listofRelatedArray.count > 0 ? self.listofRelatedArray.count : 0
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header : CategoryHeaderViewRelated = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! CategoryHeaderViewRelated
        
        header.label.font = UIFont.init(name: "Raleway-Bold", size: 17.0)
        header.label.text = "Similar listings"
        header.label.textColor = .black
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = productDetailsCol.dequeueReusableCell(withReuseIdentifier: ItemDetailsPicCell.reuseIdentifer, for: indexPath) as! ItemDetailsPicCell
            
            if self.pic_item.count > 0 {
                cell.initializationForSlider(objc: self.pic_item)
            }
            
            var addtoWishlistProducts: [ProductsListRes] = Global.isWishlistObjectFetched()
            if addtoWishlistProducts.count > 0 {
                let idExists = !addtoWishlistProducts.filter{ $0.id == self.objectOfitem.id }.isEmpty
                
                if idExists {
                    
                    cell.fabIcon.tintColor = UIColor(hexString: "FF3E8A")
                }else{
                    cell.fabIcon.tintColor = UIColor.white
                }
                
            }
            
            cell.delegate = self
            return cell
        }else  if indexPath.section == 1 {
            
            let cell = productDetailsCol.dequeueReusableCell(withReuseIdentifier: ItemDetailsTitleCell.reuseIdentifer, for: indexPath) as! ItemDetailsTitleCell
            
            cell.title_lbl.text = self.title_item.capitalizingFirstLetter()
            cell.priceLbl.text = "\(self.price_item)"
            cell.location.text = "\(self.objectOfitem.location)"

            return cell
        }else  if indexPath.section == 3 {
            
            let cell = productDetailsCol.dequeueReusableCell(withReuseIdentifier: HomeListCell.reuseIdentifer, for: indexPath) as! HomeListCell
            
            if self.listofRelatedArray.count > 0  {
                cell.productTitle.text = self.listofRelatedArray[indexPath.item].title.capitalizingFirstLetter()
                cell.locationOutlet.text = self.listofRelatedArray[indexPath.item].location
                cell.categoryOutlet.text = self.listofRelatedArray[indexPath.item].category

                cell.priceOutlet.text = "\(self.listofRelatedArray[indexPath.item].price)"
                
                if self.listofRelatedArray[indexPath.item].images.count > 0 {
                    
                    let imageURlString = self.listofRelatedArray[indexPath.item].images[0]
                    if imageURlString != "" {
                        cell.imageOutlet.downloadImage(url: URL(string: "\(imageURlString)")!, contentModeUIImage: .scaleAspectFit)
                    }else{
                        cell.imageOutlet.image =  UIImage(named: "noPhoto")
                    }
                }else{
                    cell.imageOutlet.image =  UIImage(named: "noPhoto")
                }
                
                if self.listofRelatedArray[indexPath.item].is_featured == 1 {
                    cell.featured_icon.isHidden = true // as client request
                }else{
                    cell.featured_icon.isHidden = true
                }
            }
            
            return cell
        }else{
            let cell = productDetailsCol.dequeueReusableCell(withReuseIdentifier: ItemDetailsDscCell.reuseIdentifer, for: indexPath) as! ItemDetailsDscCell
            
            let valueString = self.description_item.capitalizingFirstLetter().htmlToString
            
            cell.descLbl.text = "\(valueString)"
            
            return cell
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            coordinator.animate(alongsideTransition: { context in
                self.productDetailsCol.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        }
}

//MARK: - UICollectionViewDataSource Methods
extension ProductDetailsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 3 {
            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = stortboard.instantiateViewController(identifier: "ProductDetailsVC") as?  ProductDetailsVC
            vc?.title_item = self.listofRelatedArray[indexPath.row].title
            vc?.price_item = self.listofRelatedArray[indexPath.row].price
            vc?.description_item = self.listofRelatedArray[indexPath.row].content
            vc?.pic_item = self.listofRelatedArray[indexPath.row].images
            vc?.objectOfitem = self.listofRelatedArray[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
}

extension String {
    
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: 1,
            range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}
