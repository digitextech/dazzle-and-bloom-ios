//
//  ViewController.swift
//  ChatSample
//
//  Created by Hafiz on 20/09/2019.
//  Copyright © 2019 Nibs. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

// MARK: - Title
struct PopupTitle: Codable {
    let status, id, icon: String
}

class ChatDetailsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backAction: UIImageView!
    var msgID = Int()
    @IBOutlet weak var bidViewOutlet: UIView!
    @IBOutlet weak var bidHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var participentLbl: UILabel!
    var messages = [MessageList]()
    var titleData = [PopupTitle]()
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bidAmountLbl: UILabel!
    
    @IBOutlet weak var replyOutlet: NativeCardView!
    @IBOutlet weak var textViewOutlet: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title
        
        self.titleData.insert(PopupTitle(status: "Copy", id: "10", icon: "msg_Copy"), at: 0)
        self.titleData.insert(PopupTitle(status: "Delete", id: "11", icon: "msg_Delete"), at: 1)
        
        
        setupTable()
        self.bidViewOutlet.isHidden = true
        self.titleLbl.text = ""
        self.participentLbl.text = ""
        self.statusBarColorChange()
        backAction.tappable = true
        backAction.callback = {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.replyOutlet.setOnClickListener {
            
            if self.textViewOutlet.text.isEmpty {
                Global.alertLikeToast(viewController: self, message: "Please type something....")
            }else{
                
                self.view.endEditing(true)
                self.textViewOutlet.resignFirstResponder()
                
                Global.addLoading(view: self.view)
                self.apiCallallMessageReply(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.reply_msg)")!)
            }
        }
        
        Global.addLoading(view: self.view)
        self.apiCallallMessageDetails(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.msg_Details)")!)
        
    }
    
    func setupTable() {
        // config tableView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RightViewCell", bundle: nil), forCellReuseIdentifier: "RightViewCell")
        tableView.register(UINib(nibName: "LeftViewCell", bundle: nil), forCellReuseIdentifier: "LeftViewCell")
        
    }
    
    
    @IBAction func msgSendBtnAction(_ sender: UIButton) {
        
        Global.showUnderDevAlert(viewController: self)
    }
    
    fileprivate func responseOfMessageDetails(_ response: AFDataResponse<Any>) {
        switch response.result {
        case .success(let value):
            
            self.messages.removeAll()
            
            if let json = value as? [String:Any] {
                
                if let header_title = json["title"] as? String {
                    self.titleLbl.text = "\(header_title.capitalizingFirstLetter())"
                }
                
                let bid_val = json["bid"] as? String
                
                if bid_val == "" || bid_val == nil{
                    self.bidAmountLbl.text = ""
                    self.bidHeightConstant.constant = 0
                    self.bidViewOutlet.isHidden = true
                }else{
                    self.bidAmountLbl.text = "Bid Amount: \(bid_val ?? "")"
                    self.bidViewOutlet.isHidden = false
                }
                
                if let mess = json["message"] as? [String:Any] {
                    
                    if let participent = mess["participants"] as? [String] {
                        
                        if participent.count > 0 {
                            
                            let value = participent.joined(separator: ", ")
                            self.participentLbl.text = "Participants: \(value.capitalizingFirstLetter())"
                        }
                    }
                    
                    if let messages = mess["messages_details"] as? [[String:Any]] {
                        
                        if messages.count > 0 {
                            
                            for item in messages {
                                
                                self.messages.append(MessageList(ID: item["ID"] as? Int ?? 0,post_date: item["post_date"] as? String ?? "",author: item["author"] as? String ?? "", author_image: item["author_image"] as? String ?? "",post_image: item["post_image"] as? String ?? "",post_content: item["post_content"] as? String ?? "",author_class: item["author_class"] as? String ?? "" ))
                            }
                            
                        }
                        
                    }
                    
                }
                
                // self.totalCountLbl.text = "\(self.listofAllArray.count) Dresses"
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.tableView.scrollToBottom()
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func apiCallallMessageDetails(url: URL)  {
        
        let param = ["uid": DazzleUserdefault.getUserIDAfterLogin(), "id": self.msgID]
        
        AF.request(url , method: .get, parameters: param)
            .responseJSON { response in
                
                Global.removeLoading(view: self.view)
                self.responseOfMessageDetails(response)
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
                    self.apiCallallMessageDetails(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.msg_Details)")!)
                    
                }else{
                    
                    Global.removeLoading(view: self.view)
                    Global.alertLikeToast(viewController: self, message: "Somthing went wrong")
                }
            }
    }
    
    
    func apiCallallMessageReply(url: URL)  {
        
        let param = [
            "uid": DazzleUserdefault.getUserIDAfterLogin(),
            "message_id": self.msgID,
            "message": "\(textViewOutlet.text ?? "")"
        ] as [String : Any]
        
        print(url)
        print(param)

        
        
        AF.request(url , method: .post, parameters: param)
            .responseJSON { response in
                
                
                print(response)
                Global.removeLoading(view: self.view)
                self.textViewOutlet.text = ""
                self.responseOfMessageDetails(response)
                
                
            }
    }
    
    
    func ClickAction_Delete(isSender: Bool, id: Int, message: String) {
        
        let actionSheetAlertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: self.titleData[0].status, style: .default) { (action) in
            print("Title: \( self.titleData[0].id)")
            
            if self.titleData[0].id == "10" {
                UIPasteboard.general.string = message
            }
            
        }
        
        action.setValue(0, forKey: "titleTextAlignment")
        
        let icon = UIImage.init(named:  self.titleData[0].icon)
        action.setValue(icon, forKey: "image")
        actionSheetAlertController.addAction(action)
        
        
        if isSender {
            
            let action2 = UIAlertAction(title: self.titleData[1].status, style: .default) { (action) in
                print("Title: \( self.titleData[1].id)")
                
                
                if self.titleData[1].id == "11" {
                    
                    Global.addLoading(view: self.view)
                    self.apiCallallMessageDelete(url: URL(string:"\(Constant.APIPath.baseurl)\(Constant.APIPath.deleteMessage)")!, id: id)
                }
            }
            
            
            action2.setValue(0, forKey: "titleTextAlignment")
            
            let icon = UIImage.init(named:  self.titleData[1].icon)
            action2.setValue(icon, forKey: "image")
            
            actionSheetAlertController.addAction(action2)
            
        }
        
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetAlertController.addAction(cancelActionButton)
        
        self.present(actionSheetAlertController, animated: true, completion: nil)
    }
    
}

extension ChatDetailsController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count > 0 ? messages.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.author_class == "second_user" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftViewCell") as! LeftViewCell
            
            let imageURlString_author = self.messages[indexPath.item].author_image
            if imageURlString_author != "" {
                cell.author_Icon.downloadImage(url: URL(string: "\(imageURlString_author)")!, contentModeUIImage: .scaleAspectFit)
            }else{
                cell.author_Icon.image =  UIImage(named: "noPhoto")
            }
            
            cell.messageContainerView.setOnClickListener {
                self.ClickAction_Delete(isSender: false, id: self.messages[indexPath.item].ID, message: self.messages[indexPath.item].post_content)
            }
            
            cell.author_date.text = self.messages[indexPath.item].post_date
            cell.authorNameLbl.text = self.messages[indexPath.item].author
            cell.textMessageLabel.text = self.messages[indexPath.item].post_content
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightViewCell") as! RightViewCell
            
            let imageURlString_author = self.messages[indexPath.item].author_image
            if imageURlString_author != "" {
                cell.author_Icon.downloadImage(url: URL(string: "\(imageURlString_author)")!, contentModeUIImage: .scaleAspectFit)
            }else{
                cell.author_Icon.image =  UIImage(named: "noPhoto")
            }
            
            cell.messageContainerView.setOnClickListener {
                self.ClickAction_Delete(isSender: true, id: self.messages[indexPath.item].ID, message: self.messages[indexPath.item].post_content)
            }
            
            cell.author_date.text = self.messages[indexPath.item].post_date
            cell.authorNameLbl.text = self.messages[indexPath.item].author
            cell.textMessageLabel.text = self.messages[indexPath.item].post_content
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
    }
    
}

extension UITableView {
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
