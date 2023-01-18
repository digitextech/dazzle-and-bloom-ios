//
//  Constant.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 24/11/22.
//

import Foundation
import AVKit

struct Constant {
    
    static let AppName = "Dazzle&Bloom"
    
    struct APIPath {
        
        static let baseurl = "https://dazzleandbloom.co.uk/"
        static let signup = "wp-json/users/register"
        static let login = "wp-json/users/login"
        static let Products = "wp-json/listings/get"
        static let menu = "wp-json/menu/get"
        static let forget_password = "api/forget_password.php?login="
        static let prepare_form = "wp-json/listing/prepare-form"
        static let create_listing = "wp-json/listing/create"
        static let upload_Image = "wp-json/listings/upload/image"
        static let get_categories = "wp-json/listings/categories/get"
        static let get_locations = "wp-json/listings/locations/get"
        static let get_tags = "wp-json/listings/tags/get"
        static let get_types = "wp-json/listings/types/get"
        static let update_Profile = "wp-json/profile/update"
        static let status_list = "wp-json/listings/count?uid="
        static let msg_list = "wp-json/message/get?difppage=1"
        static let msg_Details = "wp-json/message/get-details"
        static let reply_msg = "wp-json/message/reply"
        static let delete_listing = "wp-json/delete/listing"
        static let noteToadmin_listing = "wp-json/admin-note/send"
        static let about = "wp-json/get/about"
        static let profile_edit_get =  "wp-json/profile/edit"
        static let newListing = "wp-json/get/newlisting"
        static let send_message = "wp-json/message/send-message"
        static let send_otp = "/wp-json/send/otp"
        static let verify_otp = "wp-json/verify/otp"
        static let listing_update = "wp-json/listing/update"
        static let relatedlisting =  "wp-json/get/relatedlisting"
        static let deleteImage =  "wp-json/delete/image"
        static let deleteAccount = "wp-json/delete/user"
        static let deleteMessage = "wp-json/messages/delete"

    }
    
    struct APIHeader {
        static let totalRecord = "X-WP-Total"
        static let totalPages = "X-WP-TotalPages"
    }
    
    struct Currency {
        static let uK = "£"
    }
    
    struct WebURL {
        static let returns = ""
        static let termsAndConditions = ""
        static let privacyPolicy = ""
    }
    
    struct HeaderIcon {
        static let search = "search"
        static let wishList = "heart"
        static let cart = "cart"
    }
    
    struct APIHeaderSection {
        static let apiContentTypeKeyName = "Content-Type"
        static let apiContentTypeValue1 = "application/json"
        static let apiContentTypeValue2 = "application/json-patch+json"
        static let apiAcceptTypeKeyName = "Accept"
        static let apiAuthorizationKeyName = "Authorization"
    }
    
    struct ErrorMessages {
        static let msgEmptyName = "Please enter your name"
        static let msgEmptyEmail = "Please enter your valid email"
        static let msgEmptyContact = "Please enter your mobile no."
        static let msgEmptyOTP = "Please enter your OTP"
        static let msgEmptyComment = "Please enter your comments"
    }
    
    struct AddToCart: Codable {
        var productID: Int
        var productName: String
        var productImage: String
        var sku: String
        var quantity: Int
        var stockQuantity: Int
        var regularPrice: String
        var unitPrice: String
        var packNumber: String
    }
    
    struct AddToWishlist: Codable {
        var productID: Int
        var productName: String
        var productImage: String
        var sku: String
    }
    
    struct Address: Codable {
        var first_name: String
        var last_name: String
        var address_1: String
        var address_2: String
        var city: String
        var state: String
        var postcode: String
        var country: String
        var countryCode: String
        var email: String
        var phone: String
        var company: String
    }
    
    struct Filter {
        static let instock = "instock"
        static let outofstock = "outofstock"
        static let popularity = "popularity"
        static let rating = "rating"
        static let latest = "date"
        static let price = "price"
        static let price_desc = "price-desc"
    }
    
}
