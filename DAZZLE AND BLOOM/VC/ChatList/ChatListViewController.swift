//
//  ChatListViewController.swift
//  ChatSample
//
//  Created by Hafiz on 22/10/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

struct MessageList {
    
    var ID = Int()
    var post_title = String()
    var post_author = String()
    var post_date = String()
    var author = String()
    var author_image = String()
    var post_image = String()
    var read_status = String()
    var bid_wrap = String()
    var post_content = String()
    var author_class = String()
    
}

class ChatListViewController: UIViewController {
    var chats = [MessageList]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if  DazzleUserdefault.getUserIDAfterLogin() == 0 || DazzleUserdefault.getUserIDAfterLogin() == nil {
            
            DazzleUserdefault.setIsLoggedIn(val: false)
            DazzleUserdefault.setIsLoginGuest(val: false)
            Switcher.updateRootVC()
            
        }
        
        Global.addLoading(view: self.view)
        self.apiCallallMessageList(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.msg_list)")!)
        
    }
    
    func setupTable() {
        // config tableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = true
       
        // cell setup
        tableView.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "ChatListViewCell")
    }
    
    func apiCallallMessageList(url: URL)  {
        
        let param = ["uid": DazzleUserdefault.getUserIDAfterLogin()]
        
        print(param)
        print(url)
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { response in
                
                 Global.removeLoading(view: self.view)
                
                switch response.result {
                case .success(let value):
                   
                    self.chats.removeAll()

                    if let json = value as? [String:Any] {
                        
                        
                        if let mess = json["message"] as? [String:Any] {
                            
                            if let messages = mess["messages"] as? [[String:Any]] {
                                
                                if messages.count > 0 {
                                    
                                    for item in messages {
                                        
                                        self.chats.append(MessageList(ID: item["ID"] as? Int ?? 0,post_title: item["post_title"] as? String ?? "",post_author: item["post_author"] as? String ?? "",post_date: item["post_date"] as? String ?? "",author: item["author"] as? String ?? "", author_image: item["author_image"] as? String ?? "",post_image: item["post_image"] as? String ?? "",read_status: item["read_status"] as? String ?? "",bid_wrap: item["bid_wrap"] as? String ?? "" ))
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
                
                
                if self.chats.count == 0 {
                    Global.alertLikeToast(viewController: self, message: "No message yet")
                }
                
                
            }
    }
}

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count > 0 ? self.chats.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListViewCell") as! ChatListViewCell
        
        cell.postTitle.text = self.chats[indexPath.item].post_title
        cell.author_Date.text = self.chats[indexPath.item].post_date
        cell.author_Name.text = self.chats[indexPath.item].author
        
        if self.chats[indexPath.item].read_status == "" {
            cell.unread_view.isHidden = true
            cell.bidLeadingAlignment.constant = -90
        }else {
            cell.unread_view.isHidden = false
            cell.bidLeadingAlignment.constant = 10
        }
        
        if self.chats[indexPath.item].bid_wrap == "" {
            cell.bid.isHidden = true
        }else{
            cell.bid.isHidden = false
        }
        
        let imageURlString_author = self.chats[indexPath.item].author_image
        if imageURlString_author != "" {
            cell.author_img.downloadImage(url: URL(string: "\(imageURlString_author)")!, contentModeUIImage: .scaleAspectFit)
        }else{
            cell.author_img.image =  UIImage(named: "noPhoto")
        }
        
        let imageURlString = self.chats[indexPath.item].post_image
        if imageURlString != "" {
            cell.chatImageView.downloadImage(url: URL(string: "\(imageURlString)")!, contentModeUIImage: .scaleAspectFit)
        }else{
            cell.chatImageView.image =  UIImage(named: "noPhoto")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let stortboard = UIStoryboard.init(name: "Main", bundle: .main)
        let vc = stortboard.instantiateViewController(identifier: "ChatDetailsController") as?  ChatDetailsController
        vc?.msgID = self.chats[indexPath.item].ID
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 160
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
        if editingStyle == .delete {
            
            Global.addLoading(view: self.view)
            self.apiCallallMessageDelete(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.deleteMessage)")!, id: self.chats[indexPath.item].ID)
        }
    }
    
    func apiCallallMessageDelete(url: URL, id: Int)  {
        
        var idArray = [Int]()
        idArray.append(id)
        
        let param = ["message_id": idArray]
        
        print(url)
        print(param)
        
        AF.request(url , method: .post, parameters: param)
            .responseJSON { response in
                
                print(response)
                if response.response?.statusCode == 200 {
                    self.apiCallallMessageList(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.msg_list)")!)

                }else{
                    
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Somthing went wrong")
                }
            }
    }
}
