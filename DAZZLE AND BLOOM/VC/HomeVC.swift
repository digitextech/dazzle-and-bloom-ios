//
//  HomeVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.

import UIKit
import Alamofire
import ModularSidebarView
import SafariServices
import DropDown
import SafariServices


struct SideMenuValue {
    var title = String()
    var id = Int()
}

struct ProductsListRes : Codable {
    
    var title = String()
    var content = String()
    var price = String()
    var location = String()
    var category = String()
    var status = String()
    var images = [String]()
    var id = Int()
    var address_line_1 = String()
    var address_line_2 = String()
    var zip = String()
    var linkedin_link = String()
    var instagram_link = String()
    var youtube_link = String()
    var twitter_link = String()
    var facebook_link = String()
    var additional_info = String()
    var phone_number = String()
    var whatsapp_number = String()
    var listing_type = String()
    var website = String()
    var contact_email = String()
    var attached_video_id = String()
    var uid = String()
    var tags = [String]()
    var tags_id = [Int]()
    var post_excerpt = String()
    var website_link = String()
    var images_id = [Int]()
    var is_featured = Int()

}

class HomeVC: UIViewController, UITextFieldDelegate, SideMenuVCDelegate, SFSafariViewControllerDelegate {
    
    
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?
    
    //MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var sortViewOutlet: NativeCardView!
    @IBOutlet weak var filterViewOutlet: NativeCardView!
    
    var listofNewArrivalArray = [ProductsListRes]()
    var listofNewArrivalArray_backup = [ProductsListRes]()
    
    var selectedCateName = String()
    var isLoading:Bool = false
    var totalCount = Int()
    var totalPages = Int()
    var pageNumber = Int()
    let headerId = "headerId"
    let categoryHeaderId = "categoryHeaderId"
    
    var sectionOneOptionTitles = [SideMenuValue]()
    
    var sectionOneImageNames = [String]()
    var perPage = Int()
    var category_id = Int()
    var order_display = String()
    var order_by = String()
    var search = String()
    var minV = CGFloat()
    var maxV = CGFloat()
    var location = [Int]()
    
    var isForNonHome = Bool()
    
    
    @IBOutlet var sideMenuBtn: UIButton!
    @IBOutlet weak var totalCountLbl: UILabel!
    @IBOutlet weak var searchFieldOutlet: UITextField!
    
    var itISCalled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.order_display = "ASC"
        self.order_by = ""
        self.search = ""
        self.perPage = 20
        
        self.minV = 0.0
        self.maxV = 4900
        
        if  DazzleUserdefault.getFilterMaXValue() == 0 {
          
            DazzleUserdefault.setFilterMaXValue(val: 4900)
        }
        
        self.pageNumber = 1
        self.totalCountLbl.text = ""
        collectionView.register(UINib(nibName: "HomeListCell", bundle: nil), forCellWithReuseIdentifier: HomeListCell.reuseIdentifer)
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.reloadData()
        
        self.searchFieldOutlet.delegate = self
        
        sortViewOutlet.setOnClickListener {
            
            let dropDown = DropDown()
            dropDown.anchorView = self.sortViewOutlet
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.direction = .bottom
            dropDown.dataSource = ["Price(Low to High)", "Price(High to Low)", "A-Z", "Z-A"]
            dropDown.layer.cornerRadius = 5
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                
                if index == 0 {
                    self.order_by = "price"
                    self.order_display = "ASC"
                }else if index == 1 {
                    self.order_by = "price"
                    self.order_display = "DESC"
                }else if index == 2 {
                    self.order_by = "title"
                    self.order_display = "ASC"
                }else if index == 3 {
                    self.order_by = "title"
                    self.order_display = "DESC"
                }
                
                
                Global.addLoading(view: self.view)
                let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
                self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
                                
            }
            
            dropDown.show()
        }
        
        filterViewOutlet.setOnClickListener {
            if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as? FilterVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.definesPresentationContext = true
                vc.filterDelegate = self
                SceneDelegate.delApp.window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
        }
        
        Global.addLoading(view: self.view)
        self.apiCallSideMenu()
        
        itISCalled = false
                
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.totalCountLbl.text = ""
        self.isForNonHome = false
    }
    
    @IBAction func openMenuBtnAction(_ sender: UIButton) {
        
        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "SideMenuVC") as?  SideMenuVC
        vc?.modalPresentationStyle = .overCurrentContext
        vc?.delegate = self
        presentTransition = LeftToRightTransition()
        dismissTransition = RightToLeftTransition()
        vc?.transitioningDelegate = self
        self.navigationController?.present(vc!, animated: true, completion: { [weak self] in
            self?.presentTransition = nil
        })
        
    }
    
    func selectedCell(_ row: Int) {
        
        self.pageNumber = 1
        self.search = ""
        self.category_id = 0
        self.perPage = 20
        
        DazzleUserdefault.setFilterLocationValue(val: [])
        DazzleUserdefault.setFilterMaXValue(val: 4900)
        DazzleUserdefault.setFilterMinXValue(val: 0)
        
        if row == 0 {
            Global.addLoading(view: self.view)
            self.isForNonHome = false
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        }else if row == 1 {
            Global.addLoading(view: self.view)
            
            self.category_id = 603
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.isForNonHome = true
            self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        }else if row == 2 {
            Global.addLoading(view: self.view)
            self.isForNonHome = true
            self.category_id = 604
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            
            self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        }else if row == 3 {
            Global.addLoading(view: self.view)
            
            self.category_id = 606
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.isForNonHome = true

            self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        }else if row == 4 {
            Global.addLoading(view: self.view)
            self.isForNonHome = true
            self.category_id = 607
            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
            self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
            
        }else if row == 5 {
            //            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
            //            let vc = stortboard.instantiateViewController(identifier: "AboutUsVC") as?  AboutUsVC
            //            vc?.isComeFromAbout = true
            //            self.navigationController?.pushViewController(vc!, animated: true)
            
            let safariVC = SFSafariViewController(url: NSURL(string: "https://dazzleandbloom.co.uk/about-us/")! as URL)
            safariVC.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "FBEEF5")
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
            
        }else if row == 6 {
          
            let safariVC = SFSafariViewController(url: NSURL(string: "https://dazzleandbloom.co.uk/contact/")! as URL)
            safariVC.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "FBEEF5")
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
            
        }else if row == 7{
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
        }else if row == 8 {
    
            let safariVC = SFSafariViewController(url: NSURL(string: "https://www.facebook.com/DazzleandBloomuk/")! as URL)
            safariVC.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "FBEEF5")
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if !(textField.text?.isEmpty ?? false) {
            self.search = textField.text ?? ""
            self.perPage = 10000
            self.pageNumber = 1
            self.isForNonHome = true

        }else{
            self.search = ""
            self.perPage = 20
            self.pageNumber = 1
            self.isForNonHome = false

        }
        
        Global.addLoading(view: self.view)
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
        self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        
        return true
    }
    
    func apiCallSideMenu()  {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.menu)")
        
        AF.request(url! , method: .get)
            .responseJSON { response in
                // Global.removeLoading(view: self.view)
                switch response.result {
                case .success(let value):
                    if let json = value as? [[String:Any]] {
                        print(json)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
        
        print(urlstr)
        
        self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
    }
    
    func apiCallNewArrivalProductList(url: URL, isLoadMore: Bool)  {
        
        let param = [
            
            "paged": self.pageNumber,
            "category_id":self.category_id,
            "per_page": self.perPage,
            "order":"\(order_display)",
            "order_by":"\(order_by)",
            "search":"\(self.search)",
            "min_amount": DazzleUserdefault.getFilterMinXValue(),
            "max_amount": DazzleUserdefault.getFilterMaXValue(),
            "location": DazzleUserdefault.getFilterLocationValue(),
            
        ] as [String:Any]
        
        print(param)
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { response in
                
                Global.removeLoading(view: self.view)
                
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if !isLoadMore {
                            self.listofNewArrivalArray.removeAll()
                            self.collectionView.reloadData()
                        }
                        
                        self.isLoading = false
                        
                        if let headers_total = json["total_listing"]  as? Int {
                            self.totalCount = Int(headers_total)
                        }
                        
                        if let headers_totalPage = json["total_pages"]  as? Int {
                            self.totalPages = Int(headers_totalPage)
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
                                    
                                    let itemObj = ProductsListRes(title: name ?? "",content: content ?? "",price: price ?? "",location: location ?? "",category: categories ?? "",status: status ?? "",images: images ?? [], id: id ?? 0, address_line_1: address_line_1 ?? "", address_line_2: address_line_2 ?? "", zip : zip ?? "",linkedin_link: linkedin_link ?? "", instagram_link: instagram_link ?? "", youtube_link: youtube_link ?? "", twitter_link: twitter_link ?? "", facebook_link: facebook_link ?? "",additional_info: additional_info ?? "",phone_number: phone_number ?? "N/A", whatsapp_number: whatsapp_number ?? "", listing_type: listing_type ?? "", website: website ?? "", contact_email: contact_email ?? "", attached_video_id: attached_video_id ?? "", uid: uid ?? "", tags: t_name ,tags_id: t_id ,post_excerpt: post_excerpt ?? "",website_link: website_link ?? "",is_featured: isFeatured ?? 0)
                                    
                                    self.listofNewArrivalArray.append(itemObj)
                                }
                                Global.removeLoading(view: self.view)
                                self.collectionView.reloadData()
                                
                            }else{
                                Global.removeLoading(view: self.view)
                                Global.showAlert(viewController: self, message: "No record found") {
                                    //
                                }
                            }
                        }else{
                            Global.removeLoading(view: self.view)
                            Global.showAlert(viewController: self, message: "No record found") {
                                //
                            }
                        }
                        
                        if  self.isForNonHome && self.listofNewArrivalArray.count > 0{
                            
                            if self.search.isEmpty {
                                self.totalCountLbl.text = "Showing \(self.listofNewArrivalArray.count) of \(self.totalCount)"
                            }else{
                                self.totalCountLbl.text = "Showing \(self.totalCount) results for \"\(self.search)\""
                            }
                        }else if  self.isForNonHome && self.listofNewArrivalArray.count == 0{
                            
                            if self.search.isEmpty {
                                self.totalCountLbl.text = "No results found"
                            }else{
                                self.totalCountLbl.text = "No results found for \"\(self.search)\""
                            }
                        }else{
                            self.totalCountLbl.text = ""
                        }

                        //self.isForNonHome = false
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    Global.showAlert(viewController: self, message: "\(error.localizedDescription)") {
                        //
                    }
                }
            }
    }
    
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
            case 0: return self.fourthLayoutSection(isSectionDisplayed: false)
            default:
                return self.fourthLayoutSection(isSectionDisplayed: false)
            }
        }
    }
    
    
    private func fourthLayoutSection(isSectionDisplayed: Bool) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.9))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

//MARK: - UICollectionViewDataSource Methods
extension HomeVC: UICollectionViewDataSource, FilterDelegate {
    
    func afterClickingFilterLocation(minimum: CGFloat, maximum: CGFloat, locationItems: [Int]) {
        
        self.minV = minimum
        self.maxV = maximum
        self.location = locationItems
        
        Global.addLoading(view: self.view)
        
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")!
        self.isForNonHome = true
        self.apiCallNewArrivalProductList(url: urlstr, isLoadMore: false)
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listofNewArrivalArray.count > 0 ? self.listofNewArrivalArray.count :  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeListCell.reuseIdentifer, for: indexPath) as! HomeListCell
        
        if self.listofNewArrivalArray.count > 0  {
            cell.productTitle.text = self.listofNewArrivalArray[indexPath.item].title.capitalizingFirstLetter()
            cell.locationOutlet.text = self.listofNewArrivalArray[indexPath.item].location
            cell.categoryOutlet.text = self.listofNewArrivalArray[indexPath.item].category
            
            cell.priceOutlet.text = "\(self.listofNewArrivalArray[indexPath.item].price)"
            
            if self.listofNewArrivalArray[indexPath.item].is_featured == 1 {
                cell.featured_icon.isHidden = true // as client request
            }else{
                cell.featured_icon.isHidden = true
            }
            
            if self.listofNewArrivalArray[indexPath.item].images.count > 0 {
                
                let imageURlString = self.listofNewArrivalArray[indexPath.item].images[0]
                if imageURlString != "" {
                    cell.imageOutlet.downloadImage(url: URL(string: "\(imageURlString)")!, contentModeUIImage: .scaleAspectFit)
                }else{
                    cell.imageOutlet.image =  UIImage(named: "noPhoto")
                }
            }else{
                cell.imageOutlet.image =  UIImage(named: "noPhoto")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let value = calculatePercentage(value: listofNewArrivalArray.count,percentageVal: 70)
        
        if indexPath.row == value  || indexPath.row == listofNewArrivalArray.count - 1 {
            if self.isLoading == false{
                if self.totalPages > self.pageNumber {
                    print(value)
                    self.isLoading = true
                    self.pageNumber = self.pageNumber + 1
                    DispatchQueue.main.async {
                        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.newListing)")
                        
                        self.apiCallNewArrivalProductList(url: urlstr!, isLoadMore: true)
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

//MARK: - UICollectionViewDataSource Methods
extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "ProductDetailsVC") as?  ProductDetailsVC
        vc?.title_item = self.listofNewArrivalArray[indexPath.row].title
        vc?.price_item = self.listofNewArrivalArray[indexPath.row].price
        vc?.description_item = self.listofNewArrivalArray[indexPath.row].content
        vc?.pic_item.removeAll()
        vc?.pic_item = self.listofNewArrivalArray[indexPath.row].images
        vc?.objectOfitem = self.listofNewArrivalArray[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension HomeVC: UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
