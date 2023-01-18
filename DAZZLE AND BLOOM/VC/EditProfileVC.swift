//
//  EditProfileVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 12/12/22.
//

import UIKit
import Alamofire

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var profileColView: UICollectionView!
    
    @IBOutlet weak var updateLbl: UILabel!
    
    let headerId = "headerId"
    let categoryHeaderId = "categoryHeaderId"
    
    /*  Child(title: "Website", titleValue: "", fieldType: "text"),
     Child(title: "Facebook", titleValue: "", fieldType: "text"),
     Child(title: "Twitter", titleValue: "", fieldType: "text"),
     Child(title: "Linkedin", titleValue: "", fieldType: "text"),
     Child(title: "Pinterest", titleValue: "", fieldType: "text"),
     Child(title: "Dribbble", titleValue: "", fieldType: "text"),
     Child(title: "Youtube", titleValue: "", fieldType: "text"),
     Child(title: "Vimeo", titleValue: "", fieldType: "text"),
     Child(title: "Instagram", titleValue: "", fieldType: "text"),*/
    
    // MARK: Model objects
    var listing_arry = [
        
        Parent(title: "Details", children: [
            Child(title: "First name", titleValue: "", fieldType: "text"),
            Child(title: "Last name", titleValue: "", fieldType: "text"),
            Child(title: "Nick name", titleValue: "", fieldType: "text"),
            Child(title: "Phone number*", titleValue: "", fieldType: "text"),
            Child(title: "Whatsapp number", titleValue: "", fieldType: "text"),
            Child(title: "Email*", titleValue: "", fieldType: "text")
            
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileColView.register(UINib(nibName: "ContactEditCell", bundle: nil), forCellWithReuseIdentifier: ContactEditCell.reuseIdentifer)
        profileColView.collectionViewLayout = createCompositionalLayout()
        profileColView.reloadData()
        
        self.statusBarColorChange()
        self.updatesetupLabelTap()
        
        Global.addLoading(view: self.view)
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.profile_edit_get)")!
        self.apiCallProfileDetails(url: urlstr)
    }
    
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        self.validateUserInput()
    }
    
    func updatesetupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.updateLbl.isUserInteractionEnabled = true
        self.updateLbl.addGestureRecognizer(labelTap)
        
    }
    
    @IBAction func back_btnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            return self.firstLayoutSection(height: 0.25)
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
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), elementKind: categoryHeaderId, alignment: .top)
        ]
        
        return section
    }
    
    func validateUserInput() -> Bool {
        
        
        guard self.listing_arry[0].children[3].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Phone number required")
            return false
        }
        
        guard self.listing_arry[0].children[5].titleValue.isEmpty == false else {
            Global.alertLikeToast(viewController: self, message: "Email required")
            return false
        }
        
        guard self.listing_arry[0].children[5].titleValue.isValidEmail() == true else {
            Global.alertLikeToast(viewController: self, message: "Valid email address required")
            return false
        }
        
        if Global.isConnectedToNetwork() {
            Global.addLoading(view: self.view)
            self.apiCallUpdateUser()
        }else{
            Global.alertLikeToast(viewController: self, message: "Network connection required")
        }
        
        return true
    }
    
    func apiCallUpdateUser() {
        
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.update_Profile)")
        
        var param = [
            "uid": DazzleUserdefault.getUserIDAfterLogin(),
            "first_name": "\(self.listing_arry[0].children[0].titleValue)",
            "last_name": "\(self.listing_arry[0].children[1].titleValue)",
            "user_phone": "\(self.listing_arry[0].children[3].titleValue)",
            "nickname": "\(self.listing_arry[0].children[2].titleValue)",
            "user_whatsapp_number": "\(self.listing_arry[0].children[4].titleValue)",
            "email": "\(self.listing_arry[0].children[5].titleValue)"
            
        ] as! [String:Any]
        
        
        print(url)
        print(param)
        
        AF.request(url! , method: .post, parameters: param, encoding: JSONEncoding.default)
        
            .responseJSON { response in
                
                Global.removeLoading(view: self.view)

                if response.response?.statusCode != 200 {
                    if let error = response.error {
                        Global.alertLikeToast(viewController: self, message: "\(response.error.debugDescription)")
                    }
                }else if response.response?.statusCode == 200 {
                    Global.removeLoading(view: self.view)
                    
                    let userfullName = "\(self.listing_arry[0].children[0].titleValue ) \(self.listing_arry[0].children[1].titleValue )"
                    
                    if userfullName.count > 0 {
                        DazzleUserdefault.setUserNameAfterLogin(val: userfullName)
                    }
                    
                    Global.alertLikeToast(viewController: self, message: "Profile updated successfully")
                }else{
                    Global.alertLikeToast(viewController: self, message: "Something went wrong")
                }
            }
    }
    
    
    func apiCallProfileDetails(url: URL)  {
        
        let param = [
            "uid": DazzleUserdefault.getUserIDAfterLogin()
        ] as [String:Any]
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { [self] response in
                
                Global.removeLoading(view: self.view)
                switch response.result {
                case .success(let value):
                    
                    if let json = value as? [String:Any] {
                        
                        if let details = json["profile"] as? [String:Any] {
                            
                            let fName = details["first_name"] as? String
                            let lName = details["last_name"] as? String
                            
                            if let a_icon = details["avatar_id"] as? String {
                                DazzleUserdefault.setUserProfileIcon(val: a_icon)
                            }
                            
                            let userfullName = "\(fName ?? "") \(lName ?? "")"
                            
                            if userfullName.count > 0 {
                                DazzleUserdefault.setUserNameAfterLogin(val: userfullName)
                            }
                        
                            self.listing_arry[0].children[0].titleValue = details["first_name"] as? String ?? ""
                            self.listing_arry[0].children[1].titleValue = details["last_name"] as? String ?? ""
                            self.listing_arry[0].children[2].titleValue = details["nickname"] as? String ?? ""
                            self.listing_arry[0].children[3].titleValue = details["user_phone"] as? String ?? ""
                            self.listing_arry[0].children[4].titleValue = details["user_whatsapp_number"] as? String ?? ""
                            self.listing_arry[0].children[5].titleValue = details["email"] as? String ?? ""
                            self.profileColView.reloadData()
                        }
                        self.profileColView.reloadData()

                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    
}
//MARK: - UICollectionViewDataSource Methods
extension EditProfileVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.listing_arry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.listing_arry[section].children.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = profileColView.dequeueReusableCell(withReuseIdentifier: ContactEditCell.reuseIdentifer, for: indexPath) as! ContactEditCell
        cell.tableViewDelegate = self
        cell.indexPath = indexPath
        cell.headerLbl.text = self.listing_arry[indexPath.section].children[indexPath.item].title
        cell.valueTxtField.placeholder = self.listing_arry[indexPath.section].children[indexPath.item].title
        cell.valueTxtField.text = self.listing_arry[indexPath.section].children[indexPath.item].titleValue
        cell.typeOfDisplayField = self.listing_arry[indexPath.section].children[indexPath.item].fieldType

        return cell
        
    }
    
}

extension EditProfileVC: TableViewDelegate {
    
    
    func afterClickingReturnInTextView(textfieldValue: String, cellIndexPath: IndexPath) {
        
        self.listing_arry[cellIndexPath.section].children[cellIndexPath.item].titleValue = textfieldValue
    }
    
    
    func afterClickingSelect(cellIndexPath: IndexPath) {
        // Nothing here
    }
    
    func afterClickingReturnInTextField(textfieldValue: String, cellIndexPath: IndexPath) {
        
        self.listing_arry[cellIndexPath.section].children[cellIndexPath.item].titleValue = textfieldValue
    }
    
}
