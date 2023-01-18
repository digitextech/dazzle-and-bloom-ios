//
//  ItemDetailsPicCell.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 08/11/22.
//

import UIKit
import SDWebImage

@objc protocol ButtonActionFromImageCell: AnyObject {
    
    func actionButtonType(type: String)
}

class ItemDetailsPicCell: UICollectionViewCell,  UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    static let reuseIdentifer = "product-details-pic-cell-reuse-identifier"
    @IBOutlet weak var fabIcon: UIImageView!
    @IBOutlet weak var shareIcon: UIImageView!
    @IBOutlet weak var outerContainView: UIView!
    weak var delegate: ButtonActionFromImageCell?
    var scrollView = UIScrollView()
    var topband_Array = [Any]()
    var customFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fabIcon.tappable = true
        fabIcon.callback = {
            self.delegate?.actionButtonType(type: "Fav")
        }
        
        shareIcon.tappable = true
        shareIcon.callback = {
            self.delegate?.actionButtonType(type: "Share")
        }
        
        
    }
    
    func configurePageControl()  {
        
        pageControl.currentPageIndicatorTintColor = UIColor(named: "appBGColor")!
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = self.topband_Array.count
        pageControl.layer.cornerRadius = 10
        pageControl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        pageControl.currentPage = 0
        
      //  Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
    }
    
    func initializationForSlider(objc: [String]) {
        
        if objc.count > 0{
            topband_Array = objc
        }
        
        if topband_Array.count > 0 {
            scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:self.contentView.frame.size.width,height:self.contentView.frame.size.height))
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            self.outerContainView.addSubview(scrollView)
            
            for index in 0..<topband_Array.count {
                
                customFrame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                customFrame.size = self.scrollView.frame.size
                
                let bgView = UIView(frame: customFrame)
                bgView.backgroundColor = .white
              
                let subView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height))
                
                if let pictureURl = topband_Array[index] as? String{
                    subView.downloadImage_DynamicWidth(url: URL(string: pictureURl)!, contentModeUIImage: .scaleAspectFit)
                }
                
                bgView.addSubview(subView)
                
                self.scrollView.addSubview(bgView)

            }
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(topband_Array.count), height: self.scrollView.frame.size.height)
            self.configurePageControl()
            pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
            
        }
        
    }
    
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(topband_Array.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: false)
    }
    
    
}
