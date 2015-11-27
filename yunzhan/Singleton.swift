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
        {
        
        get{
        
         return _name
        }
        set{
        
          _name = name
          isLogIn = true
        }
    }
    var title:String?
    var phone:String?{
        
        get {
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("phone") as? String
            return tokenT
        }
        
        set(new) {
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(new, forKey: "phone")
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
    
        set(newToken) {
        
          let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newToken, forKey: "token")
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
}