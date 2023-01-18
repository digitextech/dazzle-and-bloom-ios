//
//  NewlistingVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit
import Alamofire
import DropDown
import AVFoundation

struct StaticKeyWithValue : Codable {
    var keyid : Int?
    var keyvalue : String?
}

struct UploadImageValue : Codable {
    var imgURL : String?
    var id : Int?
}

// MARK: Identifier Types
struct Parent: Hashable {
    var title: String
    var children: [Child]
}

struct Child: Hashable {
    var title: String
    var titleValue: String
    var fieldType: String
}

class NewCreatelistingVC: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var listingColView: UICollectionView!
    @IBOutlet weak var bgViewDropdown: UIVisualEffectView!
    var initialDropDownOutlet =  DropDown()
    @IBOutlet weak var submitBtn: UIButton!
    var urlString = String()
    var pickerController = UIImagePickerController()
    var imageView = UIImage()
    @IBOutlet weak var btnStackview: UIStackView!
    
    @IBOutlet weak var headerLblOutlet: UILabel!
    
    var uploadImageArry = [UploadImageValue]()
    
    let headerId = "headerId"
    let categoryHeaderId = "categoryHeaderId"
    
    var cat_array = [StaticKeyWithValue]()
    var type_array = [StaticKeyWithValue]()
    var tag_array = [StaticKeyWithValue]()
    var location_array = [StaticKeyWithValue]()
    var listingID = Int()
    var currentSelectedIndex = IndexPath()
    var videoIds = [String]()
    
    var headerTitle = String()
    var isComingForEdit = Bool()
    var btnTitle = String()
    
    var linkedin_link = String()
    var instagram_link = String()
    var youtube_link = String()
    var twitter_link = String()
    var facebook_link = String()
    
    var listing_Tags_edit = [Int]()
    var listing_Category_edit = [Int]()
    var listing_type_edit = Int()
    var listing_imageID_edit = [Int]()
    var listing_imageName_edit = [String]()
    var listing_videoID_edit = [Int]()
    var listing_tagID_edit = [Int]()
    var listing_tagName_edit = [Int]()
    
    //Child(title: "Summary", titleValue: "", fieldType: "select"),
    
    // MARK: Model objects
    var listing_arry = [
        
        Parent(title: "Details", children: [
            Child(title: "Listing Title*", titleValue: "", fieldType: "text"),
            Child(title: "Listing Tags", titleValue: "", fieldType: "select"),
            Child(title: "Categories*", titleValue: "", fieldType: "select"),
        ]),
        
        Parent(title: "Extra Details", children: [
            Child(title: "Phone*", titleValue: "", fieldType: "phone"),
            Child(title: "Whatsapp Number", titleValue: "", fieldType: "phone"),
            Child(title: "Listing Type*", titleValue: "", fieldType: "select"),
            Child(title: "Price*", titleValue: "", fieldType: "select"),
        ]),
        Parent(title: "Description Details", children: [
            Child(title: "Social Media", titleValue: "", fieldType: "select"),
            Child(title: "Description", titleValue: "", fieldType: "select")
        ]),
        Parent(title: "Media", children: [
            Child(title: "Listing images", titleValue: "", fieldType: "image"),
            Child(title: "Listing videos", titleValue: "", fieldType: "video"),
        ]),
        Parent(title: "Address", children: [
            Child(title: "Listing Location*", titleValue: "", fieldType: "selec"),
            Child(title: "Address line 1", titleValue: "", fieldType: "text"),
            Child(title: "Address line 2", titleValue: "", fieldType: "text"),
            Child(title: "Zip code", titleValue: "", fieldType: "text"),
            Child(title: "Additional info", titleValue: "", fieldType: "text"),
        ]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgViewDropdown.isHidden = true
        submitBtn.layer.cornerRadius = 10
        
        bgViewDropdown.effect = UIBlurEffect(style: .regular)
        bgViewDropdown.backgroundColor = .clear
        
        listingColView.register(UINib(nibName: "ContactEditCell", bundle: nil), forCellWithReuseIdentifier: ContactEditCell.reuseIdentifer)
        listingColView.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellWithReuseIdentifier: SocialMediaCell.reuseIdentifer)
        listingColView.register(UINib(nibName: "SummeryTxtViewCell", bundle: nil), forCellWithReuseIdentifier: SummeryTxtViewCell.reuseIdentifer)
        listingColView.register(UINib(nibName: "PhotoUploadCell", bundle: nil), forCellWithReuseIdentifier: PhotoUploadCell.reuseIdentifer)
        listingColView.register(UINib(nibName: "VideoUploadCell", bundle: nil), forCellWithReuseIdentifier: VideoUploadCell.reuseIdentifer)
        
        listingColView.register(ListCategoryHeaderView.self, forSupplementaryViewOfKind: categoryHeaderId, withReuseIdentifier: headerId)
        
        listingColView.collectionViewLayout = createCompositionalLayout()
        listingColView.reloadData()
        
        self.statusBarColorChange()
        
        if isComingForEdit {
            
            self.headerLblOutlet.text = "Edit your listing"
            self.submitBtn.setTitle("Update Your Listing", for: .normal)
            
            Global.addLoading(view: self.view)
            
            self.apiCallForGetCategory()
            
            
        }else{
            self.headerLblOutlet.text = "Create new listing"
            self.submitBtn.setTitle("Submit Your Listing", for: .normal)
            
            Global.addLoading(view: self.view)
            
            self.apiCallCreateForm()
            
        }
        
        if listing_imageName_edit.count > 0 {
            
            for item in listing_imageName_edit {
                self.uploadImageArry.append(UploadImageValue(imgURL: item,id: 0))
            }
        }
        
        if listing_imageID_edit.count > 0 {
            
            for index in 0..<listing_imageName_edit.count {
                self.uploadImageArry[index].id = listing_imageID_edit[index] ?? 0
            }
        }
        
        self.listingColView.reloadData()
    }
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 3 {
                return self.firstLayoutSection(height: 1.0)
            }else if sectionNumber == 2 {
                return self.firstLayoutSection(height: 0.6)
            }else{
                return self.firstLayoutSection(height: 0.25)
            }
        }
    }
    
    private func firstLayoutSection(height: CGFloat) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(height))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 5
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 0
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: categoryHeaderId, alignment: .top)
        ]
        
        return section
    }
    
    @IBAction func cancelDropDownAction(_ sender: UIButton) {
        self.bgViewDropdown.isHidden = true
        self.initialDropDownOutlet.hide()
    }
    
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        self.bgViewDropdown.isHidden = true
        self.initialDropDownOutlet.hide()
    }
    
    @IBAction func back_btnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createListing(_ sender: UIButton) {
        self.validateUserInput()
    }
    
    func tapUserPhoto(){
        let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
            self.openCamera()
        })
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = .camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[.originalImage] as? UIImage{
            
            let param = [
                
                "listing_id": "\(self.listingID )",
                "uid": "\(DazzleUserdefault.getUserIDAfterLogin() )"
            ] as? [String:String] ?? [:]
            
            dismiss(animated: true, completion: {
                Global.addLoading(view: self.view)
                self.uploadPhoto(media: chosenImage, params: param, fileName: "iOS_\(Date())")
            })
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated: true)
    }
    
    func validateUserInput() -> Bool {
        
        
        guard self.listing_arry[0].children[0].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Title required")
            return false
        }
        
        guard self.listing_arry[0].children[2].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Categories required")
            return false
        }
        
        guard self.listing_arry[1].children[0].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Phone number required")
            return false
        }
        
        guard self.listing_arry[1].children[2].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Listing type required")
            return false
        }
        guard self.listing_arry[1].children[3].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Price required")
            return false
        }
        guard self.listing_arry[4].children[0].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Location required")
            return false
        }
        
        if Global.isConnectedToNetwork() {
            Global.addLoading(view: self.view)
            self.apiCallCreateList()
        }else{
            Global.alertLikeToast(viewController: self, message: "Network connection required")
        }
        
        return true
    }
    
    func apiCallForGetCategory() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.get_categories)")
        
        print(url)

        AF.request(url! , method: .get)
        
            .responseDecodable(of: DynamicGetResponseModel.self, decoder: decoder) { response in
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    let dic = value
                    self.cat_array.removeAll()

                    if dic.message?.count ?? 0 > 0 {
                        
                        for item in dic.message! {
                            self.cat_array.append(StaticKeyWithValue(keyid: item.id ?? 0, keyvalue: item.name ?? ""))
                        }
                    }
                    
                    if self.cat_array.count > 0 {
                        
                        self.cat_array = self.cat_array.sorted(by: { (img0: StaticKeyWithValue, img1: StaticKeyWithValue) -> Bool in
                            return img0.keyvalue! < img1.keyvalue!
                        })
                    }
                    
                    print(self.cat_array)
                    
                }else{
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
                
            }
            .responseJSON { response in
                
                self.apiCallForGetTags()
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }
            }
    }
    
    func apiCallForGetType() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.get_types)")
        
        print(url)

        AF.request(url! , method: .get)
        
            .responseDecodable(of: DynamicGetResponseModel.self, decoder: decoder) { response in
                
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    let dic = value
                    self.type_array.removeAll()
              
                    if dic.message?.count ?? 0 > 0 {
                        
                        for item in dic.message! {
                            
                            if self.isComingForEdit {
                                if self.listing_type_edit == item.id {
                                    self.listing_arry[1].children[2].titleValue = item.name ?? ""
                                }
                            }
                            
                            self.type_array.append(StaticKeyWithValue(keyid: item.id ?? 0, keyvalue: item.name ?? ""))
                        }
                    }
                    
                    if self.type_array.count > 0 {
                        
                        self.type_array = self.type_array.sorted(by: { (img0: StaticKeyWithValue, img1: StaticKeyWithValue) -> Bool in
                            return img0.keyvalue! < img1.keyvalue!
                        })
                    }
                    
                    
                    print(self.type_array)
                    self.listingColView.reloadData()
                }else{
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
                
            }
        
            .responseJSON { response in
                
                self.apiCallForGetLocation()
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }
            }
    }
    
    func apiCallForGetTags() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.get_tags)")
        
        print(url)

        AF.request(url! , method: .get)
        
            .responseDecodable(of: DynamicGetResponseModel.self, decoder: decoder) { response in
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    let dic = value
                    self.tag_array.removeAll()
                    
                    if dic.message?.count ?? 0 > 0 {
                        
                        for item in dic.message! {
                            self.tag_array.append(StaticKeyWithValue(keyid: item.id ?? 0, keyvalue: item.name ?? ""))
                        }
                    }
                    
                    if self.tag_array.count > 0 {
                        
                        self.tag_array = self.tag_array.sorted(by: { (img0: StaticKeyWithValue, img1: StaticKeyWithValue) -> Bool in
                            return img0.keyvalue! < img1.keyvalue!
                        })
                    }
                    
                    print(self.tag_array)
                }else{
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
                
            }
            .responseJSON { response in
                self.apiCallForGetType()
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }
            }
    }
    
    func apiCallForGetLocation() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.get_locations)")
        
        print(url)

        AF.request(url! , method: .get)
        
            .responseDecodable(of: DynamicGetResponseModel.self, decoder: decoder) { response in
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    let dic = value
                    self.location_array.removeAll()
                   
                    if dic.message?.count ?? 0 > 0 {
                        
                        for item in dic.message! {
                            self.location_array.append(StaticKeyWithValue(keyid: item.id ?? 0, keyvalue: item.name ?? ""))
                        }
                    }
                    
                    if self.location_array.count > 0 {
                        
                        self.location_array = self.location_array.sorted(by: { (img0: StaticKeyWithValue, img1: StaticKeyWithValue) -> Bool in
                            return img0.keyvalue! < img1.keyvalue!
                        })
                    }
                    
                    print(self.location_array)
                }else{
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
                
            }
            .responseJSON { response in
                Global.removeLoading(view: self.view)
                
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }
            }
    }
    
    func apiCallCreateForm() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.prepare_form)")
        
        let param = ["uid":DazzleUserdefault.getUserIDAfterLogin()]
        
        AF.request(url! , method: .post, parameters: param, encoder: JSONParameterEncoder.default)
        
            .responseDecodable(of: CreateListForm.self, decoder: decoder) { response in
                
                guard let value = response.value else {
                    Global.removeLoading(view: self.view)
                    return
                }
                
                if response.response?.statusCode == 200 {
                    
                    if value.code != nil {
                        print(value.code)
                        
                        self.listingID = value.code ?? 0
                    }
                    
                }else{
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
                
            }
        
            .responseJSON { response in
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if response.error != nil {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }
                
                self.apiCallForGetCategory()
                
            }
    }
    
    
    func apiCallDeleteImage(indexOfImg: Int) {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.deleteImage)")
        
        
        let param = [
            
            "listing_id": self.listingID ,
            "uid": DazzleUserdefault.getUserIDAfterLogin() ,
            "image_id": self.uploadImageArry[indexOfImg].id ?? 0
            
        ] as! [String:Any]
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post, parameters: param, encoding: JSONEncoding.default)
        
            .responseJSON { response in
                
                    Global.removeLoading(view: self.view)
                    
                    switch response.result {
                    case .success(let value):
                        
                        self.uploadImageArry.remove(at: indexOfImg)
                        self.listingColView.reloadData()
                        
                        if let json = value as? [String:Any] {
                            
                            if let message = json["message"] as? String {
                                Global.alertLikeToast(viewController: self, message: "\(message)")
                                
                            }
                        }
                    case .failure(let error):
                        print(error)
                        Global.removeLoading(view: self.view)
                        Global.alertLikeToast(viewController: self, message: "\(error.errorDescription)")
                    }
                    
                
            }
    }
    
    
    func apiCallCreateList() {
        
        var url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.create_listing)")
        
        if isComingForEdit {
            url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.listing_update)")
        }
        
        var tagIDS = [Int]()
        if !self.listing_arry[0].children[1].titleValue.isEmpty {
            let subjectoftagArray = self.listing_arry[0].children[1].titleValue.components(separatedBy:",")
            
            if subjectoftagArray.count > 0 {
                for item in subjectoftagArray {
                    if self.tag_array.contains(where: {$0.keyvalue == item }) {
                        if let indexFound =  self.tag_array.firstIndex(where: {$0.keyvalue == item }) {
                            
                            if let value = self.tag_array[indexFound].keyid{
                                tagIDS.append(Int(value) ?? 0)
                            }
                        }
                    }
                }
            }
        }
        
        let intCityValue = self.location_array.filter( {$0.keyvalue == self.listing_arry[4].children[0].titleValue}).compactMap({ return String($0.keyid!)}).joined(separator: "")
                
        let typeValue = self.type_array.filter( {$0.keyvalue == self.listing_arry[1].children[2].titleValue}).compactMap({ return String($0.keyid!)}).joined(separator: "")
        
        
        var param = [
            
            "listing_id": self.listingID,
            "uid": DazzleUserdefault.getUserIDAfterLogin(),
            
            "post_title": "\(self.listing_arry[0].children[0].titleValue)",
            "tags": tagIDS,
            "category": self.cat_array.filter({$0.keyvalue == self.listing_arry[0].children[2].titleValue}).compactMap({ return Int($0.keyid!)}),
            
            "phone_number": "\(self.listing_arry[1].children[0].titleValue)",
            "whatsapp_number": "\(self.listing_arry[1].children[1].titleValue)",
            "listing_type": Int(typeValue) ?? 0,
            "price": "\(self.listing_arry[1].children[3].titleValue.replacingOccurrences(of: "£", with: ""))",
            
            "post_content": "\(self.listing_arry[2].children[1].titleValue)",
            
            "city": Int(intCityValue) ?? 0,
        
            "address_line_1" : "\(self.listing_arry[4].children[1].titleValue)",
            "address_line_2" : "\(self.listing_arry[4].children[2].titleValue)",
            "zip_code" : "\(self.listing_arry[4].children[3].titleValue)",
            "additional_info": "\(self.listing_arry[4].children[4].titleValue)",
            
            "instagram_link": "\(self.instagram_link)",
            "youtube_link": "\(self.youtube_link)",
            "twitter_link": "\(self.twitter_link)",
            "facebook_link": "\(self.facebook_link)"
            
        ] as! [String:Any]
        
        if self.uploadImageArry.count > 0 {
            param["attached_image_id"] = self.uploadImageArry.compactMap({ return Int($0.id ?? 0)})
        }
        
        if self.videoIds.count > 0 {
            param["attached_video_id"] = self.videoIds[0]
        }
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post, parameters: param, encoding: JSONEncoding.default)
        
            .responseJSON { response in
                
                if response.response?.statusCode != 200 {
                    Global.removeLoading(view: self.view)
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }else if response.response?.statusCode == 200 {
                    Global.removeLoading(view: self.view)
                    
                    if self.isComingForEdit {
                        
                        Global.showAlert(viewController: self, message: "Listing updated successfully") {
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else{
                        
                        Global.showAlert(viewController: self, message: "Listing added successfully") {
                            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
                            let vc = stortboard.instantiateViewController(identifier: "MyallListingVC") as?  MyallListingVC
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                        }
                        
                    }
                    
                }else{
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
            } 
    }
}

//MARK: - UICollectionViewDataSource Methods
extension NewCreatelistingVC: UICollectionViewDataSource , VideoUrlDelegate, SocialMediaDelegate {
    
    
    func socialMediaTextField(textfieldValue: String, fieldTag: Int) {
        
        if fieldTag == 101 {
            self.facebook_link = textfieldValue
        }else if fieldTag == 102 {
            self.twitter_link = textfieldValue
        }else if fieldTag == 103 {
            self.youtube_link = textfieldValue
        }else if fieldTag == 104 {
            self.instagram_link = textfieldValue
        }
    }
    
    
    func valueTextField(textfieldValue: String, cellIndexPath: IndexPath) {
        
        self.urlString = textfieldValue
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.listing_arry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.listing_arry[section].children.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: SocialMediaCell.reuseIdentifer, for: indexPath) as! SocialMediaCell
            
            cell.facebooktxtField.text = self.facebook_link
            cell.twittertxtField.text = self.twitter_link
            cell.youtubetxtField.text = self.youtube_link
            cell.instragramtxtField.text = self.instagram_link
            
            cell.tableViewDelegate = self
            
            return cell
            
        }else if indexPath.section == 2 && indexPath.item == 1 {
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: SummeryTxtViewCell.reuseIdentifer, for: indexPath) as! SummeryTxtViewCell
            cell.headerTitleLbl.text = "Description"
            cell.tableViewDelegate = self
            cell.indexPath = indexPath
            cell.txtViewOutlet.text = self.listing_arry[2].children[1].titleValue
            cell.txtViewOutlet.addBorder(borderWidth: 1.0, color: .black)
            
            return cell
            
        }else if indexPath.section == 2 && indexPath.item == 2 {
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: SummeryTxtViewCell.reuseIdentifer, for: indexPath) as! SummeryTxtViewCell
            cell.headerTitleLbl.text = "Summary"
            cell.tableViewDelegate = self
            cell.indexPath = indexPath
            cell.txtViewOutlet.text = self.listing_arry[2].children[2].titleValue
            cell.txtViewOutlet.addBorder(borderWidth: 1.0, color: .black)
            return cell
            
        }else if indexPath.section == 3 && indexPath.item == 0 {
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: PhotoUploadCell.reuseIdentifer, for: indexPath) as! PhotoUploadCell
            
            cell.img1Outlet.image = nil
            cell.img2Outlet.image = nil
            cell.img3Outlet.image = nil
            cell.img4Outlet.image = nil
            cell.img5Outlet.image = nil
            cell.img6Outlet.image = nil
            cell.img7Outlet.image = nil
            cell.img8Outlet.image = nil
            
            
            cell.imageOutlet.tappable = true
            cell.imageOutlet.callback = {
                if self.uploadImageArry.count < 8 {
                    self.tapUserPhoto()
                }
            }
            
            if self.uploadImageArry.count > 0 {
                cell.img1Outlet.sd_setImage(with: URL(string: self.uploadImageArry[0].imgURL ?? "") )
                cell.img_Delete1Outlet.isHidden = false
            }else{
                cell.img_Delete1Outlet.isHidden = true
            }
            
            if self.uploadImageArry.count > 1 {
                cell.img2Outlet.sd_setImage(with: URL(string: self.uploadImageArry[1].imgURL ?? "") )
                cell.img_Delete2Outlet.isHidden = false
            }else{
                cell.img_Delete2Outlet.isHidden = true
            }
            
            
            if self.uploadImageArry.count > 2 {
                cell.img3Outlet.sd_setImage(with: URL(string: self.uploadImageArry[2].imgURL ?? "") )
                cell.img_Delete3Outlet.isHidden = false
            }else{
                cell.img_Delete3Outlet.isHidden = true
            }
            
            if self.uploadImageArry.count > 3 {
                cell.img4Outlet.sd_setImage(with: URL(string: self.uploadImageArry[3].imgURL ?? "") )
                cell.img_Delete4Outlet.isHidden = false
            }else{
                cell.img_Delete4Outlet.isHidden = true
            }
            
            if self.uploadImageArry.count > 4 {
                cell.img5Outlet.sd_setImage(with: URL(string: self.uploadImageArry[4].imgURL ?? "") )
                cell.img_Delete5Outlet.isHidden = false
            }else{
                cell.img_Delete5Outlet.isHidden = true
            }
            
            if self.uploadImageArry.count > 5 {
                cell.img6Outlet.sd_setImage(with: URL(string: self.uploadImageArry[5].imgURL ?? "") )
                cell.img_Delete6Outlet.isHidden = false
            }else{
                cell.img_Delete6Outlet.isHidden = true
            }
            
            
            if self.uploadImageArry.count > 6 {
                cell.img7Outlet.sd_setImage(with: URL(string: self.uploadImageArry[6].imgURL ?? "") )
                cell.img_Delete7Outlet.isHidden = false
            }else{
                cell.img_Delete7Outlet.isHidden = true
            }
            
            if self.uploadImageArry.count > 7 {
                cell.img8Outlet.sd_setImage(with: URL(string: self.uploadImageArry[7].imgURL ?? "") )
                cell.img_Delete8Outlet.isHidden = false
            }else{
                cell.img_Delete8Outlet.isHidden = true
            }
            
            
            cell.img_Delete1Outlet.tappable = true
            cell.img_Delete1Outlet.callback = {
                
                if self.uploadImageArry.count > 0 && cell.img1Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 0)
                }
                
            }
            
            cell.img_Delete2Outlet.tappable = true
            cell.img_Delete2Outlet.callback = {
                
                if self.uploadImageArry.count > 1 && cell.img2Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 1)
                }
                
            }
            
            cell.img_Delete3Outlet.tappable = true
            cell.img_Delete3Outlet.callback = {
                
                if self.uploadImageArry.count > 2 && cell.img3Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 2)
                }
                
            }
            
            cell.img_Delete4Outlet.tappable = true
            cell.img_Delete4Outlet.callback = {
                
                if self.uploadImageArry.count > 3 && cell.img4Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 3)
                }
                
            }
            cell.img_Delete5Outlet.tappable = true
            cell.img_Delete5Outlet.callback = {
                
                if self.uploadImageArry.count > 4 && cell.img5Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 4)
                }
                
            }
            cell.img_Delete6Outlet.tappable = true
            cell.img_Delete6Outlet.callback = {
                
                if self.uploadImageArry.count > 5 && cell.img6Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 5)
                }
                
            }
            cell.img_Delete7Outlet.tappable = true
            cell.img_Delete7Outlet.callback = {
                
                if self.uploadImageArry.count > 6 && cell.img7Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 6)
                }
                
            }
            cell.img_Delete8Outlet.tappable = true
            cell.img_Delete8Outlet.callback = {
                
                if self.uploadImageArry.count > 7 && cell.img8Outlet.image != nil {
                  
                    Global.addLoading(view: self.view)
                    self.apiCallDeleteImage(indexOfImg: 7)
                }
                
            }
            
            return cell
            
        }else if indexPath.section == 3 && indexPath.item == 1 {
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: VideoUploadCell.reuseIdentifer, for: indexPath) as! VideoUploadCell
            
            cell.thumbnail_image.layer.borderWidth = 1
            cell.tableViewDelegate = self
            cell.indexPath = indexPath
            cell.thumbnail_image.layer.borderColor = UIColor.lightGray.cgColor
            
            if self.urlString.contains("https://www.youtube.com/watch?v=") {
                
                let vid = self.urlString.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
                self.videoIds.insert(vid, at: 0)
                cell.thumbnail_image.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(vid)/1.jpg"))
                
            }else if self.urlString.contains("https://www.youtube.com/") {
                
                let vid = self.urlString.replacingOccurrences(of: "https://www.youtube.com/", with: "")
                self.videoIds.insert(vid, at: 0)
                cell.thumbnail_image.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(vid)/1.jpg"))
                
            }else if self.urlString.contains("http://www.vimeo.com/") {
                
                let vid = self.urlString.replacingOccurrences(of: "http://www.vimeo.com/", with: "")
                self.videoIds.insert(vid, at: 0)
                cell.thumbnail_image.sd_setImage(with: URL(string: "https://vumbnail.com/\(vid).jpg"))
                
            }else if self.urlString.contains("https://youtu.be/") {
                
                let vid = self.urlString.replacingOccurrences(of: "https://youtu.be/", with: "")
                self.videoIds.insert(vid, at: 0)
                cell.thumbnail_image.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(vid)/1.jpg"))
                
            }else{
              
                if !self.urlString.isEmpty {
                   
                    cell.thumbnail_image.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(self.urlString)/1.jpg"))
                    cell.textbox.text = "https://www.youtube.com/watch?v=\(self.urlString)"
                }
            }
            
            cell.addVideoaction.setOnClickListener {
                
                if self.urlString.isEmpty {
                    cell.thumbnail_image.image = UIImage(named: "")
                    self.listingColView.reloadData()
                    Global.alertLikeToast(viewController: self, message: "Video ID can't be blank")
                }else{
                    self.listingColView.reloadData()
                }
            }
            
            
            return cell
            
        }else{
            let cell = listingColView.dequeueReusableCell(withReuseIdentifier: ContactEditCell.reuseIdentifer, for: indexPath) as! ContactEditCell
            cell.tableViewDelegate = self
            cell.indexPath = indexPath
            cell.headerLbl.text = self.listing_arry[indexPath.section].children[indexPath.item].title
            cell.valueTxtField.placeholder = self.listing_arry[indexPath.section].children[indexPath.item].title
            cell.valueTxtField.text = self.listing_arry[indexPath.section].children[indexPath.item].titleValue
            cell.displayArray = self.tag_array
            cell.typeOfDisplayField = self.listing_arry[indexPath.section].children[indexPath.item].fieldType
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header : ListCategoryHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ListCategoryHeaderView
        
        header.label.font = UIFont.init(name: "Raleway-Regular", size: 12.0)
        header.label.text = self.listing_arry[indexPath.section].title
        header.label.textColor = .black
        header.bgView.backgroundColor = UIColor(displayP3Red: 252.0/255.0, green: 232.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        return header
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension NewCreatelistingVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


extension NewCreatelistingVC: TableViewDelegate, TextViewDelegateOfDetails {
    
    
    func afterClickingReturnInTextView(textfieldValue: String, cellIndexPath: IndexPath) {
        
        self.listing_arry[cellIndexPath.section].children[cellIndexPath.item].titleValue = textfieldValue
    }
    
    
    func afterClickingSelect(cellIndexPath: IndexPath) {
        
        self.currentSelectedIndex = cellIndexPath
        initialDropDownOutlet =  DropDown()
        self.initialDropDownOutlet.anchorView = self.btnStackview
        self.initialDropDownOutlet.direction = .bottom
        self.initialDropDownOutlet.bottomOffset = CGPoint(x: 0, y:(self.initialDropDownOutlet.anchorView?.plainView.bounds.height)!)
        
        if cellIndexPath.section == 0 && cellIndexPath.row == 1 {
            self.initialDropDownOutlet.dismissMode = .automatic
            self.initialDropDownOutlet.isMultipleTouchEnabled = true
            self.initialDropDownOutlet.dataSource = self.tag_array.map({$0.keyvalue ?? ""})
            self.bgViewDropdown.isHidden = false
            self.initialDropDownOutlet.show()
            self.initialDropDownOutlet.multiSelectionAction = { [unowned self] (index: [Int], item: [String]) in
                print("Selected item: \(item) at index: \(index)")
                self.initialDropDownOutlet.show()
                self.listing_arry[currentSelectedIndex.section].children[currentSelectedIndex.item].titleValue = item.joined(separator: ",")
                self.listingColView.reloadData()
            }
        }else if cellIndexPath.section == 0 && cellIndexPath.row == 2 {
            self.initialDropDownOutlet.dismissMode = .automatic
            self.initialDropDownOutlet.isMultipleTouchEnabled = false
            self.initialDropDownOutlet.dataSource = self.cat_array.map({$0.keyvalue ?? ""})
            self.bgViewDropdown.isHidden = false
            self.initialDropDownOutlet.show()
            self.initialDropDownOutlet.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.initialDropDownOutlet.show()
                self.bgViewDropdown.isHidden = true
                self.listing_arry[currentSelectedIndex.section].children[currentSelectedIndex.item].titleValue = item
                self.listingColView.reloadData()
            }
        }else if cellIndexPath.section == 1 && cellIndexPath.row == 2 {
            self.initialDropDownOutlet.dismissMode = .automatic
            self.initialDropDownOutlet.isMultipleTouchEnabled = false
            self.initialDropDownOutlet.dataSource = self.type_array.map({$0.keyvalue ?? ""})
            self.bgViewDropdown.isHidden = false
            self.initialDropDownOutlet.show()
            
            self.initialDropDownOutlet.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.initialDropDownOutlet.show()
                self.bgViewDropdown.isHidden = true
                self.listing_arry[currentSelectedIndex.section].children[currentSelectedIndex.item].titleValue = item
                self.listingColView.reloadData()
            }
        }else if cellIndexPath.section == 4 && cellIndexPath.row == 0 {
            self.initialDropDownOutlet.dismissMode = .automatic
            self.initialDropDownOutlet.isMultipleTouchEnabled = false
            self.initialDropDownOutlet.dataSource = self.location_array.map({$0.keyvalue ?? ""})
            self.bgViewDropdown.isHidden = false
            self.initialDropDownOutlet.show()
            self.initialDropDownOutlet.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.initialDropDownOutlet.show()
                self.bgViewDropdown.isHidden = true
                self.listing_arry[currentSelectedIndex.section].children[currentSelectedIndex.item].titleValue = item
                self.listingColView.reloadData()
            }
        }
    }
    
    func afterClickingReturnInTextField(textfieldValue: String, cellIndexPath: IndexPath) {
        self.currentSelectedIndex = cellIndexPath
        
        self.listing_arry[cellIndexPath.section].children[cellIndexPath.item].titleValue = textfieldValue
    }
    
    func uploadPhoto(media: UIImage, params: [String:String], fileName: String){
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.upload_Image)")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(media.jpegData(
                    compressionQuality: 0.5)!,
                                         withName: "image",
                                         fileName: "\(fileName).jpg", mimeType: "image/jpg"
                )
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            },
            to: url!,
            method: .post ,
            headers: headers
        )
        .responseJSON { response in
            print(response)
            Global.removeLoading(view: self.view)
            switch response.result {
            case .success(let value):
                
                if let json = value as? [String:Any] {
                    
                    if let msgValue = json["message"] as? [String:Any] {
                        
                        let uri = msgValue["uploaded_file"] as? String
                        let uri_id = msgValue["attachment_id"] as? Int
                        
                        if uri != "" && uri_id != nil {
                            self.uploadImageArry.append(UploadImageValue(imgURL: uri, id: uri_id))
                            self.listingColView.reloadData()
                        }
                        
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
