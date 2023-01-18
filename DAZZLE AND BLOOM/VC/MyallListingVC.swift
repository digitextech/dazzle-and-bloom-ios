//
//  MyallListingVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 12/12/22.
//

import UIKit
import Alamofire
import DropDown

class MyallListingVC: UIViewController {
    
    @IBOutlet weak var totalCountLbl: UILabel!
    @IBOutlet weak var pendingCountLbl: UILabel!
    @IBOutlet weak var activeCountLbl: UILabel!
    @IBOutlet weak var expireCountLbl: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var totalListViewOutlet: NativeCardView!
    @IBOutlet weak var activeListViewOutlet: NativeCardView!
    @IBOutlet weak var expiredListView: NativeCardView!
    @IBOutlet weak var pendingListView: NativeCardView!
    @IBOutlet weak var listColViewOutlet: UICollectionView!
    @IBOutlet weak var addNewList: NativeCardView!
    @IBOutlet weak var yourAllListing: NativeCardView!
    
    var listofAllArray = [ProductsListRes]()
    var isLoading:Bool = false
    var pageNo = Int()
    var totalCount = Int()
    var totalPages = Int()
    var pageNumber = Int()
    let headerId = "headerId"
    let categoryHeaderId = "categoryHeaderId"
    var statusOfList = "any"
    
    var perPage = Int()
    var category_id = Int()
    var order_display = String()
    var order_by = String()
    var search = String()
    
    var listing_Tags_edit = [Int]()
    var listing_type_edit = Int()
    var listing_imageID_edit = [Int]()
    var listing_imageName_edit = [String]()
    var listing_videoID_edit = [Int]()
    var listing_tagID_edit = [Int]()
    var listing_tagName_edit = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.order_display = "ASC"
        self.order_by = "title"
        self.search = ""
        self.perPage = 20
        
        self.listofAllArray.removeAll()
        self.listColViewOutlet.reloadData()
        
        self.pageNumber = 1
        
        listColViewOutlet.register(UINib(nibName: "AllListingItemCell", bundle: nil), forCellWithReuseIdentifier: AllListingItemCell.reuseIdentifer)
        
        listColViewOutlet.collectionViewLayout = createCompositionalLayout()
        listColViewOutlet.reloadData()
        
        //Notification center
        NotificationCenter.default.addObserver(self, selector: #selector(editprofile(notification:)), name: Notification.Name("editprofile"), object: nil)
        
        Global.addLoading(view: self.view)
        
        let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.status_list)\(DazzleUserdefault.getUserIDAfterLogin())")!
        
        self.apiCallallStatusList(url: status_urlstr)
        
        
        self.addNewList.setOnClickListener {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyBoard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
            home.indexSelect = 2
            self.navigationController?.pushViewController(home, animated: true)
        }
        
        
        self.totalListViewOutlet.setOnClickListener {
            
            Global.addLoading(view: self.view)
            
            self.statusOfList = "any"
            
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallallProductList(url: urlstr, isLoadMore: false)
        }
        
        self.yourAllListing.setOnClickListener {
            
            Global.addLoading(view: self.view)
            
            self.statusOfList = "any"
            
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallallProductList(url: urlstr, isLoadMore: false)
        }
        
        
        self.activeListViewOutlet.setOnClickListener {
            
            Global.addLoading(view: self.view)
            
            self.statusOfList = "publish"
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallallProductList(url: urlstr, isLoadMore: false)
        }
        
        self.pendingListView.setOnClickListener {
            
            Global.addLoading(view: self.view)
            
            self.statusOfList = "pending"
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallallProductList(url: urlstr, isLoadMore: false)
            
        }
        
        self.expiredListView.setOnClickListener {
            
            Global.addLoading(view: self.view)
            
            self.statusOfList = "trash"
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallallProductList(url: urlstr, isLoadMore: false)
            
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            return self.firstLayoutSection(height: 0.4)
        }
    }
    
    private func firstLayoutSection(height: CGFloat) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(height))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 5
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 0
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), elementKind: categoryHeaderId, alignment: .top)
        ]
        
        return section
    }
    
    
    func apiCallallStatusList(url: URL)  {
        
        AF.request(url , method: .get)
            .responseJSON { response in
                
                // Global.removeLoading(view: self.view)
                
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        
                        if let mess = json["message"] as? [String:Any] {
                            
                            let publish = mess["publish"] as? Int
                            let pending = mess["pending"] as? Int
                            let reviewed = mess["reviewed"] as? Int
                            let temp = mess["temp"] as? Int
                            let all = mess["all"] as? Int
                            let trash = mess["trash"] as? Int
                            
                            self.totalCountLbl.text = "\(all ?? 0)"
                            self.activeCountLbl.text = "\(publish ?? 0)"
                            self.pendingCountLbl.text = "\(pending ?? 0)"
                            self.expireCountLbl.text = "\(trash ?? 0)"
                            
                            
                        }
                        
                        // self.totalCountLbl.text = "\(self.listofAllArray.count) Dresses"
                        self.listColViewOutlet.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
                
                let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
                self.apiCallallProductList(url: urlstr, isLoadMore: false)
                
            }
    }
    
    
    func apiCallallProductList(url: URL, isLoadMore: Bool)  {
        
        let param = [
            
            "paged": self.pageNumber,
            "per_page": self.perPage,
            "order":"\(order_display)",
            "order_by":"\(order_by)",
            "uid":"\(DazzleUserdefault.getUserIDAfterLogin())",
            "status":"\(self.statusOfList)"
        ] as [String:Any]
        
        print(param)
        
        print(url)
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { response in
                
                Global.removeLoading(view: self.view)
                
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if !isLoadMore {
                            self.listofAllArray.removeAll()
                            self.listColViewOutlet.reloadData()
                        }
                        
                        self.isLoading = false
                        
                        if let headers_total = json["total_listing"]  as? Int {
                            self.totalCount = Int(headers_total)
                        }
                        
                        if let headers_totalPage = json["total_pages"]  as? Int {
                            self.totalPages = Int(headers_totalPage)
                        }
                        
                        if let mess = json["listings"] as? [[String:Any]] {
                            
                            print(mess)
                            if mess.count > 0 {
                                
                                for item in mess {
                                    
                                    let name = item["title"] as? String
                                    let price = item["price"] as? String
                                    let id = item["ID"] as? Int
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
                                    let website_link = item["website_link"] as? String
                                    let website = item["website"] as? String
                                    let contact_email = item["contact_email"] as? String
                                    let uid = item["uid"] as? String
                                    let attached_video_id = item["attached_video_id"] as? String
                                    let post_excerpt = item["post_excerpt"] as? String
                                    
                                    self.listing_imageID_edit = item["images_attachment_id"] as? [Int] ?? []
                                    self.listing_imageName_edit = images ?? []
                                    
                                    self.listing_type_edit = Int(listing_type ?? "0") ?? 0
                                    
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
                                    

                                    
                                    let itemObj = ProductsListRes(title: name ?? "",content: content ?? "",price: price ?? "",location: location ?? "",category: categories ?? "",status: status ?? "",images: images ?? [], id: id ?? 0, address_line_1: address_line_1 ?? "", address_line_2: address_line_2 ?? "", zip : zip ?? "",linkedin_link: linkedin_link ?? "", instagram_link: instagram_link ?? "", youtube_link: youtube_link ?? "", twitter_link: twitter_link ?? "", facebook_link: facebook_link ?? "",additional_info: additional_info ?? "",phone_number: phone_number ?? "", whatsapp_number: whatsapp_number ?? "", listing_type: listing_type ?? "", website: website ?? "", contact_email: contact_email ?? "", attached_video_id: attached_video_id ?? "", uid: uid ?? "", tags: t_name , tags_id: t_id ,post_excerpt: post_excerpt ?? "",website_link: website_link ?? "", images_id: self.listing_imageID_edit)
                                    
                                    self.listofAllArray.append(itemObj)
                                    
                                }
                                Global.removeLoading(view: self.view)
                                self.listColViewOutlet.reloadData()
                                
                            }else{
                                Global.removeLoading(view: self.view)
                            }
                        }else{
                            Global.removeLoading(view: self.view)
                        }
                        
                        self.listColViewOutlet.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    @objc func editprofile(notification:Notification) {
        if ((notification.userInfo?["params"] as? [String:AnyObject]) != nil) == true {
            if let params = notification.userInfo?["type"] as? [String:Any]{
                
                if params["url"] as! String == "Note" {
                    if let params = notification.userInfo?["params"] as? [String:Any]{
                        Global.addLoading(view: self.view)
                        
                        let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.noteToadmin_listing)")!
                        self.apiCallForListDelete(url: status_urlstr, param: params)
                    }
                }else  if params["url"] as! String == "Delete" {
                    if let params = notification.userInfo?["params"] as? [String:Any]{
                        Global.addLoading(view: self.view)
                        
                        let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.delete_listing)")!
                        self.apiCallForListDelete(url: status_urlstr, param: params)
                    }
                }
            }
            
            
        }
    }
    
    func apiCallForListDelete(url: URL, param: [String:Any])  {
        
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
                        
                        displayMsg = json["message"] as? String ?? ""
                    }
                case .failure(let error):
                    print(error)
                    displayMsg = error.localizedDescription
                }
                
                if response.response?.statusCode == 200 {
                    Global.alertLikeToast(viewController: self, message: "\(displayMsg)")
                    
                    Global.addLoading(view: self.view)
                    
                    let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.status_list)\(DazzleUserdefault.getUserIDAfterLogin())")!
                    
                    self.apiCallallStatusList(url: status_urlstr)
                }else{
                    Global.alertLikeToast(viewController: self, message: "\(displayMsg)")
                }
            }
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension MyallListingVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.listofAllArray.count > 0 ? self.listofAllArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = listColViewOutlet.dequeueReusableCell(withReuseIdentifier: AllListingItemCell.reuseIdentifer, for: indexPath) as! AllListingItemCell
        
        if self.listofAllArray.count > 0  {
            cell.titleNameLbl.text = self.listofAllArray[indexPath.item].title
            cell.listStatus.text = self.listofAllArray[indexPath.item].status.capitalizingFirstLetter()
            cell.listingID.text = "\(self.listofAllArray[indexPath.item].id)"
            
            // if self.listofAllArray[indexPath.item].status == "active" {
            cell.explbl.text = "No Expiry"
            //            }else{
            //                cell.explbl.text = "Expired"
            //            }
            
            if self.listofAllArray[indexPath.item].status.capitalizingFirstLetter() == "Pending"{
                cell.listStackView.isHidden = true
            }else{
                cell.listStackView.isHidden = false
            }
            
            if self.listofAllArray[indexPath.item].images.count > 0 {
                
                let imageURlString = self.listofAllArray[indexPath.item].images[0]
                if imageURlString != "" {
                    cell.profileIcon.downloadImage(url: URL(string: "\(imageURlString)")!, contentModeUIImage: .scaleAspectFit)
                }else{
                    cell.profileIcon.image =  UIImage(named: "noPhoto")
                }
            }else{
                cell.profileIcon.image =  UIImage(named: "noPhoto")
            }
            
            cell.edit_listingViewOutlet.tag = indexPath.row
            cell.delete_listingViewOutlet.tag = indexPath.row
            cell.publish_listingViewOutlet.tag = indexPath.row
            cell.note_listingViewOutlet.tag = indexPath.row
            
            cell.edit_listingViewOutlet.setOnClickListener {
                let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
                let vc = stortboard.instantiateViewController(identifier: "NewlistingVC") as?  NewCreatelistingVC
                vc?.listing_arry[0].children[0].titleValue = self.listofAllArray[indexPath.item].title
                vc?.listing_arry[0].children[1].titleValue = self.listofAllArray[indexPath.item].tags.joined(separator: ",")
                vc?.listing_arry[0].children[2].titleValue = self.listofAllArray[indexPath.item].category
                
                vc?.listing_arry[1].children[0].titleValue = self.listofAllArray[indexPath.item].phone_number
                vc?.listing_arry[1].children[1].titleValue = self.listofAllArray[indexPath.item].whatsapp_number
                vc?.listing_arry[1].children[2].titleValue = ""
                vc?.listing_arry[1].children[3].titleValue = self.listofAllArray[indexPath.item].price
                
                vc?.listing_arry[2].children[0].titleValue = ""
                vc?.listing_arry[2].children[1].titleValue = self.listofAllArray[indexPath.item].content.htmlToString
                
                vc?.listing_arry[3].children[0].titleValue = ""
                vc?.urlString = self.listofAllArray[indexPath.item].attached_video_id
                
                vc?.listing_arry[4].children[0].titleValue = self.listofAllArray[indexPath.item].location
                vc?.listing_arry[4].children[1].titleValue = self.listofAllArray[indexPath.item].address_line_1
                vc?.listing_arry[4].children[2].titleValue = self.listofAllArray[indexPath.item].address_line_2
                vc?.listing_arry[4].children[3].titleValue = self.listofAllArray[indexPath.item].zip
                vc?.listing_arry[4].children[4].titleValue = self.listofAllArray[indexPath.item].additional_info
                
                vc?.facebook_link = self.listofAllArray[indexPath.item].facebook_link
                vc?.twitter_link = self.listofAllArray[indexPath.item].twitter_link
                vc?.youtube_link = self.listofAllArray[indexPath.item].youtube_link
                vc?.instagram_link = self.listofAllArray[indexPath.item].instagram_link
                
                if self.listofAllArray[indexPath.item].images.count > 0 {
                    vc?.listing_imageName_edit = self.listofAllArray[indexPath.item].images.map {$0}
                }
                                
                if self.listofAllArray[indexPath.item].images_id.count > 0 {
                    vc?.listing_imageID_edit = self.listofAllArray[indexPath.item].images_id.map { Int(exactly: $0)!}
                }
                vc?.listing_Tags_edit = self.listing_Tags_edit
                vc?.listing_type_edit = Int(self.listofAllArray[indexPath.item].listing_type ) ?? 0
                vc?.listingID = self.listofAllArray[indexPath.item].id
                vc?.isComingForEdit = true
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            cell.delete_listingViewOutlet.setOnClickListener {
               
                
                /* if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC {
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.definesPresentationContext = true
                    vc.titleInput = "Why you are deleting?"
                    vc.btnTitleInput = "Delete"
                    vc.isComingFor = "Delete"
                    vc.listingID = "\(self.listofAllArray[indexPath.row].id)"
                    SceneDelegate.delApp.window?.rootViewController?.present(vc, animated: true, completion: nil)
                } */
                
                let dropDown = DropDown()

                dropDown.anchorView = cell.delete_listingViewOutlet
                dropDown.direction = .any
                dropDown.dataSource = ["I have sold my item", "I no longer wish to sell"]
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                  print("Selected item: \(item) at index: \(index)")
                    
                    let params =  [
                        "uid": DazzleUserdefault.getUserIDAfterLogin(),
                        "listing_id": self.listofAllArray[indexPath.item].id,
                       "reason": "\(item)"
                       ]
                    
                    Global.addLoading(view: self.view)
                    
                    let status_urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.delete_listing)")!
                    self.apiCallForListDelete(url: status_urlstr, param: params)
                }
                dropDown.show()
            }
            
            cell.note_listingViewOutlet.setOnClickListener {
                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupVC") as? PopupVC {
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.definesPresentationContext = true
                    vc.titleInput = "Give note to admin"
                    vc.btnTitleInput = "Send"
                    vc.isComingFor = "Note"
                    vc.listingID = self.listofAllArray[indexPath.row].id
                    SceneDelegate.delApp.window?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let value = calculatePercentage(value: listofAllArray.count,percentageVal: 70)
        
        if indexPath.row == value  || indexPath.row == listofAllArray.count - 1 {
            if self.isLoading == false{
                if self.totalPages > self.pageNumber {
                    print(value)
                    self.isLoading = true
                    self.pageNumber = self.pageNumber + 1
                    DispatchQueue.main.async {
                        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")
                        
                        self.apiCallallProductList(url: urlstr!, isLoadMore: true)
                    }
                }
            }
        }
    }
    
    public func calculatePercentage(value:Int,percentageVal:Int)->Int{
        let val = value * percentageVal
        return val / 100
    }
    
}
