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
        self.changeSettingViewBarImage(false)
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
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