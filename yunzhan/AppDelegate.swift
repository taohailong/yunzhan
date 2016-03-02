//
//  AppDelegate.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/10/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,IChatManagerDelegate {

    var window: UIWindow?
    var net :NetWorkData!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        let js = JSPatchManager.share
        js.setJSpatch()
//        js.commitJsToServer()
        
        
//        MARK:模块控制
        ModelProfile.setModelProfile()
        
        
        
        self.easemob(application, didFinishLaunchingWithOptions: launchOptions, appKey: Profile.huanxinKey, certName: Profile.huanxinAPN)
        let u = UserData.shared
//        u.messID = "tfy"
//        u.password_huanxin = "123456"
        u.logInHuanxin()
        if #available(iOS 8.0,*)
        {
//           let action1 = UIMutableUserNotificationAction()
//            action1.identifier = ""
            let userSet = UIUserNotificationSettings(forTypes: [.Badge,.Alert,.Sound], categories: nil)
            application.registerUserNotificationSettings(userSet)
            application.registerForRemoteNotifications()
        }
        else
        {
          application.registerForRemoteNotificationTypes([.Badge,.Alert,.Sound])
        }
        
        WXApi.registerApp(Profile.wxKey)
        return true
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
        var deviceToken = NSString(format: "%@", deviceToken)
        deviceToken = deviceToken.substringWithRange(NSMakeRange(1, deviceToken.length-2))
    
        deviceToken = deviceToken.stringByReplacingOccurrencesOfString(" ", withString: "")
//        print("deviceToken------------------- \(deviceToken)" )
//        develop   97ba19cba5b30bf2c0a715b2d6a0fa41126d5c791d6da9ef701363bf4f35ac4c
        net = NetWorkData()
        net.sendDeviceToken(deviceToken as String)
        net.start()
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func onResp(resp: BaseResp!) {
        
        if resp.errCode == 0
        {
           
           
        }
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
