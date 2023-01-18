//
//  LoginModelResponse.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 24/11/22.

import Foundation


struct LoginModelResponse : Codable {
    
    let data : UserObject?
    let ID : Int?
    let roles : [String]?
}

struct UserObject : Codable {
    
    let display_name : String?
    let ID : Int?
    let user_activation_key : String?
    let user_email : String?
    let user_login : String?
    let user_nicename : String?
    let user_pass : String?
    let user_registered : String?
    let user_status : String?
    let user_url : String?
    
}

struct CreateListForm : Codable {
    var code: Int?
    //var message: CreateListMessage?
    var listing_id, package_id: Int?
}

struct DynamicGetResponseModel: Codable {
    var code: Int?
    var message: [StaticObjectModel]?
}

// MARK: - Message
struct StaticObjectModel: Codable {
    var id: Int?
    var name: String?
}


struct DynamicTypeResponseModel: Codable {
    var code: Int?
    var message: SelectedType?
}

struct SelectedType: Codable   {
    var selection_items: [String: String]?
}

// MARK: - Message
struct CreateListMessage: Codable {
    var listing_id: Int
    var package_id: Int

}
