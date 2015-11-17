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
                
                let dateStr = date.toTimeString("yy-MM-dd")
                let week = date.toWeekData()
                schedulerDateArr.append("\(dateStr)  \(week)")
                
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
            
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject],let address = list["addr"] as? String,let mapUrl = list["booth_url"] as? String,let introduce = list["intro"] as? String,let iconUrl = list["logo_url"] as?String,let location = list["booth_name"] as? String,let company = list["name_zh"] as? String, let connectArr = list["contacts"] as? [[String:AnyObject]],let productArr = list["products"] as? [[String:AnyObject]] ,let mark = list["remark"] as? String  ,let web = list["website"] as?String ,let id = list["id"] as? Int   else {
                
                        return
                }
            
            
            let exhibitor = ExhibitorData(address: address, id: String(id), name: company, iconUrl: iconUrl, addressMap: mapUrl, webLink: web)
            exhibitor.introduct = introduce
            exhibitor.remark = mark
            exhibitor.location = location
            
            var personArr = [PersonData]()
            for dic in connectArr
            {
//               print(dic)
               
               let person = PersonData(name: dic["name"] as?String, title: dic["title"] as? String, phone: dic["phone"] as? String)
                if let id = dic["id"] as? Int
                {
                    person.id = String(id)
                }
                personArr.append(person)
            }
            
    
            
            var productBack:[ProductData]! = [ProductData]()
            
            for dic in productArr
            {
                let purl = dic["picUrls"] as![[String:String]]
                
               let p = ProductData(imageUrl: purl[0]["url"], id: dic["id"] as? String, name: dic["name_zh"] as? String)
                p.introduce = dic["intro"] as? String
                
                var picArr = [PicData]()
               for t in purl
               {
                  let pic = PicData(id: nil, url: t["url"]!)
                   picArr.append(pic)
                }
                p.picArr = picArr

               productBack.append(p)
            }
//            if productBack.count == 0
//            {
//                productBack = nil
//            }

            
            
            
            var introductArrBack:[PicData]! = [PicData]()
            if let introductArr = list["sceneUrls"] as? [[String:String]]
            {
               for dic in introductArr
               {
                 let p = PicData(id: nil, url: dic["url"]!)
                  introductArrBack.append(p)
                }
            }
//            if introductArrBack.count == 0
//            {
//               introductArrBack = nil
//            }
            
            
            let tuple:(data:ExhibitorData,personArr:[PersonData],producArr:[ProductData],introduce:[PicData]) = (exhibitor,personArr,productBack,introductArrBack)
            
            block(result: tuple, status: status)
            
        }
        
    }
    
    
    
    func getSchedulerInfo(schedulerID:String,block:NetBlock) {
        
        let url = "http://\(Profile.domain)/api/app/schedule/detail?eid=1&sid=\(schedulerID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject] else {
                return
            }
//            print(list)
            let startT = list["start_time"] as! Int
            let endT = list["end_time"] as! Int
            let scheduleData = SchedulerData(time: "\(startT.toTimeString("HH:mm"))-\(endT.toTimeString("HH:mm"))" , date: startT.toTimeString("yy-MM-dd"), title: (list["name"] as? String)!, introduce: nil, address: (list["addr"] as? String)!, id: String(list["id"]))
        
            scheduleData.company = list["sponsor"] as? String
            scheduleData.type = Bool(list["stype"] as! Int)
            
            
            var contacts = [PersonData]()
            if let contactArr = list["contacts"] as? [[String:AnyObject]]
            {
                for dic in contactArr
                {
                   let p = PersonData(name: dic["name"] as? String, title: dic["title"] as? String , phone: dic["phone"] as? String)
                    print(dic)
                    
                    if let exhibitorID = dic["exhibition_id"] as? Int
                    {
                      p.exhibitorID = String(exhibitorID)
                    }
                    
                    if let id = dic["id"] as? Int
                    {
                        p.id = String(id)
                    }

                    contacts.append(p)
                }
            }
            
            
            var guests = [PersonData]()
            if let guestsArr = list["guests"] as? [[String:AnyObject]]
            {
                for dic in guestsArr
                {
                    let p = PersonData(name: dic["name"] as? String, title: dic["title"] as? String , phone: nil)
                    guests.append(p)
                }
            }

            
            var contents = [String]()
            
            if let contentArr = list["items"] as? [[String:AnyObject]]
            {
                
                for temp in contentArr
                {
                    let start = temp["start"] as? Int
                    let end = temp["end"] as? Int
                    let c = temp["text"] as? String
                    if start != nil && end != nil && c != nil
                    {
                        contents.append("\(start!.toTimeString("HH:mm"))-\(end!.toTimeString("HH:mm"))\(c!)")
                    }
                   
                }
                
            }
            
            let tuple:(scheduler:SchedulerData,contacts:[PersonData],guests:[PersonData],contents:[String])
            = (scheduleData,contacts,guests,contents)
            
            block(result: tuple, status: status)
            
        }
    }
    
    
    func getUserInfo(token:String,block:NetBlock)
    {
        let url = "http://\(Profile.domain)/api/app/user/relogin?chn=ios&token=\(token)&eid=1"
        
        weak var user = UserData.shared
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject] else {
                return
            }
            user!.title = list["title"] as? String
            user!.name = list["name"] as? String
            user!.phone = list["mobile"] as? String

            block(result: nil, status: status)
        }
    }

    
    
    func myContactsList(block:NetBlock){
        
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/listcontact?chn=ios&token=\(user!.token!)&eid=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            
            var prefixArr = [String]()
            var personArr = [[PersonData]]()
            
            for temp in list
            {
                var subArr:[PersonData]?
                
                let p = PersonData(name: temp["name"] as? String, title: temp["title"] as? String, phone: temp["phone"] as? String)
                
                if let exhibitorID = temp["exhibition_id"] as? Int
                {
                    p.exhibitorID = String(exhibitorID)
                }
                
                if let id = temp["id"] as? Int
                {
                    p.id = String(id)
                }

                let first = temp["name_first"] as! String
                if let index = prefixArr.indexOf(first)
                {
                    subArr = personArr[index]
                    subArr?.append(p)
                    personArr.removeAtIndex(index)
                    personArr.insert(subArr!, atIndex: index)
                }
                else
                {
                    subArr = [PersonData]()
                    subArr?.append(p)
                    personArr.append(subArr!)
                    prefixArr.append(first)
                }
            }
            let tuple:(prefix:[String],data:[[PersonData]]) = (prefixArr,personArr)
            block(result: tuple, status: status)
        }
    }
    
    
    
    
    func addSchedulerContact(schedulerID:String,personID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/addscontact?chn=ios&token=\(user!.token!)&eid=1&sid=\(schedulerID)&cid=\(personID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
    
    }
    
    
    
    func addExhibitorContact(exhibitorID:String,personID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/addcontact?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)&cid=\(personID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }

    
    }
    
    
    
    func delectContact(exhibitorID:String,personID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/delcontact?chn=ios&token=\(user!.token!)&eid=1&id=\(personID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
        
    }

    
    
    
    func delectMyExhibitor(exhibitorID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/delbuz?chn=ios&token=\(user!.token!)&eid=1&id=\(exhibitorID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
        
    }

    
    
    func addMyExhibitor(exhibitorID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/addbuz?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
    }

    
    func myFavoriteExhibitor(block:NetBlock){
    
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/listbuz?chn=ios&token=\(user!.token!)&eid=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            
            var prefixArr = [String]()
            var exhibitorArr = [[ExhibitorData]]()
            
            for temp in list
            {
                if let first = temp["name_first"] as? String
                {
//                    print(temp)
                   let p = ExhibitorData(rootDic: temp)
                    
                    if let index = prefixArr.indexOf(first)
                    {
                        var subArr = exhibitorArr[index]
                        subArr.append(p)
                        exhibitorArr.append(subArr)
                    }
                    else
                    {
                        var subArr = [ExhibitorData]()
                        subArr.append(p)
                        exhibitorArr.append(subArr)
                       prefixArr.append(first)
                        
                    }

                }
            }
             let compound:(prefixArr:[String],list:[[ExhibitorData]]) = (prefixArr,exhibitorArr)
            block(result: compound, status: status)
        }
    }
    
    
    func addMyScheduler(schedulerID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/addshedule?chn=ios&token=\(user!.token!)&eid=1&sid=\(schedulerID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
    }

    
    
    func delectMyScheduler(schedulerID:String,block:NetBlock)
    {
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/delshedule?chn=ios&token=\(user!.token!)&eid=1&id=\(schedulerID)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            block(result: msg, status: status)
        }
    }

    
    
    
    func myFavoriteScheduler(block:NetBlock){
        
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/listshedule?chn=ios&token=\(user!.token!)&eid=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            
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


    
    func sendSuggestion(suggestion:String,block:NetBlock)
    {
        let user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/feedback/add?eid=1&mobile=\(user.phone!)&content=\(suggestion)&chn=ios&token=\(user.token!)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet)
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            print(result)
            guard let data = result as? [String:AnyObject],let msg = data["msg"] as? String else {
                return
            }
            
            block(result:msg , status: status)
        }

    }
    
    //    true 已存在
    func checkExhibitorStatus(exhibitorID:String,block:(status:Bool)->Void)
    {
        let user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/checkbuz?eid=1&bid=\(exhibitorID)&chn=ios&token=\(user.token!)"
      
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(status: false)
                return
            }
            print(result)
            guard let data = result as? [String:AnyObject],let code  = data["code"] as? Int  else {
                block(status: false)
                return
            }
            if code == 1
            {
              block(status: false)
            }
            else
            {
             block(status: true)
            }
            
        }
    
    }
    
//    true 已存在
    func checkSchedulerStatus(schedulerID:String,block:(status:Bool)->Void)
    {
        let user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/checkschedule?eid=1&sid=\(schedulerID)&chn=ios&token=\(user.token!)"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(status: false)
                return
            }
            print(result)
            guard let data = result as? [String:AnyObject],let code  = data["code"] as? Int  else {
                block(status: false)
                return
            }
            if code == 1
            {
                block(status: false)
            }
            else
            {
                block(status: true)
            }
        }
    }
    
    
    
    func sendDeviceToken(deviceToken:String){
    
        let user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/user/setToken?eid=1&device_token=\(deviceToken)&chn=ios"
        
        if let token = user.token
        {
           url = "\(url)&user_token=\(token)"
        }
        
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
//                block(status: false)
                return
            }
//            guard let data = result as? [String:AnyObject],let code  = data["code"] as? Int  else {
//                block(status: false)
//                return
//            }
//            if code == 1
//            {
//                block(status: false)
//            }
//            else
//            {
//                block(status: true)
//            }
        }
    }
    

    func getMethodRequest(url:String,completeBlock:NetBlock){
        
        if url.isEmpty
        {
            print(url)
//            exit(0)
            return
        }
        print(url)
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
                completeBlock(result: nil, status: .NetWorkStatusError)
        }
        
    }
    
    func start(){
        
        net.start()
    }
}