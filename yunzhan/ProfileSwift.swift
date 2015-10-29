//
//  ProfileSwift.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/10/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
import UIKit

class NSLog {
    init(_ s : String){
     
       print(s)
    }
}
class Profile {
    static let width = { return UIScreen.mainScreen().bounds.size.width }
    static let height = { return UIScreen.mainScreen().bounds.size.height}
    
    class func rgb(let r:CGFloat,let g:CGFloat, let b:CGFloat) ->UIColor{
       return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    class func font(let l: CGFloat)->UIFont {
    
         return UIFont.systemFontOfSize(l)
    }
}