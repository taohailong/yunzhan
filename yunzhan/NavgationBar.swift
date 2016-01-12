//
//  NavgationBar.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/12.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation

extension UINavigationController{
//    static let associateKey = "navigationBack"
    override public class func initialize()
    {
        var once:dispatch_once_t = 0
        
           dispatch_once(&once) { () -> Void in
            
            let originalSelector = Selector("myPushViewController:animated:")
            let originalMethod = class_getInstanceMethod(UINavigationController.self , "pushViewController:animated:")
            let extendMethod = class_getInstanceMethod(UINavigationController.self, originalSelector)
            method_exchangeImplementations(originalMethod, extendMethod)
        }
    
    }
    
    func myPushViewController(viewController: UIViewController, animated: Bool)
    {
        self.myPushViewController(viewController, animated: animated)
       if viewController.navigationItem.backBarButtonItem == nil
       {
          viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
        }
    
    }
    
    func customBackButton()->UIBarButtonItem?{
    
       var item = self.customBackButton()
       if item != nil
       {
          return item
        }
        item =  UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
        return item
//       item = objc_getAssociatedObject(self, <#T##key: UnsafePointer<Void>##UnsafePointer<Void>#>)
    
    }
    
}