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
typealias NetDicBlock = (result:[String:AnyObject],status: NetStatus) ->(Void)

enum NetStatus:Int{
  case NetWorkStatusSucess = 0
    case NetWorkStatusError = 1
}


class NetWorkData:NSObject {
    
    var net : AFHTTPRequestOperation!
    //    init(){
//        //      net = AFHTTPRequestOperation()
//    }
    
    
//   MARK: 全局配置API
    
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
    
    func updateUserInfo(let name:String?,let job:String?,block:NetBlock){
        
        weak var user = UserData.shared
        var genuineName:String! = ""
        
        if name == nil
        {
            if user?.name != nil
            {
                genuineName = user?.name
            }
            
        }
        else
        {
            genuineName = name!
        }
        
        let genuineTitle:String! = job
        
        var url = "http://\(Profile.domain)/api/app/personal/setting?chn=ios&token=\(user!.token!)&eid=1&name=\(genuineName)&title=\(genuineTitle)"
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let dic = result as? [String:AnyObject] ,let data = dic["data"] as? [String:AnyObject]
                else {
                    return
            }
            user?.name = data["name"] as? String
            user?.title = data["title"] as? String
            block(result:0 , status: status)
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
    
    
//    MARK: 首页API
    
    
    func getRootData(block: NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/exhibition/index?chn=ios&id=1"
        
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
                   let a = ActivityData(dataDic: temp)
                    moduleArr.append(a)
                  }
                    
            }
                    
            let tuple:(pics:[PicData], news:[NewsData],exhibitor:[ExhibitorData],scheduler:[SchedulerData],activityArr:[ActivityData]) = (pics,newArr,exhibitorArr,schedulerArr,moduleArr)
            block(result: tuple , status: status)
            }
        }
    }
    
    
    func getExhibitorMap(block:NetBlock){
        
        let url = "http://\(Profile.domain)/api/app/exhibition/boothpics?eid=1&chn=ios"
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let dataDic = data["data"] as? [[String:AnyObject]] else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            var mapArr = [TimeMessage]()
            for temp in dataDic
            {
                let m = TimeMessage()
                m.personTitle = temp["name"] as? String
                m.setPicSize(temp["height"] as? Double, width_p: temp["width"] as? Double)
                m.picThumbUrl = temp["pic_url"] as? String
                mapArr.append(m)
            }
            
            block(result: mapArr, status: .NetWorkStatusSucess)
        }
        
    }


//   MARK: 我的联系人收藏API
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
                
                
                p.chatID = temp["hxin_id"] as? String
                if let exhibitorID = temp["exhibition_id"] as? Int
                {
                    p.exhibitorID = String(exhibitorID)
                }
                
                if let exhibitorName = temp["buz_name"] as? String
                {
                    if p.title != nil
                    {
                       p.title = exhibitorName + p.title!
                    }
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
            
            guard let data = result as? [String:AnyObject],let code = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            if code == 0
            {
                block(result: msg, status: status)
            }
            else
            {
                block(result: msg, status: .NetWorkStatusError)
            }
            
        }
        
    }

//    MARK:我的 活动API
    
    
    func getSchedulList(block:NetBlock){
        
        let url = "http://\(Profile.domain)/api/app/schedule/list?eid=1&chn=ios"
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
                
                let dateStr = date.toTimeString("yyyy-MM-dd")
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

    func getSchedulerInfo(schedulerID:String,block:NetBlock) {
        
         weak var user = UserData.shared
        var url = ""
        if user?.token != nil
        {
            url = "http://\(Profile.domain)/api/app/schedule/detail?chn=ios&eid=1&sid=\(schedulerID)&token=\(user!.token!)"
        }
        else
        {
            url = "http://\(Profile.domain)/api/app/schedule/detail?chn=ios&eid=1&sid=\(schedulerID)"
        }


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
            let scheduleData = SchedulerData(time: "\(startT.toTimeString("HH:mm"))-\(endT.toTimeString("HH:mm"))" , date: startT.toTimeString("yyyy-MM-dd"), title: (list["name"] as? String)!, introduce: nil, address: (list["addr"] as? String)!, id: String(list["id"]))
            
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
                    let p = PersonData(netData: dic)
                    if let exhibitorID = dic["exhibition_id"] as? Int
                    {
                        p.exhibitorID = String(exhibitorID)
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
                    if let favorite = dic["favorite"] as? Int
                    {
                        p.favorite = favorite == 0 ? false:true
                    }
                    
                    if let chat = dic["chat"] as? String
                    {
                        p.chatID = chat
                    }
                    
                    guests.append(p)
                }
            }
            
            
            var contents = [String]()
            
            if let contentArr = list["items"] as? [[String:AnyObject]]
            {
                
                for temp in contentArr
                {
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
    
    
    func searchScheduler(searchStr:String,block:NetBlock)
    {
        var url = "http://\(Profile.domain)/api/app/schedule/search?chn=ios&eid=1&name=\(searchStr)"
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let t  = data["data"] as? [[String:AnyObject]]  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            print(result)
            var schedulerArr = [SchedulerData]()
            
            for temp in t
            {
                let s = SchedulerData(rootDic: temp)
                if s != nil
                {
                    let name = s!.title! as NSString
                    let rang = name.rangeOfString(searchStr)
                    let att = NSMutableAttributedString(string: (s?.title!)!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(15)])
                    
                    att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                    s?.searchAttribute = att
                    schedulerArr.append(s!)
                }
            }
            block(result: schedulerArr, status: .NetWorkStatusSucess)
        }
        
    }
    
    
    func modifySchedulerContact(schedulerID:String,personID:String,isAdd:Bool,block:NetBlock)
    {
        weak var user = UserData.shared
        var url = ""
        if isAdd == true
        {
           url = "http://\(Profile.domain)/api/app/personal/addscontact?chn=ios&token=\(user!.token!)&eid=1&sid=\(schedulerID)&cid=\(personID)"
        }
        else
        {
           url = "http://\(Profile.domain)/api/app/schedule/delcontact?chn=ios&token=\(user!.token!)&eid=1&sid=\(schedulerID)&cid=\(personID)"
        }
        
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let code = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            if code == 0
            {
                block(result: msg, status: status)
            }
            else
            {
                block(result: msg, status: .NetWorkStatusError)
            }
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
            
            guard let data = result as? [String:AnyObject],let _ = data["code"] as? Int,let msg = data["msg"] else {
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
    
    
    
    //    true 是否已经收藏
    func checkSchedulerStatus(schedulerID:String,block:(status:Bool)->Void)
    {
        let user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/checkschedule?chn=ios&eid=1&sid=\(schedulerID)&chn=ios&token=\(user.token!)"
        
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
                
                schedulerDateArr.append(date.toTimeString("yyyy-MM-dd"))
                
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
    
    
// MARK:我的展商 API
    
    
    func getExhibitorList(block:NetBlock){
        
        let url = "http://\(Profile.domain)/api/app/buz/list?chn=ios&eid=1"
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
    
    func getExhibitorInfo(id:String,block:NetBlock){
        
        weak var user = UserData.shared
        var url = ""
        if user?.token != nil
        {
           url = "http://\(Profile.domain)/api/app/buz/detail?chn=ios&eid=1&bid=\(id)&token=\(user!.token!)"
        }
        else
        {
          url = "http://\(Profile.domain)/api/app/buz/detail?chn=ios&eid=1&bid=\(id)"
        }
        
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
                    let person = PersonData(netData: dic)
                    print(dic)
                    
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
                    
                    let p = ProductData(imageUrl: purl, id: String(dic["id"] as! Int), name: dic["name_zh"] as? String)
                    p.introduce = dic["intro"] as? String
                    p.exhibitorID = String(id)
                    p.createrName = exhibitor.name
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
            let tuple:(data:ExhibitorData,personArr:[PersonData],producArr:[ProductData],introduce:[PicData]) = (exhibitor,personArr,productBack,introductArrBack)
            
            block(result: tuple, status: status)
        }
    }

    
    
    func modifyExhibitorContact(exhibitorID:String,personID:String,isAdd:Bool,block:NetBlock)
    {
        weak var user = UserData.shared
        var url = ""
        if isAdd == true
        {
           url = "http://\(Profile.domain)/api/app/personal/addcontact?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)&cid=\(personID)"
        }
        else
        {
           url = "http://\(Profile.domain)/api/app/buz/delcontact?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)&cid=\(personID)"
        }
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let code = data["code"] as? Int,let msg = data["msg"] else {
                return
            }
            if code == 0
            {
               block(result: msg, status: status)
            }
            else
            {
                block(result: msg, status: .NetWorkStatusError)
            }
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

    
    //    true 检查是否收藏
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
    
    
    func searchExhibitor(searchStr:String,block:NetBlock){
        
        var url = "http://\(Profile.domain)/api/app/buz/search?chn=ios&eid=1&name=\(searchStr)"
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: .NetWorkStatusError)
                return
            }
            guard let data = result as? [String:AnyObject],let t  = data["data"] as? [[String:AnyObject]]  else {
                block(result: "数据参数错误", status: .NetWorkStatusError)
                return
            }
            
            var exhibitorArr = [ExhibitorData]()
            
            for temp in t
            {
                let e = ExhibitorData(rootDic: temp)
                let name = e.name! as NSString
                let rang = name.rangeOfString(searchStr)
                let att = NSMutableAttributedString(string: e.name!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(16)])
                
                att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                e.searchAttribute = att
                exhibitorArr.append(e)
            }
            
            block(result: exhibitorArr, status: .NetWorkStatusSucess)
        }
        
    }

    func orderProduct(let exhibitorID:String,let productID:String, let remark:String,block:NetBlock){
        
        weak var user = UserData.shared
        var url = "http://\(Profile.domain)/api/app/product/order?chn=ios&token=\(user!.token!)&eid=1&bid=\(exhibitorID)&pid=\(productID)&remark=\(remark)"
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            block(result:0 , status: status)
        }
    }
    
    
    
    func getMyOrderList(block:NetBlock)
    {
        
        weak var user = UserData.shared
        let url = "http://\(Profile.domain)/api/app/personal/orders?chn=ios&token=\(user!.token!)&eid=1"
        
        self.getMethodRequest(url) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                block(result: result, status: status)
                return
            }
            
            guard let data = result as? [String:AnyObject],let list = data["data"] as? [[String:AnyObject]] else {
                return
            }
            
            var orderList = [ProductData]()
            
            for dic in list
            {
                let ids = dic["product_id"] as? Int
                let p = ProductData(imageUrl: dic["product_pic_url"] as? String, id:String(ids) , name: dic["product_name_zh"] as? String)
                let time = dic["create_time"] as? Int
                p.time = time?.toTimeString("yyyy-MM-dd HH:mm")
                p.remark = dic["remark"] as? String
                p.introduce = dic["product_intro"] as? String
                p.createrName = dic["buz_name_zh"] as? String
                orderList.append(p)
            }
            
            block(result:orderList , status: status)
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
    
    
    
// MARK: 我的资讯
    
    
    func getNewsList(block:NetBlock) {
        
        let url = "http://\(Profile.domain)/api/app/news/list?chn=ios&eid=1"
        
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
//                            当width 为0时
                          m.picHeight = 300.0
                        }
                    }
                }

                m.comment = temp["content"] as? String
                m.figureOutContentHeight(CGSizeMake(Profile.width()-46, 1000), font: Profile.font(12))
                if let time = temp["create_time"] as? Int
                {
                    m.time = time.toTimeString("MM/dd HH:mm")
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
                element.time = time.toTimeString("yyyy-MM-dd HH:mm")
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
                  c.time = time.toTimeString("yyyy-MM-dd HH:mm")
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
    
   
    
//    MARK: 展会须知
    
   internal func exhibitor1(block:NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/exhibition/notes?eid=1&chn=ios"
        self.newMethodRequest(url,taskBlock: block, warnShow: true,completeBlock: { (result, status) -> (Void) in

            var html = ""
            if let arr = result["data"] as? [[String:AnyObject]]
            {
               for temp in arr
               {
                  if let title = temp["title"] as?String
                  {
                     html = html + "<div class=\"spot\"><i></i><span>\(title) </span></div>"
                  }
                
                  if let contentDic = temp["value"] as? [String:AnyObject]
                  {
                    
                    if let content = contentDic["content"]
                    {
                      html = html + "<p><font size=\"3px\" color=\"black\">\(content)</font></p>"
                    }
                    
                    if let picTitle = contentDic["pic_title"]
                    {
                        html = html + "<p><font size=\"3px\" color=\"black\">\(picTitle)</font></p>"
                    }

                    if let picUrl = contentDic["pic_url"]
                    {
                        html = html + "<div class=\"fullImage\"> <img src=\"\(picUrl)\"/></div>"
                    }

                  }
                }
            }
            block(result: html, status: .NetWorkStatusSucess)
        })
    }
    
    
    func exhibitor7(block:NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/exhibition/distribution?eid=1&chn=ios"
        self.newMethodRequest(url,taskBlock: block, warnShow: true,completeBlock: { (result, status) -> (Void) in
            
            var html = ""
            if let dic  = result["data"] as? [String:AnyObject]
            {
                if let title = dic["title"] as?String
                {
                    html = html + "<div class=\"spot\"><i></i><span>\(title) </span></div>"
                }
                if let content = dic["content"]
                {
                    html = html + "<p><font size=\"2px\" color=\"black\">\(content)</font></p>"
                }

                if let picTitle = dic["pic_title"]
                {
                    html = html + "<p><font size=\"3px\" color=\"black\">\(picTitle)</font></p>"
                }
                        
                if let picUrl = dic["pic_url"]
                {
                    html = html + "<div class=\"fullImage\"> <img src=\"\(picUrl)\"/></div>"
                }
                        
            }
            
            block(result: html, status: .NetWorkStatusSucess)
        })
    }
    
    
    
    
    
    
    
    
    func exhibitorAdvertiseCategory(block:NetBlock){
        
        let url = "http://\(Profile.domain)/api/app/exhibition/guidelist?eid=1&chn=ios"
        self.newMethodRequest(url,taskBlock: block, warnShow: true,completeBlock: { (result, status) -> (Void) in
            
            block(result: result["data"] as? [[String:AnyObject]], status: .NetWorkStatusSucess)
        })
    }
    
    
    
    func exhibitorAdvertiseContact(block:NetBlock){
    
        let url = "http://\(Profile.domain)/api/app/exhibition/contact?eid=1&chn=ios"
        self.newMethodRequest(url,taskBlock: block, warnShow: true,completeBlock: { (result, status) -> (Void) in
            
            var titleArr = [String]()
            var contentArr = [[NSAttributedString]]()
            
            if let arr = result["data"] as? [[String:AnyObject]]
            {
                for temp in arr
                {
                  if let t = temp["title"] as? String
                  {
                     titleArr.append(t)//yi ji
                  }
                    
                  var subCArr = [NSAttributedString]()
//                    print(temp)
                  if let subDicArr = temp["value"] as? [[String:AnyObject]]
                  {

                    for erji in subDicArr
                    {
                        var contentStr = ""
                        self.appFormateAdString(&contentStr, appendString:erji["title"])
                        
                        
                        
                        if let remarkArr = erji["remark"] as? [[String:AnyObject]]
                        {
                            
                            for remarkDic in remarkArr
                            {
                                self.appFormateAdString(&contentStr, appendString:remarkDic["value"])//备注
                                
                                if let personArr = remarkDic["list"] as? [[String:AnyObject]]
                                {
                                    for (index,personDic) in personArr.enumerate()
                                    {
                                        if let name = personDic["name"] as? String
                                        {
                                            if name.isEmpty != true
                                            {
                                               contentStr = contentStr + name + "  "
                                            }
                                            
                                            contentStr = contentStr + (personDic["content"] as! String)
                                        }
                                        
                                        if  index/2 != 0 && index != personArr.count
                                        {
                                            //双数
                                            contentStr = contentStr +  "\n"
                                        }
                                        else
                                        {
                                            //单数
                                            contentStr = contentStr + "     "
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        let attribute = NSMutableAttributedString(string: contentStr, attributes: [NSFontAttributeName : Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
                        
                        let paragraph = NSMutableParagraphStyle()
                        paragraph.lineSpacing = 3
                        attribute.addAttributes([NSParagraphStyleAttributeName : paragraph], range: NSMakeRange(0, attribute.length))
                        
                        subCArr.append(attribute)
                        
                        
                        
                    
                    }
               
                  }
                    
                    
                  contentArr.append(subCArr)
                }
            }
            
            let compose:(title:[String],content:[[NSAttributedString]]) = (titleArr,contentArr)
            block(result:compose , status: .NetWorkStatusSucess)
        })
    }
    
    
    func appFormateAdString(inout original:String,appendString:AnyObject?)
    {
        if let temp  = appendString as? String
        {
            if temp.isEmpty != true
            {
                original = original + temp + "\n"
            }
        }
    }
    
    func newMethodRequest(url:String,taskBlock:NetBlock,warnShow:Bool,completeBlock:NetDicBlock){
    
        if url.isEmpty
        {
            return
        }
        
        net = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!))
            net.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
            
            if let jsonData = result as? NSData
            {
                
                if let json = try?  NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                {
                    
                    if let code = json["code"] as? Int
                    {
                        if code != 0 ,let msg = json["msg"] as? String
                        {
                            if warnShow == true
                            {
                               let warnString = THActivityView(string: msg)
                               warnString.show()
                            }
                            taskBlock(result: msg, status: .NetWorkStatusError)
                        }
                        else
                        {
                            completeBlock(result: json as! [String : AnyObject], status: .NetWorkStatusSucess)
                        }
                    }
                    else
                    {
                        
                        if warnShow == true
                        {
                            let warnString = THActivityView(string: "参数错误")
                            warnString.show()
                        }
                        taskBlock(result: "参数错误", status: .NetWorkStatusError)
                    }
                }
                else
                {
                    if warnShow == true
                    {
                        let warnString = THActivityView(string: "参数错误")
                        warnString.show()
                    }
                    taskBlock(result: "参数错误", status: .NetWorkStatusError)
                }
            }
            
            }) { ( operating:AFHTTPRequestOperation!, err:NSError!) -> Void in
                
                if warnShow == true
                {
                    let warnString = THActivityView(string: "网络异常")
                    warnString.show()
                }

                taskBlock(result: "网络异常", status: .NetWorkStatusError)
        }
    }
    
    
    
    
    func getMethodRequest(url:String,completeBlock:NetBlock){
        
        if url.isEmpty
        {
            return
        }

        net = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!))
//        net.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        net.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
            
            if let jsonData = result as? NSData
            {
                if let json = try?  NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                {
                    if let code = json["code"] as? Int,let msg = json["msg"]
                    {
                        if code != 0
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