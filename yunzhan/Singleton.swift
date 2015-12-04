//
//  Singleton.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class UserData:NSObject {
    
    var name:String?
    var title:String?
    var deviceToken:String?{
    
        get{
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("deviceToken") as? String
            return tokenT
        }
        set{
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "deviceToken")
            userDefault.synchronize()
        }
    
    }
    var phone:String?{
        
        get {
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("phone") as? String
            return tokenT
        }
        
        set {
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "phone")
            userDefault.synchronize()
        }
    }
    var _name:String?
    var isLogIn:Bool = false
    var token:String? {
        
        get {
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("token") as? String
           return tokenT
        }
    
        set {
        
          let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "token")
        }
    }
    
    
    
    func clearUserData()
    {
       isLogIn = false
       phone  = nil
        title = nil
       name = nil
      let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("token")
        userDefault.removeObjectForKey("phone")
        userDefault.removeObjectForKey("deviceToken")
    }
    
    struct Inner {
        static var instance:UserData?
        static var token:dispatch_once_t = 0
    }
    
    class var shared:UserData {
        
        dispatch_once(&Inner.token) { () -> Void in
            Inner.instance = UserData()
        }
        return Inner.instance!
    }
    
    func sendDeviceToken(){
       
        if self.token != nil && self.deviceToken != nil
        {
           let new = NetWorkData()
            new.sendDeviceToken(self.deviceToken!)
           new.start()
        }
    }
}