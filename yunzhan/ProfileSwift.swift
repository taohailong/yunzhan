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
class Profile:NSObject
{
    
//MARK:不同展会app配置参数
    #if EXTERENTERPISE
    static let domain = "123.56.102.224"
    static var exhibitor = "1"
    
    #elseif INTERENTERPISE
    static let domain = "123.56.102.224:8099"
    static var exhibitor = "1"
    #else
    static let domain = "www.zhangzhantong.com"
    static var exhibitor = "2"
    #endif
    static let huanxinKey = "zhangzhantong#zhangzhantong"
    static let huanxinAPN = "normal_product"
    static let wxKey = "wx9f2610aedf4da519"
    static let wxDescribe = "《第34界中国江苏国际自行车新能源电动车及零部件交易会》火热报名中~"
    
    
    static let NavBarColor = { return  UIColor(red: 219/255.0, green: 0/255.0, blue: 52/255.0, alpha: 1.0) }
    static let NavBarColorGenuine =  UIColor(red: 223/255.0, green: 32/255.0, blue: 82/255.0, alpha: 1.0)
    static let GlobalButtonDisableColor = UIColor(red: 245/255.0, green: 92/255.0, blue: 125/255.0, alpha: 1.0)
    static let GlobalButtonHightColor = UIColor(red: 207/255.0, green: 0/255.0, blue: 44/255.0, alpha: 1.0)
    
    
    static let ScoreTitleColor = UIColor(red: 250/255.0, green: 84/255.0, blue: 123/255.0, alpha: 1.0)
    static let ScoreListOneColor = UIColor(red: 255/255.0, green: 137/255.0, blue: 165/255.0, alpha: 1.0)
    static let ScoreListTwoColor = UIColor(red: 251/255.0, green: 183/255.0, blue: 199/255.0, alpha: 1.0)
    static let ScoreListThreeColor = UIColor(red: 253/255.0, green: 220/255.0, blue: 228/255.0, alpha: 1.0)
    
    
    
//    static let NavBarColor = { return  UIColor(red: 1/255.0, green: 144/255.0, blue: 61/255.0, alpha: 1.0) }
//    static let NavBarColorGenuine =  UIColor(red: 57/255.0, green: 172/255.0, blue: 107/255.0, alpha: 1.0)
//    static let GlobalButtonHightColor = UIColor(red: 23/255.0, green: 137/255.0, blue: 72/255.0, alpha: 1.0)
//    static let GlobalButtonDisableColor = UIColor(red: 161/255.0, green: 221/255.0, blue: 183/255.0, alpha: 1.0)
    
    static let NavTitleColor = {return UIColor.whiteColor() }
    

    static let width = { return UIScreen.mainScreen().bounds.size.width }
    static let height = { return UIScreen.mainScreen().bounds.size.height}
    static let userStatusChanged = "userStatusChanged"
    static let nickKey = "usernick"
    static let jobKey = "usertitle"
    static let qrKey = "zzt"
    
    
    class func globalHttpHead(path:String,parameter:String?,needToken:Bool = false)->String {
        
        var url = "http://\(self.domain)/\(path)?eid=\(self.exhibitor)&chn=ios"
        
        if needToken == true
        {
            let user = UserData.shared
            if let token = user.token
            {
                url = url + "&token=\(token)"
            }
        }
        if parameter == nil
        {
            return url
        }
        
        url = url + "&\(parameter!)"
        return url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
    }
    
    
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

    func toColor()->UIColor?{
        
      let temp = self as NSString
        
       var  cString = temp.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString   as NSString
        
        // String should be 6 or 8 characters
        if cString.length < 6
        {
            return UIColor.clearColor()
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if cString.hasPrefix("0X")
        {
            cString = cString.substringFromIndex(2)
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if cString.hasPrefix("#")
        {
            cString = cString.substringFromIndex(1)
        }
        if cString.length != 6
        {
            return UIColor.clearColor()
        }
        
        // Separate into r, g, b substrings
        var range:NSRange = NSMakeRange(0, 0)
        range.location = 0
        range.length = 2
        //r
        let rString = cString.substringWithRange(range)
        //g
        range.location = 2;
        let gString = cString.substringWithRange(range)
        //b
        range.location = 4;
        let bString = cString.substringWithRange(range)
        
        // Scan values
        var r:UInt32 = 0
        var g:UInt32 = 0
        var b:UInt32 = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
       let r_6 =  Double(UInt64(r))/255.0
       let g_6 = Double(UInt64(g))/255.0
       let b_6 = Double(UInt64(b))/255.0
        return UIColor(red: CGFloat(r_6), green: CGFloat(g_6) , blue: CGFloat(b_6), alpha: 1)
    }
    
    
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
        
       let predicate = NSPredicate(format: "SELF MATCHES %@", match)
        
        return predicate.evaluateWithObject(self)
    }

    func verifyIsImageURL() ->Bool
    {
        let match = "(http|https):\\/\\/\\S*.(png|jpg|gif)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", match)
        return predicate.evaluateWithObject(self)
    }
    
    func figureUrlElement()-> [String:String]
    {
        var dic: [String:String] = [String:String]()
        let separateArr = self.componentsSeparatedByString("?")
        if separateArr.count != 2
        {
            return dic
        }
        
        let elementArr = separateArr[1].componentsSeparatedByString("&")
        if elementArr.count == 0
        {
            return dic
        }
        
        for temp in elementArr
        {
           let keyValueArr = temp.componentsSeparatedByString("=")
           if keyValueArr.count != 2
           {
              continue
           }
           let key = keyValueArr[0]
           let value = keyValueArr[1]
           dic[key] = value
        }
        
        return dic
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
    
    
    func characterDetectChinese(char:String)->Bool
    {
        let chinese = 0x4E00 ... 0x9FFF
        for chr in char.unicodeScalars
        {
            if  Int(chr.value) >= chinese.startIndex &&  Int(chr.value) <= chinese.endIndex
            {
                return true
            }
        }
        return false
    }


//MARK:生产二维码
    func toQRImage(width:CGFloat)->UIImage?{
    
        if self.isEmpty
        {
          return nil
        }
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let dataStr = self.dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(dataStr, forKey: "inputMessage")
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        let outImage = filter?.outputImage

        

        let extent = CGRectIntegral(outImage!.extent)
        
        let widthScale = width/CGRectGetWidth(extent)
        let heithScale = width/CGRectGetHeight(extent)
        let scale = widthScale > heithScale ? heithScale:widthScale
        // 创建bitmap;
        let width = CGRectGetWidth(extent) * scale;
        let height = CGRectGetHeight(extent) * scale;
        let cs = CGColorSpaceCreateDeviceGray();
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, bitmapInfo.rawValue);
        
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(outImage!, fromRect: extent)
        CGContextSetInterpolationQuality(bitmapRef, .None);
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        // 保存bitmap到图片
        let scaledImage = CGBitmapContextCreateImage(bitmapRef);
        
        return UIImage(CGImage: scaledImage!)

    }
    
}




extension UISearchBar {

    func changeSearchBarBackColor(let color:UIColor){
        
        let subViews = self.subviews[0].subviews
        let first = subViews[0]
        first.removeFromSuperview()
        
        let textV = subViews[subViews.count - 1]
        
        if textV is UITextField
        {
            textV.backgroundColor = color
        }
        
    }

}

extension UIViewController{

    func setNavgationBarAttribute(change:Bool)
    {
        if change == true
        {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.LightContent, animated: true)
        }
        else
        {
            if self.navigationController?.viewControllers.count == 1
            {
                return
            }
            self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.Default, animated: true)
        }
    }

}


extension UIColor {
   
    class func rgb(let r:CGFloat,let g:CGFloat, let b:CGFloat) ->UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
   func convertToImage()->UIImage
   {
        let size = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(size.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, size)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return image
    }

}


extension UIImage{
    
    func t_RoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize,roundCorners:UIRectCorner) -> UIImage {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        
        CGContextAddPath(UIGraphicsGetCurrentContext(),
            UIBezierPath(roundedRect: rect, byRoundingCorners: roundCorners,
                cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output
    }
}



extension UIImageView {
    func t_addCorner(radius radius: CGFloat) {
        
        if self.image == nil
        {
            return
        }
        self.image = self.image?.t_RoundedCorner(radius: radius, self.bounds.size,roundCorners: UIRectCorner.AllCorners)
    }
}




