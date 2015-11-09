//
//  NetWork.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

//typealias NetTestBlock = (s:String) ->Void

typealias NetBlock = (result: Any?,  status: NetStatus) ->(Void)
//enum NetStatus{
//    
//    case NetWorkStatusSucess(Int)
//    case NetWorkStatusError(String)
//}


//func getNetRootData(block:NetBlock)
//{
//    let url = "http://\(Profile.domain)/api/app/exhibition/index?id=1"
//    
//    self.getMethodRequest(url) { (result, status) -> (Void) in
//        
//        if status == NetStatus.NetWorkStatusError
//        {
//            block(result: result, status: status)
//            return
//        }
//        
//        
//        if let dic = result as? NSDictionary {
//            
//            guard let data = dic["data"] , let list = data["buzs"] as? [[String:AnyObject]]
//                else {
//                    return
//            }
//            
//            var exhibitorArr = [ExhibitorData]()
//            for temp in list
//            {
//                print(temp)
//                let data = ExhibitorData(address: temp["addr"] as? String, id: String(temp["exhibition_id"]!), name: temp["name_zh"] as? String, iconUrl: temp["logo_url"] as? String, addressMap: temp["booth_url"] as? String, webLink: temp["website"] as? String)
//                exhibitorArr.append(data)
//            }
//            
//        }
//        
//        //            block(result: (result,"ddd"), status: status)
//    }
//    
//}

enum NetStatus:Int{
  case NetWorkStatusSucess = 0
    case NetWorkStatusError = 1
}


class NetWorkData {
    
    var net : AFHTTPRequestOperation!
    
    
    //    typealias AsyRequestSuccessBlock = (data:NSData, response:NSURLResponse)->Void
    //    typealias Block = ( s: String)->Void
    init(){
        //      net = AFHTTPRequestOperation()
    }
    
    

    
    func getRootData(block: NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/exhibition/index?id=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }

            
                if let dic = result as? NSDictionary {
                
                guard let data = dic["data"] as? [String: AnyObject], let list = data["buzs"] as? [[String:AnyObject]]
                    else {
                        
                        return
                }
                
                var exhibitorArr = [ExhibitorData]()
                for temp in list
                {
                     let data = ExhibitorData(rootDic: temp)
                    exhibitorArr.append(data)
                }
                
                var pics = [PicData]()
                
                guard let info = data["exhibition"] as? [String:AnyObject], let picArr = info["pics"] as? [[String:AnyObject]]
                    else {
                        
                        return
                }
                
                for temp in picArr
                {
                    if let pic = PicData(rootDic: temp)
                    {
                        pics.append(pic)
                    }
                }
            
                var newArr = [NewsData]()
                guard let news = data["news"] as? [[String:AnyObject]] else{return }
                
                for t in news
                {
                    if let new = NewsData(dic:t)
                    {
                      newArr.append(new)
                    }
                }
                
                    
                    
                guard let schedulers = data["schedules"] as? [[String:AnyObject]] else {return }
                
                var schedulerArr = [SchedulerData]()
                for t in schedulers
                {
                   if let element = SchedulerData(rootDic: t)
                   {
                      schedulerArr.append(element)
                    }
                }
                
                
                let tuple:(pics:[PicData], news:[NewsData],exhibitor:[ExhibitorData],scheduler:[SchedulerData]) = (pics,newArr,exhibitorArr,schedulerArr)
                block(result: tuple , status: status)
            }
        }
    }
    
    
    func getExhibitorList(block:NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/buz/list?eid=1"
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            
            guard let data = result as? [String:AnyObject], let list = data["data"] as? [[String:AnyObject]]
            else
            {
                return
            }
            
            var prefixArr = [String]()
            var returnArr = [[ExhibitorData]]()
            for temp in list
            {
                let element = ExhibitorData(rootDic: temp)
               let prefixStr = temp["name_first"] as! String
                if let index = prefixArr.indexOf(prefixStr)
                {
                    
                  var subArr = returnArr[index]
                    
                   subArr.append(element)
                    returnArr.removeAtIndex(index)
                    returnArr.insert(subArr, atIndex: index)
                }
                else
                {
                   prefixArr.append(prefixStr)
                   var subArr = [ExhibitorData]()
                   subArr.append(element)
                   returnArr.append(subArr)
                }
            }
            
            let compound:(prefixArr:[String],list:[[ExhibitorData]]) = (prefixArr,returnArr)
            print(compound)
            block(result: (compound), status: status)
        }
    }
    
    func getSchedulList(block:NetBlock){
        
      let url = "http://\(Profile.domain)/api/app/schedule/list?eid=1"
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            print(list)
            
            var schedulerList = [[SchedulerData]]()
            var schedulerDateArr = [String]()
            for dic in list
            {
                guard let date = dic["date"] as? Int, let arr = dic["schedules"] as? [[String:AnyObject]]
                    else { return}
                
                schedulerDateArr.append(date.toTimeString("yy-MM-dd"))
                
                var subArr = [SchedulerData]()
                    for s in arr
                    {
                        if let element = SchedulerData(rootDic:s)
                        {
                            subArr.append(element)
                        }
                   }
                schedulerList.append(subArr)
            }
            
            let tuple:(schedulerList:[[SchedulerData]],dateArr:[String]) = (schedulerList,schedulerDateArr)
            block(result:tuple , status: status)

        }
    }
    
    
    func getNewsList(block:NetBlock) {
    
        let url = "http://\(Profile.domain)/api/app/news/list?eid=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            
            var newList = [NewsData]()
            
            for dic in list
            {
                
                if let element = NewsData(dic: dic)
                {
                    newList.append(element)
                }
            }
            
            block(result: newList, status: status)
            
        }
    }
    
    
    
    func getExhibitorInfo(id:String,block:NetBlock){
    
    
        let url = "http://\(Profile.domain)/api/app/buz/detail?eid=1&bid=\(id)"
//         let url = "http://\(Profile.domain)/api/app/buz/detail?eid=1&bid=2"
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            print(result)
            if status == NetStatus.NetWorkStatusError
            {
                
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject],let address = list["addr"] as? String,let mapUrl = list["booth_url"] as? String,let introduce = list["intro"] as? String,let iconUrl = list["logo_url"] as?String,let location = list["booth_name"] as? String,let company = list["name_zh"] as? String, let connectArr = list["contacts"] as? [[String:AnyObject]],let productArr = list["products"] as? [[String:AnyObject]] ,let mark = list["remark"] as? String  ,let web = list["website"] as?String ,let id = list["exhibition_id"] as? Int   else {
                
                print("okkkkk")
                                return
                            }
            
//            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject],let address = list["addr"] as? String,let mapUrl = list["booth_url"] as? String,let introduce = list["intro"] as? String,let iconUrl = list["logo_url"] as?String,let location = list["remark"] as? String,let company = list["name_zh"] as? String, let connectArr = list["contacts"] as? [[String:AnyObject]],let productArr = list["products"] as? [[String:AnyObject]] ,let introductArr = list["sceneUrls"] as? [[String:AnyObject]?] ,let id = list["exhibition_id"] as?String,let web = list["website"] as?String ,let mark = list["remark"] as? String else {
//                return
//            }
//            
//            
            
            let exhibitor = ExhibitorData(address: address, id: String(id), name: company, iconUrl: iconUrl, addressMap: mapUrl, webLink: web)
            exhibitor.introduct = introduce
            exhibitor.remark = mark
            exhibitor.location = location
            
            var personArr = [PersonData]()
            for dic in connectArr
            {
                guard let name = dic["name"] as?String,let phone = dic["phone"] as? String,let title = dic["title"] as? String
                    else {
                  return
                }
               let person = PersonData(name: name, title: title, phone: phone)
                personArr.append(person)
            }
            
            
            
            
            var productBack = [ProductData]()
            
            for dic in productArr
            {
                let purl = dic["picUrls"] as![[String:String]]
                
               let p = ProductData(imageUrl: purl[0]["url"], id: dic["id"] as? String, name: dic["name_zh"] as? String)
               productBack.append(p)
            }
            
            
            
            
            var introductArrBack = [PicData]()
            if let introductArr = list["sceneUrls"] as? [[String:String]]
            {
               for dic in introductArr
               {
                 let p = PicData(id: nil, url: dic["url"]!)
                  introductArrBack.append(p)
                }
            }
            
            
            
            
            
            
            let tuple:(data:ExhibitorData,personArr:[PersonData],producArr:[ProductData],introduce:[PicData]) = (exhibitor,personArr,productBack,introductArrBack)
            
            block(result: tuple, status: status)
            
        }
        
    }
    
    
    
    
    
    func getMethodRequest(url:String,completeBlock:NetBlock){
        
        if url.isEmpty
        {
            print(url)
//            exit(0)
            return
        }
        
        net = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!))
        
        net.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
            if let jsonData = result as? NSData
            {
                if let json = try?  NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                {
                    completeBlock(result: json, status: .NetWorkStatusSucess)
                }
            }
            
            }) { ( operating:AFHTTPRequestOperation!, err:NSError!) -> Void in
                completeBlock(result: "网络错误", status: .NetWorkStatusError)
        }
        
    }
    
    func start(){
        
        net.start()
    }
}