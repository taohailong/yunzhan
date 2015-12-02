//
//  ProfileSwift.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/10/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
import UIKit


//Content Hugging Priority代表控件拒绝拉伸的优先级。优先级越高，控件会越不容易被拉伸。
//
//而下面的Content Compression Resistance Priority代表控件拒绝压缩内置空间的优先级。优先级越高，控件的内置空间会越不容易被压缩。而这里的内置空间，就是上面讲的UIView的intrinsicContentSize。

class NSLog {
    init(_ s : String){
     
       print(s)
    }
}
class Profile
{
    static let width = { return UIScreen.mainScreen().bounds.size.width }
    static let height = { return UIScreen.mainScreen().bounds.size.height}
//    static let NavBarColor = { return  UIColor(red: 223/255.0, green: 32/255.0, blue: 82/255.0, alpha: 1.0) }
    
    static let NavBarColor = { return  UIColor(red: 219/255.0, green: 0/255.0, blue: 52/255.0, alpha: 1.0) }
    static let domain =  "www.zhangzhantong.com"
    static let NavTitleColor = {return UIColor.whiteColor() }
//    static let 
    class func rgb(let r:CGFloat,let g:CGFloat, let b:CGFloat) ->UIColor{
       return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    class func font(let l: CGFloat)->UIFont {
    
         return UIFont.systemFontOfSize(l)
    }
}

extension NSLayoutConstraint
{
    class func layoutHorizontalFull(subView:UIView) ->[NSLayoutConstraint] {
      return  NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: ["subView":subView])
    }
   
    
    class func layoutVerticalFull(subView:UIView) ->[NSLayoutConstraint] {
        
         return  NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: ["subView":subView])
    }
    
    class func layoutVerticalCenter(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
    }
    
    
    class func layoutHorizontalCenter(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
    }

    
    
    class func layoutLeftEqual(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
    }

    
    class func layoutRightEqual(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
    }

    class func layoutTopEqual(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
    }

    
    class func layoutBottomEqual(subView:UIView,toItem:UIView)->NSLayoutConstraint {
        
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toItem, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
    }
    
    class func constrainWithFormat(format:String,aView:UIView,bView:UIView?) ->[NSLayoutConstraint]{
    
        let zhengze = "\\[\\w+\\]"
       guard let regex =  try? NSRegularExpression(pattern: zhengze, options: .AllowCommentsAndWhitespace)
        else{
            assert(false, "layout err \(format)")
            return []
        }
        
        var aName:String?, bName:String?
       let arr = regex.matchesInString(format, options: [], range: NSMakeRange(0, format.characters.count))
        
        var i:Int = 0
        for re in arr
        {
            let copy = format as NSString
            
            let qu = copy.substringWithRange(re.range) as NSString
            
            
            if i == 0
            {
              aName = qu.substringWithRange(NSMakeRange(1, qu.length-2)) as String
            }
            else
            {
                bName = qu.substringWithRange(NSMakeRange(1, qu.length-2)) as String
            }
          i++
        }
        
        if bView == nil
        {
            return  NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: [aName!:aView])
        }
        else
        {
            return  NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: [aName!:aView,bName!:bView!])
        }
        
    }
    

}

extension Int {
   
    func toTimeString(formate:String) ->String
    {
       let formateManager = NSDateFormatter()
        formateManager.dateFormat = formate
        
        let date = NSDate(timeIntervalSince1970: Double(self/1000))
        
        let string = formateManager.stringFromDate(date)
        
        return string
    }
    
    func toWeekData() ->String
    {
         let date = NSDate(timeIntervalSince1970: Double(self/1000))
        let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let weekDayCompon = gregorian?.components(.NSWeekdayCalendarUnit, fromDate: date)
        
        
        var weekDay:String?
        let week = weekDayCompon?.weekday
        switch week! {
        
           case 2:
            weekDay = "星期一"
            
           case 3:
            weekDay = "星期二"

          case 4:
            weekDay = "星期三"
 
          case 5:
            weekDay = "星期四"
          case 6:
            weekDay = "星期五"

          case 7:
          weekDay = "星期六"

        default:
            weekDay = "星期日"
        }
      return weekDay!
    }
}


extension String {

    
    func toAttribute(font:UIFont,color:UIColor)->NSMutableAttributedString{
    
        let att = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:font,NSForegroundColorAttributeName:color])
        return att
    }
    
    func toPinYin() ->String?
    {
        if self.isEmpty == true {
            
            return nil
        }

        let str = CFStringCreateMutableCopy(nil, 0, self)
        CFStringTransform(str, nil, kCFStringTransformToLatin, false )
        //        print(str)
        CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, false)
        //        print(str)
    
        return str as String
    }

    func verifyIsMobilePhoneNu()->Bool
    {
       let match = "^1[0-9]{10}"
       let predicate = NSPredicate(format: "SELF MATCHS %@", match)
        
        return predicate.evaluateWithObject(self)
    }
    
    
    subscript(start:Int,lenth:Int)->String?{
    
      get {
        
        if start < 0 || lenth<=0||self.isEmpty == true || start+lenth > self.characters.count
        {
           return nil
        }
        let subString = self.substringWithRange(Range.init(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start+lenth)))
        return subString
       }
    
    }
}

extension Dictionary {
    
    func fecth<T>(key:Key,type:T) ->T?
        {
            if let values = self[key] as? T
            {
                return values
            }
            else
            {
                return nil
            }
        }
}


