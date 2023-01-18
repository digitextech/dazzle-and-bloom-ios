//
//  AboutUsVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 18/12/22.
//

import UIKit
import WebKit
import Alamofire

class AboutUsVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet  var aboutWebViewOutlet: WKWebView!
    var isComeFromAbout = Bool()
    @IBOutlet  var headerLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.statusBarColorChange()
        aboutWebViewOutlet.navigationDelegate = self
        
        if isComeFromAbout {
            headerLbl.text = "About Us"

//            Global.addLoading(view: self.view)
//            let urlstr = URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.about)")
//            self.apiCallaboutus(url: urlstr!)
            
            let link = URL(string: "https://dazzleandbloom.co.uk/about-us/")
            let request = URLRequest(url: link!)
            aboutWebViewOutlet.load(request)
            
        }else{
            
            headerLbl.text = "Contact"
            let link = URL(string: "https://dazzleandbloom.co.uk/contact/")
            let request = URLRequest(url: link!)
            aboutWebViewOutlet.load(request)
        }
      
    }
    
    func apiCallaboutus(url: URL)  {
        
        AF.request(url , method: .get)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    Global.removeLoading(view: self.view)

                    if let json = value as? [String:Any] {
                        
                        if let content = json["content"]  as? [String:Any] {
                            if let content = content["post_content"]  as? String {
                                self.aboutWebViewOutlet.loadHTMLString("\(content)", baseURL: nil)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        
        Switcher.updateRootVC()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           
           let css = "img {max-width: 100%; width: 100%; height: 75%; vertical-align: middle;}"
           
           let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
           
        aboutWebViewOutlet.evaluateJavaScript(js, completionHandler: nil)
       }
    
}
