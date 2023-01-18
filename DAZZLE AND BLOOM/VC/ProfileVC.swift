//
//  ProfileVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/11/22.
//

import UIKit
import Alamofire
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileCol: UICollectionView!
    @IBOutlet weak var profileAvater: UIImageView!
    @IBOutlet weak var editLblAction: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    
    let arrayNameList = ["My Packages","My Listings","Feedback","Logout","Delete Account"]
    let arrayImageList = ["package","sell","feedback","logout","delete_user"]
    
    //MARK: - Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  DazzleUserdefault.getUserIDAfterLogin() == 0 || DazzleUserdefault.getUserIDAfterLogin() == nil {
            
            DazzleUserdefault.setIsLoggedIn(val: false)
            DazzleUserdefault.setIsLoginGuest(val: false)
            Switcher.updateRootVC()
            
        }
        
        profileCol.register(UINib(nibName: "AccountCell", bundle: nil), forCellWithReuseIdentifier: AccountCell.reuseIdentifer)
        
        profileCol.collectionViewLayout = createCompositionalLayout()
        profileCol.reloadData()
        
        if !DazzleUserdefault.getUserProfileIcon().isEmpty {
            profileAvater.downloadImage(url: URL(string: "\(DazzleUserdefault.getUserProfileIcon())")! , contentModeUIImage: .scaleAspectFit)
            profileAvater.isHidden = false
        }else{
            profileAvater.isHidden = true
            
        }
        
        profileAvater.layer.cornerRadius = 5
        
        setupLabelTap()
        
        let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.profile_edit_get)")!
        self.apiCallProfileDetails(url: urlstr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if DazzleUserdefault.getUserNameAfterLogin() == "" {
            profileNameLbl.text = "Welcome"
        }else{
            profileNameLbl.text = "Hello, " + DazzleUserdefault.getUserNameAfterLogin()
        }
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "EditProfileVC") as?  EditProfileVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.editLblAction.isUserInteractionEnabled = true
        self.editLblAction.addGestureRecognizer(labelTap)
        
    }
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return self.firstLayoutSection()
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 0
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    
    func apiCallDeleteUser()  {
        
        let url = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.deleteAccount)")
        
        let param = [
            "uid": "\(DazzleUserdefault.getUserIDAfterLogin())"
        ]
        
        AF.request(url! , method: .delete , parameters: param)
            .responseJSON { response in
                
                if response.response?.statusCode != 200 {
                    
                    Global.removeLoading(view: self.view)
                    
                    if response.result != nil {
                        if let error = response.result as? [String:Any]{
                            Global.alertLikeToast(viewController: self, message: "\(error["message"] as? String ?? "")")
                        }
                    }
                    
                }else{
                    let defaults = UserDefaults.standard
                    let dictionary = defaults.dictionaryRepresentation()
                    dictionary.keys.forEach
                    { key in
                        
                        defaults.removeObject(forKey: key)
                        
                    }
                    
                    Switcher.updateRootVC()
                }
            }
    }
    
    func apiCallProfileDetails(url: URL)  {
        
        let param = [
            "uid": DazzleUserdefault.getUserIDAfterLogin()
        ] as [String:Any]
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { [self] response in
                
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
                            
                        }
                        
                        if DazzleUserdefault.getUserNameAfterLogin() == "" {
                            self.profileNameLbl.text = "Welcome"
                        }else{
                            self.profileNameLbl.text = "Hello, " + DazzleUserdefault.getUserNameAfterLogin()
                        }
                        
                        if DazzleUserdefault.getUserNameAfterLogin() != "" {
                            profileAvater.downloadImage(url: URL(string: DazzleUserdefault.getUserProfileIcon())!, contentModeUIImage: .scaleAspectFit)
                            self.profileAvater.isHidden = false
                        }else{
                            self.profileAvater.isHidden = true
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: - UICollectionViewDataSource Methods
extension ProfileVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = profileCol.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifer, for: indexPath) as! AccountCell
        
        cell.mypackageLbl.text = self.arrayNameList[indexPath.item]
        cell.icon.image = UIImage(named: self.arrayImageList[indexPath.item])
        
        return cell
    }
}

//MARK: - UICollectionViewDataSource Methods
extension ProfileVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = stortboard.instantiateViewController(identifier: "MyPackageVC") as?  MyPackageVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.item == 1 {
            let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
            let vc = stortboard.instantiateViewController(identifier: "MyallListingVC") as?  MyallListingVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if indexPath.item == 2 {
            rateApp(appId: "id1664354043")
        }else if indexPath.item == 3 {
            self.resetDefaults()
            Switcher.updateRootVC()
        }else if indexPath.item == 4 {
            
            Global.showAlertFor2Options(viewController: self, message: "Do you want to delete your account?") {
                //
            } syncBlock: {
                
                Global.addLoading(view: self.view)
                self.apiCallDeleteUser()
            }
        }
    }
    
    fileprivate func rateApp(appId: String) {
        openUrl("itms-apps://itunes.apple.com/app/" + appId)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
