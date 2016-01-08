//
//  MessMaster.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/6.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
extension AppDelegate{

    func easemob(application:UIApplication,didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?,appKey:String,certName:String)
    {
        
//        EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
       EaseSDKHelper.shareHelper().easemobApplication(application, didFinishLaunchingWithOptions: launchOptions, appkey: appKey, apnsCertName: certName, otherConfig: ["EASEMOB_CONFIG_ENABLECONSOLELOGGER":true])
//
       self.setupNotification()
    }
    func setupNotification(){
    
        let noti = NSNotificationCenter.defaultCenter()
        noti.addObserver(self, selector: "loginStateChange:", name: "loginStateChange", object: nil)
        
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    
    func loginStateChange(notification:NSNotification)
    {
       let autoLogin = EaseMob.sharedInstance().chatManager.isAutoLoginEnabled
       let logSuccess = notification.object as! Bool
        
       if autoLogin == true || logSuccess == true
       {
       }
    }
   
       
    // 开始自动登录回调
    func willAutoLogin(loginInfo:[String:AnyObject],error:NSError?)
    {
       if error != nil
       {
        
        }
       else
       {
           EaseMob.sharedInstance().chatManager.loadDataFromDatabase()
        }
    
    }
    
    
    func didAutoLogin(loginInfo:[String:AnyObject],error:NSError?)
    {
        if error != nil
        {
            
        }
        else
        {
            EaseMob.sharedInstance().chatManager.asyncFetchMyGroupsList()
        }
    }

    
}