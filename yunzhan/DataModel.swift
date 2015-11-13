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
    let  url:String
    init(id:String?, url:String)
    {
        self.id = id
        self.url = url
    }
}

extension PicData
{
    convenience init?(rootDic:[String:AnyObject])
    {
        guard let url = rootDic["pic_url"] as? String , let link = rootDic["intro_url"] as? String
            else
        {
            return nil
        }

       self.init(id: link, url: url)
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




class SchedulerData {
    
    var company:String?
    var time:String,date:String,title:String,introduce:String?,address:String,type:Bool?,id:String
    
    init(time:String,date:String,title:String,introduce:String?,address:String,id:String,type:Bool? = true)
    {
        self.time = time
        self.date = date
        self.title = title
        self.introduce = introduce
        self.address = address
        self.type = type
        self.id = id
    }
}


extension SchedulerData{

    convenience init?(rootDic:[String:AnyObject])
    {
        guard let name = rootDic["name"] as? String,let content = rootDic["intro"] as? String,let address = rootDic["addr"] as? String ,let time = rootDic["start_time"] as? Int,let id = rootDic["id"] as? NSNumber
            else { return nil }
     
        self.init(time: time.toTimeString("HH:mm"), date: time.toTimeString("MM/dd"), title: name, introduce: content, address: address, id: String(id))
        
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
}

extension ExhibitorData{

    convenience init(rootDic:[String:AnyObject]){
    
       self.init(address: rootDic["addr"] as? String, id: String(rootDic["id"]!), name: rootDic["name_zh"] as? String, iconUrl: rootDic["logo_url"] as? String, addressMap: rootDic["booth_url"] as? String, webLink: rootDic["website"] as? String)
    
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

