//
//  DazzleUserdefault.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 24/11/22.
//

import Foundation
import UIKit

class DazzleUserdefault: NSObject {
    
    class func set(key:String,value:Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func get(key:String) -> Bool{
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    class func setArray(key:String,value:[String]){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getArray(key:String) -> [String]{
        let value = UserDefaults.standard.object(forKey: key)
        return value as! [String]
    }
    
    class func setIntArray(key:String,value:[Int]){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getIntArray(key:String) -> [Int]{
        let value = UserDefaults.standard.object(forKey: key)
        return value as? [Int] ?? []
    }
    
    class func setString(key:String,value:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getString(key:String) -> String{
        let value = UserDefaults.standard.string(forKey: key) ?? ""
        return value
    }
    
    class func setInt(key:String,value:Int){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getInt(key:String) -> Int{
        let value = UserDefaults.standard.integer(forKey: key)
        return value
    }
    
    class func setTokenAfterLogin(val : String) {
        setString(key: "LoginToken" , value: val)
    }
    
    class func  getTokenAfterLogin() -> String{
        return getString(key: "LoginToken")
    }
    
    class func setFCMToken(val : String) {
        setString(key: "FCMToken" , value: val)
    }
    
    class func  getFCMToken() -> String{
        return getString(key: "FCMToken")
    }
    
    class func setUserIDAfterLogin(val : Int) {
        setInt(key: "UserID" , value: val)
    }
    
    class func  getUserIDAfterLogin() -> Int{
        return getInt(key: "UserID")
    }
    
    class func setIsLoggedIn(val : Bool) {
        set(key: "isLoggedIn" , value: val)
    }
    
    class func  getIsLoggedIn() -> Bool{
        return get(key: "isLoggedIn")
    }
    
    class func setRememberMe(val : Bool) {
        set(key: "REMEMBER_USER" , value: val)
    }
    
    class func  getRememberMe() -> Bool{
        return get(key: "REMEMBER_USER")
    }
    
    class func setIsCalledFromAppDelegate(val : Bool) {
        set(key: "CalledFromAppDelegate" , value: val)
    }
    
    class func  getIsCalledFromAppDelegate() -> Bool{
        return get(key: "CalledFromAppDelegate")
    }
    class func setIsCalledForPush(val : Bool) {
        set(key: "CalledForPush" , value: val)
    }
    
    class func  getIsCalledForPush() -> Bool{
        return get(key: "CalledForPush")
    }
    
    class func setIsAppActive(val : Bool) {
        set(key: "AppActive" , value: val)
    }
    
    class func  getIsAppActive() -> Bool{
        return get(key: "AppActive")
    }
    
    class func setIsLoginGuest(val : Bool) {
        set(key: "LoginGuest" , value: val)
    }
    
    class func  getIsLoginGuest() -> Bool{
        return get(key: "LoginGuest")
    }
    
    class func setUserPhoneAfterLogin(val : String) {
        setString(key: "UserPhone" , value: val)
    }
    
    class func  getUserPhoneAfterLogin() -> String{
        return getString(key: "UserPhone")
    }
    
    class func setUserNameAfterLogin(val : String) {
        setString(key: "UserName" , value: val)
    }
    
    class func  getUserNameAfterLogin() -> String{
        return getString(key: "UserName")
    }
    
    class func setUserProfileIcon(val : String) {
        setString(key: "ProfileIcon" , value: val)
    }
    
    class func  getUserProfileIcon() -> String{
        return getString(key: "ProfileIcon")
    }
    
    class func setUserEmailAfterLogin(val : String) {
        setString(key: "UserEmail" , value: val)
    }
    
    class func  getUserEmailAfterLogin() -> String{
        return getString(key: "UserEmail")
    }
    
    class func setUserPasswordAfterLogin(val : String) {
        setString(key: "UserPassword" , value: val)
    }
    
    class func  getUserUserPasswordAfterLogin() -> String{
        return getString(key: "UserPassword")
    }
    
    class func setPincode(val : String) {
        setString(key: "Pincode" , value: val)
    }
    
    class func  getPincode() -> String{
        return getString(key: "Pincode")
    }
    
    class func  getCartCountAfterLogin() -> Int{
        return getInt(key: "CartCount")
    }
    
    class func setCartCountAfterLogin(val : Int) {
        setInt(key: "CartCount" , value: val)
    }
    
    
    class func  getFilterMinXValue() -> Int{
        return getInt(key: "FilterMinXValue")
    }
    
    class func setFilterMinXValue(val : Int) {
        setInt(key: "FilterMinXValue" , value: val)
    }
    
    class func  getFilterMaXValue() -> Int{
        return getInt(key: "FilterMaXValue")
    }
    
    class func setFilterMaXValue(val : Int) {
        setInt(key: "FilterMaXValue" , value: val)
    }
    
    class func  getFilterLocationValue() -> [Int]{
        return getIntArray(key: "FilterLocationValue")
    }
    
    class func setFilterLocationValue(val : [Int]) {
        setIntArray(key: "FilterLocationValue" , value: val)
    }   
}
