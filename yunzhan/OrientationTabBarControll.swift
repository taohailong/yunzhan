//
//  OrientationTabBarControll.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/15.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class OrientationTabBar: UITabBarController,IChatManagerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = Profile.NavBarColorGenuine
//        self.changeSettingViewBarImage(false)
        self.setTabBarSelectIcon()
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    func setTabBarSelectIcon(){
      
         let f = self.viewControllers as! [UINavigationController]
        
        for (index,value) in f.enumerate()
        {
            var normal = ""
            var select = ""
            switch index
            {
               case 0:
                 normal = "root-1"
                 select = "root-1_selected"
            case 1:
                normal = "root-2"
                select = "root-2_selected"
            case 2:
                normal = "root-3"
                select = "root-3_selected"
            case 3:
                normal = "root-4"
                select = "root-4_selected"
            default:
                normal = "root-5"
                select = "root-5_selected"
            }
            
            value.tabBarItem.image = UIImage(named: normal)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            value.tabBarItem.selectedImage = UIImage(named: select)
//            value.tabBarItem.selectedImage = UIImage(named: select)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            value.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        }
    
    
    }
    
    
    func didLoginFromOtherDevice() {
        UserData.shared.logOutHuanxin()
    }
    
    func didUpdateConversationList(conversationList: [AnyObject]!) {
        
        self.changeBadge()
    }
    
    func didUnreadMessagesCountChanged(){
        
        self.changeBadge()
        
    }
    
    func changeBadge(){
        
        let conversation = EaseMob.sharedInstance().chatManager.conversations as? [EMConversation]
        
        if conversation == nil
        {
           return
        }
        
        
        var nu:UInt = 0
        for temp in conversation!
        {
          nu += temp.unreadMessagesCount()
        }
        
        if nu > 0
        {
            self.changeSettingViewBarImage(true)
        }
        else
        {
           self.changeSettingViewBarImage(false)
        }
    }

    
    func changeSettingViewBarImage(new:Bool){
    
        let f = self.viewControllers![4] as! UINavigationController
        let rootView = f.viewControllers[0] as! SettingViewController

        if new == true
        {
            f.tabBarItem.image = UIImage(named: "root-5_new")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            f.tabBarItem.selectedImage = UIImage(named: "root-5_selected_new")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            rootView.newMessReloadTabel(true)
        }
        else
        {
            f.tabBarItem.image = UIImage(named: "root-5")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            f.tabBarItem.selectedImage = UIImage(named: "root-5_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            rootView.newMessReloadTabel(false)
        }
    
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
}