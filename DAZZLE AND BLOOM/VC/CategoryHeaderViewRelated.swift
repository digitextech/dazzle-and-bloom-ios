//
//  CategoryHeaderViewRelated.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 25/12/22.
//

import UIKit

class CategoryHeaderViewRelated: UICollectionReusableView {
    
    
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: bounds.minY, width: bounds.width - 15, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
