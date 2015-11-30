//
//  DataModel.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class PicData {
    let id:String?
    let  url:String?
    init(id:String?, url:String?)
    {
        self.id = id
        self.url = url
    }
}

extension PicData
{
    convenience init?(rootDic:[String:AnyObject])
    {
       self.init(id: rootDic["intro_url"] as? String, url: rootDic["pic_url"] as? String)
    }
}




class NewsData {
    let link:String
    let title:String
    var content:String?
    var time:String?
    var imageUrl:String?
    init(link:String,title:String,content:String?,time:String?,imageUrl:String?)
    {
        self.link = link
        self.title = title
        self.content = content
        self.time = time
        self.imageUrl = imageUrl
    }
}

extension NewsData {
    
    convenience init?(dic:[String:AnyObject])
    {
        guard let title = dic["title"] as? String, let link = dic["url"] as? String,let content = dic["summary"] as? String, let time = dic["create_time"] as? Int,let urlImage = dic["pic_url"] as? String
            else
        {
            return nil
        }
        self.init(link:link,title:title ,content:content,time:time.toTimeString("MM/dd-HH:mm"),imageUrl:urlImage)
    }
}


enum SchedulerType:String{
  
   case PublicMeeting = "公开宴会"
   case PublicDiscuss = "公开论坛"
   case PublicActive = "公开企业活动"
   case UnPublicMeeting = "不公开宴会"
   case UnPublicDiscuss = "不公开论坛"
   case UnPublicActive = "不公开企业活动"
    case UnKnow = ""
    
    init(status:Int?,type:Int?){
       
      if status == 0 && type == 1
        {
          self = .PublicMeeting
        }
        else if status == 0 && type == 2
      {
         self = .PublicDiscuss
        }
        else if status == 0 && type == 3
      {
         self = .PublicActive
        }
        
        else if status == 1 && type == 1
      {
         self = .UnPublicMeeting
        }
        else if status == 1 && type == 2
      {
         self = .UnPublicDiscuss
        }
        else if status == 1 && type == 3
      {
         self = .UnPublicActive
        }
        else
      {
         self = .UnKnow
        }
    }
    
}

class SchedulerData {
    
    var company:String?
    var time:String,date:String,title:String?,introduce:String?,address:String,type:SchedulerType ,id:String
    var height:CGFloat = 0.0
    var typeName:String = ""
    init(time:String,date:String,title:String?,introduce:String?,address:String,id:String,type:SchedulerType = .UnKnow)
    {
        self.time = time
        self.date = date
        self.title = title
        self.introduce = introduce
        self.address = address
        self.type = type
        self.id = id
    }
    
    func figureoutStringHeight(font:UIFont,size:CGSize){
    
        if title != nil && height == 0
        {
           height = title!.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).height
        }
    }
}


extension SchedulerData{

    convenience init?(rootDic:[String:AnyObject])
    {
        guard let name = rootDic["name"] as? String,let content = rootDic["intro"] as? String,let address = rootDic["addr"] as? String ,let time = rootDic["start_time"] as? Int,let id = rootDic["id"] as? NSNumber
            else { return nil }
//      print(rootDic)
        
        let status = rootDic["status"] as? Int
        let type = rootDic["stype"] as? Int
        
        self.init(time: time.toTimeString("HH:mm"), date: time.toTimeString("MM/dd"), title: name, introduce: content, address: address, id: String(id),type:SchedulerType(status: status, type: type))
        if let tN = rootDic["stype_format"] as? String
        {
            self.typeName = tN
        }
    }

}






class ExhibitorData {
    var address:String?, addressMap:String?, id:String, iconUrl:String?, name:String?,webLink:String?,remark:String?,location:String?,introduct:String?

    init(address:String?, id:String, name:String?, iconUrl:String?,addressMap:String?,webLink:String? = nil)
    {
        self.address = address
        self.id = id
        self.name = name
        self.iconUrl = iconUrl
        self.addressMap = addressMap
        self.webLink = webLink
    }
    func getIntroductSize(font:UIFont,size:CGSize)->CGFloat{
    
        if introduct == nil || introduct?.isEmpty == true
        {
            return 0
        }
        let size = introduct!.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return size.size.height
    }
    
 }

extension ExhibitorData{

    convenience init(rootDic:[String:AnyObject]){
//    print(rootDic)
       self.init(address: rootDic["addr"] as? String, id: String(rootDic["id"]!), name: rootDic["name_zh"] as? String, iconUrl: rootDic["logo_url"] as? String, addressMap: rootDic["booth_url"] as? String, webLink: rootDic["website"] as? String)
        self.location = rootDic["booth_name"] as? String
    
    }
}





class ProductData {
    let imageUrl:String?
    let productId:String?
    let name:String?
    var introduce:String?
    var picArr:[PicData]?
    init(imageUrl:String?,id:String?,name:String?)
    {
      self.imageUrl = imageUrl
        self.productId = id
        self.name = name
    }
}


class PersonData {
    var name:String?
    var title:String?
    var phone:String?
    var id:String?
    var exhibitorID:String?
    init(name:String?,title:String?,phone:String?)
    {
      self.name = name
        self.title = title
        self.phone = phone
    }
}




class TimeMessage {
    var picHeight = 0.0
    var picUrl:String?
    var personName:String?
    var personTitle:String?
    var time:String?
    var comment:String?
    var favoriteNu:Int?
    var feedBackNu:Int?
    var forwardNu:Int?
    var contentHeight:Float?
    var id:String?
    var favorited:Bool?
    func figureOutContentHeight(size:CGSize,font:UIFont) ->Float{
        
        if comment?.isEmpty == true
        {
           contentHeight = 0
        }
        
        if contentHeight == nil && comment != nil {
        
          contentHeight = Float(comment!.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).height)
          return contentHeight!
        }
        
        if contentHeight == nil && comment == nil
        {
          return 0
        }
        return contentHeight!
    }
    
}

enum CompanyType:Int {
   case Hotel = 0
   case Company = 1
}
class CompanyData {
    var address:String?
    var contact:String?
    var time:String?
    var id:String?
    var type:CompanyType = .Hotel
    var mobile:String?
    var name:String?
    var phone:String?
    var score:Double?
    var route:String?
    var roomNu:Int?
    var routeHeight:CGFloat = 0.0
    func figureOutContentHeight(size:CGSize,font:UIFont) ->CGFloat{
        
        if routeHeight == 0 && route != nil {
            
            routeHeight = route!.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).height
        
        }
        return routeHeight
    }

}



