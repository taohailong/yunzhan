//
//  OrientationTabBarControll.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/15.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class OrientationTabBar: UITabBarController {
    
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