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
   
    //        noti.addObserver(self, selector: "appWillEnterForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    //
    //        noti.addObserver(self, selector: "appDidFinishLaunching:", name: UIApplicationDidFinishLaunchingNotification, object: nil)
    //
    //        noti.addObserver(self, selector: "appDidBecomeActiveNotif:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    //
    //
    //         noti.addObserver(self, selector: "appWillResignActiveNotif:", name: UIApplicationWillResignActiveNotification, object: nil)
    //
    //         noti.addObserver(self, selector: "appDidReceiveMemoryWarning:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    //
    //
    //
    //        noti.addObserver(self, selector: "appWillTerminateNotif:", name: UIApplicationWillTerminateNotification, object: nil)
    //
    //        noti.addObserver(self, selector: "appProtectedDataWillBecomeUnavailableNotif:", name: UIApplicationProtectedDataWillBecomeUnavailable, object: nil)
    //        noti.addObserver(self, selector: "appProtectedDataDidBecomeAvailableNotif:", name: UIApplicationProtectedDataDidBecomeAvailable, object: nil)
    
//    func appDidEnterBackgroundNotif(notif:NSNotification){
//        
//       EaseMob.sharedInstance().applicationDidEnterBackground(notif.object as! UIApplication)
//    }
//    
//    func appWillEnterForeground(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationWillEnterForeground(notif.object as! UIApplication)
//    }
//
//    func appDidFinishLaunching(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationDidFinishLaunching(notif.object as! UIApplication)
//    }
//
//    func appDidBecomeActiveNotif(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationDidBecomeActive(notif.object as! UIApplication)
//    }
//    
//    func appWillResignActiveNotif(notif: NSNotification)
//    {
//       EaseMob.sharedInstance().applicationWillResignActive(notif.object as! UIApplication)
//    }
//
//    func appDidReceiveMemoryWarning(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationDidReceiveMemoryWarning(notif.object as! UIApplication)
//    }
//    
//    func appWillTerminateNotif(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationWillTerminate( notif.object as! UIApplication)
//    }
//
//    func appProtectedDataWillBecomeUnavailableNotif(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationProtectedDataWillBecomeUnavailable(notif.object as! UIApplication)
//    }
//    
//    func appProtectedDataDidBecomeAvailableNotif(notif:NSNotification)
//    {
//       EaseMob.sharedInstance().applicationProtectedDataDidBecomeAvailable(notif.object as! UIApplication)
//    }
//    
    
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