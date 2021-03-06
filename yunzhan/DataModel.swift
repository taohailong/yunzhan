//
//  DataModel.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class PicData:NSObject,RepeatScrollProtocol {
    
    var title:String?
    let id:String?
    let  url:String?
    init(id:String?, url:String?)
    {
        self.id = id
        self.url = url
    }
    @objc func getImageUrl() -> String! {
        return self.url
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
    var searchAttribute:NSMutableAttributedString!
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
    var searchAttribute:NSMutableAttributedString!
    
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
    var exhibitorID:String?
    let imageUrl:String?
    let productId:String?
    let name:String?
    var time:String?
    var introduce:String?
    var remark:String?
    var createrName:String?
    var picArr:[PicData]?
//    var remarkHeight:CGFloat?
    
    func figureoutStringHeight(str:String!,font:UIFont,size:CGSize)->CGFloat{
        
        var height:CGFloat = 0
        if str != nil
        {
            height = str.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).height
        }
        
        return height
    }
 
    init(imageUrl:String?,id:String?,name:String?)
    {
      self.imageUrl = imageUrl
        self.productId = id
        self.name = name
    }
}


class PersonData {
    var score:String?
    var qq:String?
    var company:String?
    var name:String?
    var title:String?
    var phone:String?
    var id:String?
    var exhibitorID:String?
    var favorite:Bool = false
    var chatID:String?
    var picUrl:String?
    init(name:String?,title:String?,phone:String?)
    {
        self.name = name
        self.title = title
        self.phone = phone
    }
}


extension PersonData{

    convenience init(let netData:[String:AnyObject])
    {
        self.init(name: netData["name"] as?String, title: netData["title"] as? String, phone: netData["mobile"] as? String)
        self.qq = netData["qq"] as? String
        self.company = netData["company"] as? String
        if let id = netData["id"] as? Int
        {
            self.id = String(id)
        }
        if let favorite = netData["favorite"] as? Int
        {
            self.favorite = favorite == 0 ? false:true
        }
        
        if let chat = netData["hxin_id"] as? String
        {
            self.chatID = chat
        }
 
        self.picUrl = netData["pic_url"] as?String
        
        if let score  = netData["score"] as? Int
        {
           self.score = String(score)
        }
        
    }
}




class TimeMessage {
    var picHeight = 0.0
    var picUrl:String?
    var picThumbUrl:String?
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
    
    func setPicSize(heigth_p:Double?,width_p:Double?)
    {
        var scale = 0.0
        if let width = width_p
        {
            if let height = heigth_p
            {
                if width != 0
                {
                    scale =  height / width
                    self.picHeight = Double(Profile.width()) * scale
                }
                else
                {
                    //                            当width 为0时
                    self.picHeight = 300.0
                }
            }
        }
    }
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


class ActivityData {
    var iconUrl:String?
    var name:String?
    var detail:String?
    var link:String?
    var color:UIColor?
}

extension ActivityData{

    convenience init(dataDic:[String:AnyObject]){
       
       self.init()
        self.name = dataDic["name"] as? String
        self.link = dataDic["link"] as? String
        self.iconUrl = dataDic["icon_url"] as? String
        self.detail = dataDic["descr"] as? String
//        print(dataDic)
        self.color = (dataDic["ftcolor"] as? String)?.toColor()
    }
}


//class UserDataModel {
//    var qq:String?
//    var company:String?
//    var name:String?
//    var title:String?
//    var job:String?
//    let phone:String
//    let exhibitor:String
//    let huanxinID:String
//    
//    init(phone:String,exhibitorID:String,huanxinID:String){
//       
//        self.huanxinID = huanxinID
//        self.exhibitor = exhibitorID
//        self.phone = phone
//    }
//    
//    convenience init(dataDic:[String:AnyObject]){
//      
//        self.init(phone: dataDic["mobile"] as! String, exhibitorID: String(dataDic["exhibition_id"]), huanxinID:dataDic["hxin_id"] as! String)
//        
//        self.qq = dataDic["qq"] as? String
//        self.company = dataDic["company"] as? String
//        self.name = dataDic["name"] as? String
//        self.job = dataDic["title"] as? String
//    }
//}

