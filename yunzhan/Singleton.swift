//
//  Singleton.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class UserData:NSObject {
//    static let shared:UserData = UserData()
    var qq:String?
    var company:String?
    var name:String? = ""
    var title:String?
    
    var userID:String?{
        
        get {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("userID") as? String
            return tokenT
        }
        set
        {
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "userID")
            userDefault.synchronize()
        }
    }
    
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

    var messID:String?{
    
        get{
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("messID") as? String
            return tokenT

        }
        set{
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "messID")
        }
    }
    
    
    
    
    
    var password_huanxin:String?{
    
        get{
            let userDefault = NSUserDefaults.standardUserDefaults()
            let tokenT = userDefault.objectForKey("huanxin_ps") as? String
            return tokenT
            
        }
        set{
            let userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(newValue, forKey: "huanxin_ps")
        }
    }
    
    
    var _name:String?
    var isLogIn:Bool = false
    
    
    
    func clearUserData()
    {
       isLogIn = false
       phone  = nil
        title = nil
       name = ""
       let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("token")
        userDefault.removeObjectForKey("phone")
        userDefault.removeObjectForKey("deviceToken")
        userDefault.removeObjectForKey("messID")
        userDefault.removeObjectForKey("huanxin_ps")
        userDefault.removeObjectForKey("userID")
        self.logOutHuanxin()
    }
    
    
    func sendDeviceToken(){
        
        if self.token != nil && self.deviceToken != nil
        {
            let new = NetWorkData()
            new.sendDeviceToken(self.deviceToken!)
            new.start()
        }
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
    
    
    
    func logInHuanxin()
    {
        if self.messID == nil
        {
          return
        }
        
        if EaseMob.sharedInstance().chatManager.isLoggedIn == true
        {
           return
        }
        
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(self.messID, password: self.password_huanxin, completion: { (loginInfo:[NSObject : AnyObject]!, err:EMError!) -> Void in
        
            
            if err == nil && loginInfo != nil
            {
//               EaseMob.sharedInstance().chatManager.setIsAutoLoginEnable = true
               EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
                NSNotificationCenter.defaultCenter().postNotificationName("loginStateChange", object: true)
//                EaseMob.sharedInstance().chatManager.asyncFetch
            }
            else
            {
                THActivityView(string: "消息中心登陆失败")
                print("huanxin err \(err) loginInfo \(loginInfo)")
            }
            
        }, onQueue: nil)
    
    }
    
    
    func logOutHuanxin()
    {
        if self.messID == nil
        {
            return
        }
        
        if EaseMob.sharedInstance().chatManager.isLoggedIn == false
        {
            return
        }

        self.clearUserData()
        EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(false, completion: { (info: [NSObject : AnyObject]!, err: EMError!) -> Void in
        
        }, onQueue: nil)
    }
    
   }