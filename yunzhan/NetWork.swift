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
                
                
                var moduleArr = [ActivityData]()
                if let modle = data["modules"] as? [[String:AnyObject]]
                {
                  for temp in modle
                  {
                    if moduleArr.count == 3
                    {
                        break
                    }
                    let a = ActivityData(dataDic: temp)
                    moduleArr.append(a)
                  }
                    
                }
                    
                let tuple:(pics:[PicData], news:[NewsData],exhibitor:[ExhibitorData],scheduler:[SchedulerData],activityArr:[ActivityData]) = (pics,newArr,exhibitorArr,schedulerArr,moduleArr)
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
            
            var prefixArr = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
            var returnArr = [[ExhibitorData]](count: 27, repeatedValue: [ExhibitorData]())
            
            
            for temp in list
            {
            
                let element = ExhibitorData(rootDic: temp)
                
                element.remark = temp["remark"] as? String
                var prefixStr:String!
                
                if let t = temp["name_first"] as? String
                {
                   prefixStr = t
                }
                else
                {
                   prefixStr = "#"
                }

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
//            print(compound)
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
//            print(list)
            
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
            
//            print(result)
            if status == NetStatus.NetWorkStatusError
            {
                
                block(result: result, status: status)
                return
            }
            
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [String:AnyObject],let id = list["id"] as? Int   else {
                
                        return
                }
            
            
            let exhibitor = ExhibitorData(address:list["addr"] as? String , id: String(id), name: list["name_zh"] as? String, iconUrl:list["logo_url"] as? String, addressMap: list["booth_url"] as? String, webLink: list["website"] as?String)
            
            exhibitor.introduct = list["intro"] as? String
            exhibitor.remark = list["remark"] as? String
            exhibitor.location = list["booth_name"] as? String
//            exhibitor.addressMap = nil
            
            var personArr:[PersonData]! = nil
            
            if let connectArr = list["contacts"] as? [[String:AnyObject]]{
                
                personArr = [PersonData]()
                for dic in connectArr
                {
                    //               print(dic)
//                    break
                    let person = PersonData(name: dic["name"] as?String, title: dic["title"] as? String, phone: dic["phone"] as? String)
                    if let id = dic["id"] as? Int
                    {
                        person.id = String(id)
                    }
                    personArr.append(person)
                }
            
            }
            
    
            
            var productBack:[ProductData]! = nil
            
            if let productArr = list["products"] as? [[String:AnyObject]]  {
               
                productBack = [ProductData]()
                for dic in productArr
                {
                    let purls = dic["picUrls"] as![[String:String]]
                    
                    var purl:String? = nil
                    if purls.count != 0
                    {
                       purl = purls[0]["url"]
                    }
                    
                    
                    let p = ProductData(imageUrl: purl, id: dic["id"] as? String, name: dic["name_zh"] as? String)
                    p.introduce = dic["intro"] as? String
                    
                    var picArr = [PicData]()
                    for t in purls
                    {
                        let pic = PicData(id: nil, url: t["url"]!)
                        picArr.append(pic)
                    }
                    p.picArr = picArr
                    
                    productBack.append(p)
                }
            
            }
            
            
            
            var introductArrBack:[PicData]! = nil
            if let introductArr = list["sceneUrls"] as? [[String:String]]
            {
                introductArrBack = [PicData]()
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
            scheduleData.type = SchedulerType.init(status: list["status"] as? Int, type: list["stype"] as? Int)
            if let tN = list["stype_format"] as? String
            {
                scheduleData.typeName = tN
            }

            
            var contacts = [PersonData]()
            if let contactArr = list["contacts"] as? [[String:AnyObject]]
            {
                for dic in contactArr
                {
                   let p = PersonData(name: dic["name"] as? String, title: dic["title"] as? String , phone: dic["phone"] as? String)
//                    print(dic)
                    
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
//                    let start = temp["start"] as? Int
//                    let end = temp["end"] as? Int
                    let c = temp["text"] as? String
                    if  c != nil
                    {
                        contents.append(c!)
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
                
//                let test = temp.fecth("dd", type: String)
                
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
        let url = "http://\(Profile.domain)/api/app/personal/delbuz?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)"
        
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

                   let p = ExhibitorData(rootDic: temp)
                    
                    if let index = prefixArr.indexOf(first)
                    {
                        var subArr = exhibitorArr[index]
                        subArr.append(p)
                        exhibitorArr.removeAtIndex(index)
                        exhibitorArr.insert(subArr, atIndex: index)
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
        let url = "http://\(Profile.domain)/api/app/personal/delshedule?chn=ios&token=\(user!.token!)&eid=1&sid=\(schedulerID)"
        
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
//        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
//            print(result)
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
//            print(result)
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
//            print(result)
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
    
    
    
    
    func getTimeLineList(start:Int,block:NetBlock){
    
        let user = UserData.shared
        var url :String?
        if user.token != nil
        {
           url = "http://\(Profile.domain)/api/app/infoWall/infoWallList?eid=1&start=\(start)&offset=20&chn=ios&token=\(user.token!)"
        }
        else
        {
           url = "http://\(Profile.domain)/api/app/infoWall/infoWallList?eid=1&start=\(start)&offset=20&chn=ios&token="
        }
        
        self.getMethodRequest(url!) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                    block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let t  = data["data"],let list = t["infoWallList"] as? [[String:AnyObject]]  else {
                    block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            var listArr = [TimeMessage]()
            for temp  in list{
                
                
//               print(temp)
                let m = TimeMessage()
                
                var scale = 0.0
                if let width = temp["width"] as? Double
                {
                    if let height = temp["height"] as? Double
                    {
                        if width != 0
                        {
                            scale =  height / width
                            m.picHeight = Double(Profile.width()) * scale
                        }
                        else
                        {
                          m.picHeight = 300.0
                        }
                    }
                }

                m.comment = temp["content"] as? String
                m.figureOutContentHeight(CGSizeMake(Profile.width()-46, 1000), font: Profile.font(12))
                if let time = temp["create_time"] as? Int
                {
                    m.time = time.toTimeString("MM/dd-HH:mm")
                }
                if let id = temp["id"] as? Int
                {
                    m.id = String(id)
                }
                m.picUrl = temp["pic_url"] as? String
                m.forwardNu = temp["share_num"] as? Int
                m.favorited = temp["praiseStatus"] as? Bool
                m.favoriteNu = temp["praiseCount"] as? Int
                m.feedBackNu = temp["commentCount"] as? Int
                m.personName = temp["name"] as? String
                m.personTitle = temp["title"] as? String
                m.picThumbUrl = temp["ppic_url"] as? String
                print(m.picThumbUrl)
//                m.personName = "啦啦啦"
//                m.personTitle = "总监"
 
                listArr.append(m)
            }
            block(result: listArr, status: .NetWorkStatusSucess)
        }
    }
    
    
    func makeFavoriteToMessage(id:String,block:NetBlock){
       
        let user = UserData.shared
        var url :String?
        if user.token != nil
        {
            url = "http://\(Profile.domain)/api/app/infoWall/praise?eid=1&info_wall_id=\(id)&chn=ios&token=\(user.token!)"
        }
        else
        {
            url = "http://\(Profile.domain)/api/app/infoWall/praise?eid=1&info_wall_id=\(id)&chn=ios&token="
        }
        
        self.getMethodRequest(url!) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let code = data["code"] as? Int  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            
           if code == 0
           {
            if let content = data["data"] as? [String:Int]
            {
               block(result: content["praiseCount"], status: .NetWorkStatusSucess)
            }
            
            }
            else
           {
             block(result: data["msg"] as! String, status: .NetWorkStatusError)
           }
            
        }
    }
    
    
    func getForwardNu(id:String,block:NetBlock){
    
        let user = UserData.shared
        var url :String?
        if user.token != nil
        {
            url = "http://\(Profile.domain)/api/app/infoWall/share?eid=1&info_wall_id=\(id)&chn=ios&token=\(user.token!)"
        }
        else
        {
            url = "http://\(Profile.domain)/api/app/infoWall/share?eid=1&info_wall_id=\(id)&chn=ios&token="
        }
        
        self.getMethodRequest(url!) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let code = data["data"] as? [String:AnyObject]  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
//            print(result)
            if let nu = code["shareNum"] as? Int
            {
               block(result: nu, status: .NetWorkStatusSucess)
            }
            
//            if code == 0
//            {
//                block(result: "", status: .NetWorkStatusSucess)
//            }
//            else
//            {
//                block(result: data["msg"] as! String, status: .NetWorkStatusError)
//            }
            
        }
    
    }
    
    
    func sendCommentToMessage(id:String,comment:String,block:NetBlock){
    
        let user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/infoWall/comment?eid=1&info_wall_id=\(id)&content=\(comment)&chn=ios&token=\(user.token!)"
//        var str = url as NSString
//        str = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let code = data["code"] as? Int  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            if code == 0
            {
                block(result: "", status: .NetWorkStatusSucess)
            }
            else
            {
                block(result: data["msg"] as! String, status: .NetWorkStatusError)
            }
            
        }
    }

    
    func getMessageCommentList(id:String,block:NetBlock){
    
        let user = UserData.shared
        var url :String?
        if user.token != nil
        {
            url = "http://\(Profile.domain)/api/app/infoWall/getContents?eid=1&info_wall_id=\(id)&chn=ios&token=\(user.token!)"
        }
        else
        {
            url = "http://\(Profile.domain)/api/app/infoWall/getContents?eid=1&info_wall_id=\(id)&chn=ios&token="
        }
        
        self.getMethodRequest(url!) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let t = data["data"] as? [String:AnyObject] ,let list = t["infoWallComments"] as? [[String:AnyObject]] else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
//            print(result)
            var listArr = [TimeMessage]()
           for temp in list
           {
              let element = TimeMessage()
              element.comment = temp["content"] as? String
              element.figureOutContentHeight(CGSizeMake(Profile.width()-73, 1000), font: Profile.font(12))
              if let time = temp["create_time"] as? Int
              {
                element.time = time.toTimeString("yy-MM-dd HH:mm")
              }
              element.personName = temp["name"] as? String
              element.personTitle = temp["title"] as? String

              listArr.append(element)
            }
        
            block(result: listArr, status: .NetWorkStatusSucess)
        }
        
    }
    
    
    
    func loadUpImage(let data:NSData,comment:String,block:NetBlock){

        let user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/infoWall/publish"
        
        let manager = AFHTTPRequestOperationManager()
        let parameter:NSDictionary = ["chn":"ios","token":user.token!,"eid":"1","content":comment]
        
        manager.POST(url, parameters: parameter, constructingBodyWithBlock: { (let formData:AFMultipartFormData!) -> Void in
            
            formData.appendPartWithFileData(data, name: "pic", fileName: "text.jpg", mimeType: "image/jpeg")
            
            }, success: { (let operation:AFHTTPRequestOperation!,let responseObject:AnyObject!) -> Void in
            
                if let jsonData = responseObject as? [String:AnyObject]
                {
                    if let code  = jsonData["code"] as? Int
                    {
                       
                        if code == 0
                        {
                           block(result: jsonData["msg"], status: .NetWorkStatusSucess)
                        }
                        else
                        {
                           block(result: jsonData["msg"], status: .NetWorkStatusError)
                        }

                    }
                }

                
            }) { (let operation:AFHTTPRequestOperation!,let err:NSError!) -> Void in
                
                block(result: "网络连接失败", status: .NetWorkStatusError)
          }
        }
    
    
    func getRegistUrl(block:NetBlock){
    
        let user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/personal/applyurl?eid=1&chn=ios&token=\(user.token!)"
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let code = data["data"] as? String  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            block(result: code, status: .NetWorkStatusSucess)
        }
    }
    
    
    func getCompanyOfExhibitor(block:NetBlock){
    
        let user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/personal/recommend?eid=1&chn=ios&token=\(user.token!)"
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let code = data["data"] as? [[String:AnyObject]]  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            var listArr = [[CompanyData]]()
            var hotelArr = [CompanyData]()
            var companyArr = [CompanyData]()
            for temp in code
            {
//                print(temp)
              let c = CompanyData()
                c.address = temp["addr"] as? String
                c.contact = temp["contacts"] as? String
                if let time = temp["create_time"] as? Int
                {
                  c.time = time.toTimeString("yy-MM-dd HH:mm")
                }
                c.name = temp["name"] as? String
                c.mobile = temp["mobile"] as? String
                c.route = temp["traffic"] as? String
                c.score = temp["star"] as? Double
                c.roomNu = temp["scale"] as? Int
                c.phone = temp["telephone"] as? String
                if let id = temp["id"] as? Int
                {
                  c.id = String(id)
                }
                
                if let type = temp["rtype"] as? Int
                {
                    if type == 1
                    {
                        c.type = .Hotel
                        hotelArr.append(c)
                    }
                    else
                    {
                      c.type = .Company
                        companyArr.append(c)
                    }
                }
            
                
            }
            
            if companyArr.count != 0
            {
               listArr.append(companyArr)
            
            }
            if hotelArr.count != 0
            {
                listArr.append(hotelArr)
            }

            block(result: listArr, status: .NetWorkStatusSucess)
        }
    
    }
    
    
    
    func getGlobalSearchResult(let search:String,block:NetBlock){
    
        var url = "http://\(Profile.domain)/api/app/exhibition/search?eid=1&name=\(search)&chn=ios"
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let dataDic = data["data"] as? [String:AnyObject] else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
          
            
            var exhibitorArr:[ExhibitorData]? = nil
            var schedulerArr:[SchedulerData]? = nil
            
            if let exhibitorDic = dataDic["buzs"] as? [[String:AnyObject]]
            {
                exhibitorArr = [ExhibitorData]()
                for temp in exhibitorDic
                {
                   let exhibitorData = ExhibitorData(rootDic: temp)
                    
                    let name = exhibitorData.name! as NSString
                    let rang = name.rangeOfString(search)
                    let att = NSMutableAttributedString(string: exhibitorData.name!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(16)])
        
                    att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                    exhibitorData.searchAttribute = att
                    exhibitorArr?.append(exhibitorData)
                }
            }
            
            
            if let schedulesDic = dataDic["schedules"] as? [[String:AnyObject]]
            {
                schedulerArr = [SchedulerData]()
                for temp in schedulesDic
                {
                    let schedulerData = SchedulerData(rootDic: temp)
                    
                    if schedulerData == nil
                    {
                      continue
                    }
                    let name = schedulerData!.title! as NSString
                    let rang = name.rangeOfString(search)
                    let att = NSMutableAttributedString(string: (schedulerData?.title!)!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(15)])
                    
                    att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                    schedulerData?.searchAttribute = att
                    schedulerArr?.append(schedulerData!)
                }
            }

           
            var compound = [[AnyObject]]()
            if exhibitorArr != nil
            {
                if exhibitorArr!.count != 0
                {
                   compound.append(exhibitorArr!)
                }
              
            }
            
            if schedulerArr != nil
            {
                if schedulerArr!.count != 0
                {
                    compound.append(schedulerArr!)
                }
            }
            block(result: compound, status: .NetWorkStatusSucess)
        }

    
    
    }
    
    
    
    func getMethodRequest(url:String,completeBlock:NetBlock){
        
        if url.isEmpty
        {
            return
        }
//        print(url)
        net = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!))
        
        net.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
            
            if let jsonData = result as? NSData
            {
                if let json = try?  NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                {
                    if let code = json["code"] as? Int,let msg = json["msg"]
                    {
                        if code == 1
                        {
                            completeBlock(result: msg, status: .NetWorkStatusError)
                        }
                        else
                        {
                           completeBlock(result: json, status: .NetWorkStatusSucess)
                        }
                    }
                    else
                    {
                       completeBlock(result: json, status: .NetWorkStatusSucess)
                    }
                }
            }
            
            }) { ( operating:AFHTTPRequestOperation!, err:NSError!) -> Void in
                completeBlock(result: nil, status: .NetWorkStatusError)
        }
        
    }
    
    func start(){
        
        net.start()
    }
    
    func cancel(){
       net.cancel()
    }
}