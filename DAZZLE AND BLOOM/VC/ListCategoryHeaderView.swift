//
//  ListCategoryHeaderView.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 27/11/22.
//

import UIKit

class ListCategoryHeaderView: UICollectionReusableView {
    
    var label = UILabel()
    var bgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 10, y: bounds.minY, width: bounds.width - 20, height: bounds.height)
        label.frame = CGRect(x: 15, y: bounds.minY, width: bounds.width - 15, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

