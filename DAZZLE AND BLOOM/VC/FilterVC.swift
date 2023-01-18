//
//  FilterVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 26/12/22.
//

import UIKit
import Alamofire
import RangeSeekSlider

@objc protocol FilterDelegate: NSObjectProtocol{
    
    func afterClickingFilterLocation(minimum: CGFloat ,maximum: CGFloat ,locationItems: [Int])
}

class FilterVC: UIViewController {
    
    @IBOutlet weak var clearAllOutlet: UILabel!
    @IBOutlet weak var filterColOutlet: UICollectionView!
    
    @IBOutlet weak var filterOutlet: UIButton!
    
    var location_array = [StaticKeyWithValue]()
    var indexofSelectedLocationID = [Int]()
    weak var filterDelegate: FilterDelegate?
    
    var minV = CGFloat()
    var maxV = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterColOutlet.register(CategoryHeaderViewRelated.self, forSupplementaryViewOfKind: "categoryHeaderId", withReuseIdentifier: "headerId")
        self.filterColOutlet.register(UINib(nibName: "RangeSeekSliderCell", bundle: nil), forCellWithReuseIdentifier: RangeSeekSliderCell.reuseIdentifer)
        self.filterColOutlet.register(UINib(nibName: "LocationSelectCell", bundle: nil), forCellWithReuseIdentifier: LocationSelectCell.reuseIdentifer)
        
        self.filterColOutlet.collectionViewLayout = createCompositionalLayout()
        
        self.indexofSelectedLocationID = DazzleUserdefault.getFilterLocationValue()
        self.filterColOutlet.reloadData()
        
        Global.addLoading(view: self.view)
        self.apiCallForGetLocation()
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.clearAllOutlet.isUserInteractionEnabled = true
        self.clearAllOutlet.addGestureRecognizer(labelTap)
        
        self.minV = 0.0
        self.maxV = 4900.0
        
        
        if DazzleUserdefault.getFilterMinXValue() != 0 {
          
            self.minV = CGFloat(DazzleUserdefault.getFilterMinXValue())
        }
        
        if  DazzleUserdefault.getFilterMaXValue() != 4900 {
          
            self.maxV = CGFloat(DazzleUserdefault.getFilterMaXValue())
        }
        
        filterOutlet.layer.cornerRadius = 10

    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        DazzleUserdefault.setFilterLocationValue(val: [])
        DazzleUserdefault.setFilterMaXValue(val: 4900)
        DazzleUserdefault.setFilterMinXValue(val: 0)
        
        self.indexofSelectedLocationID = []
        
        self.minV = 0.0
        self.maxV = 4900.0

        filterColOutlet.reloadData()
        
    }
    
    
    
    
    @IBAction func filterAction(_ sender: UIButton) {
        
        DazzleUserdefault.setFilterLocationValue(val: self.indexofSelectedLocationID)
        DazzleUserdefault.setFilterMaXValue(val: Int(self.maxV))
        DazzleUserdefault.setFilterMinXValue(val: Int(self.minV))

        self.dismiss(animated: true) {
            self.filterDelegate?.afterClickingFilterLocation(minimum: self.minV, maximum: self.maxV, locationItems: self.indexofSelectedLocationID)
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
                    
                    self.filterColOutlet.reloadData()
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
    
    
    //MARK: - Helper Method
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            return self.fourthLayoutSection(sec: sectionNumber)
        }
    }
    
    private func fourthLayoutSection(sec: Int) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(sec == 0 ? 0.5 : 0.15))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 5, bottom: 10, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 10
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets.leading = 0
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: "categoryHeaderId", alignment: .top)
        ]
        return section
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource Methods
extension FilterVC: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 1 {
            return self.location_array.count > 0 ? self.location_array.count : 0
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header : CategoryHeaderViewRelated = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! CategoryHeaderViewRelated
        
        header.label.font = UIFont.init(name: "Raleway-Bold", size: 17.0)
        
        if indexPath.section == 0 {
            header.label.text = "Price"
            
        }else{
            header.label.text = "Seller Location"
        }
        header.label.textColor = .black
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = filterColOutlet.dequeueReusableCell(withReuseIdentifier: RangeSeekSliderCell.reuseIdentifer, for: indexPath) as! RangeSeekSliderCell
            
            cell.priceRangeOutlet.delegate = self
            
            cell.priceRangeOutlet.selectedMinValue = self.minV
            cell.priceRangeOutlet.selectedMaxValue = self.maxV
            
            cell.priceRangeOutlet.minValue = 0.0
            cell.priceRangeOutlet.maxValue = 4900.0
                    
            return cell
        }else{
            let cell = filterColOutlet.dequeueReusableCell(withReuseIdentifier: LocationSelectCell.reuseIdentifer, for: indexPath) as! LocationSelectCell
            cell.nameLbl.text = self.location_array[indexPath.item].keyvalue
            
            
            if self.indexofSelectedLocationID.contains(self.location_array[indexPath.item].keyid ?? 0) {
                cell.imgOfIcon.image = UIImage(systemName: "checkmark.square")
            }else{
                cell.imgOfIcon.image = UIImage(systemName: "square")
                
            }
            
            cell.imgOfIcon.tappable = true
            cell.imgOfIcon.callback = {
                
                if self.indexofSelectedLocationID.contains(self.location_array[indexPath.item].keyid ?? 0) {
                    if let indexOfPath = self.indexofSelectedLocationID.firstIndex(of: self.location_array[indexPath.item].keyid ?? 0){
                        self.indexofSelectedLocationID.remove(at: indexOfPath)
                    }
                }else{
                    self.indexofSelectedLocationID.append(self.location_array[indexPath.item].keyid ?? 0)
                }
                
                self.filterColOutlet.reloadData()
            }
            return cell
        }
    }
}


// MARK: - RangeSeekSliderDelegate
extension FilterVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        self.maxV = maxValue
        self.minV = minValue
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

