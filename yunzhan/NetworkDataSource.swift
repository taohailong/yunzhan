//
//  NetworkDataSource.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/2.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation




//对于 OC 的 block 语法相信大家已经是再也清楚不过了,在 OC 中 C 语言的宏定义可以与 OC 结合使用,而 swift 中已经不能直接与 C 语言混合编译了,但是却提供了另一种那就是:typealias
//先看一下 OC 中的typedef
//typedef void (^AsyncRequestSuccessBlock)(NSData *,NSURLResponse *);
//typedef void (^AsyncRequestFailureBlock)(NSData *,NSError *);
//再来看看 swift 的 typealias
//typealias AsyRequestSuccessBlock = (data:NSData, response:NSURLResponse)->Void
//typealias AsyRequestFailureBlock = (data:NSData, error:NSError)->Void
//是不是很有相似之处
//下面给大家一个实例
//extension NSURLConnection{
//    class func httpAsyncRequest(request:NSURLRequest, successBlock:AsyRequestSuccessBlock, failureBlock:AsyRequestFailureBlock){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//            var response:NSURLResponse? = nil
//            var error:NSError? = nil
//            var data :NSData? = nil
//            data = self.sendSynchronousRequest(request, returningResponse: &response, error: &error)
//            if error == nil {
//                successBlock(data: data!, response: response!)
//            } else{
//                failureBlock(data: data!, error: error!)
//            }
//        })
//    }
//}

//class NetWorkData {
//    var net : AFHTTPRequestOperation!
//    typealias NetBlock = (result:Any?,  status:NetStatus) ->(Void)
//    
////    typealias AsyRequestSuccessBlock = (data:NSData, response:NSURLResponse)->Void
////    typealias Block = ( s: String)->Void
//    init(){
////      net = AFHTTPRequestOperation()
//    }
//    
//    
//    func getRootData(block:NetBlock){
//    
////        let tuple = (3,"ddd")
//        
//        
//       let url = "http://test.mbianli.com:8099/api/app/exhibition/index?id=1"
//        
//        self.getMethodRequest(url) { (result, status) -> (Void) in
//            
//            switch status {
//            
//            case let .NetWorkStatusError(err):
//              block(result: err, status: status)
//                return
//                
//            case let .NetWorkStatusSucess(number):
//                print(number)
//                
//            }
//            
//            if let dic = result as? [String:Any] {
//               
//                guard let data = dic["data"] as? [String: AnyObject], let list = data["buzs"] as? [[String:String]]
//                    else {
//                   
//                   return
//                }
//                
//                var exhibitorArr = [ExhibitorData]()
//                for temp in list
//                {
//                    let data = ExhibitorData(address: temp["addr"], id: temp["exhibition_id"]!, name: temp["name_zh"], iconUrl: temp["logo_url"], addressMap: temp["booth_url"], webLink: temp["website"])
//                    exhibitorArr.append(data)
//                }
//
//                
//                
//                var pics = [(id:String,url:String)]()
//                
//                guard let info = data["exhibition"] as? [String:AnyObject], let picArr = info["pics"] as? [[String:AnyObject]]
//                    else {
//                
//                   return
//                }
//                
//                for temp in picArr
//                {
//                    guard let url = temp["pic_url"] as? String , let link = temp["intro_url"] as? String
//                        else
//                    {
//                       return
//                    }
//                   pics.append((id: link , url: url))
//                }
//                
//                
//                
//                var newArr = [(link:String,title:String,content:String,time:String)]()
//                guard let news = data["news"] as? [[String:AnyObject]] else{return }
//                
//                for t in news {
//                
//                    guard let title = t["title"] as? String, let link = t["url"] as? String,let content = t["content"] as? String, let time = t["create_time"] as? Int
//                    else
//                    {
//                      return
//                    }
//                    
//                    newArr.append((link: link, title: title, content: content  , time: String(time)))
//                
//                }
//                
//                
//                
//                
//                guard let schedulers = data["schedules"] as? [[String:AnyObject]] else {return }
//                
//                var schedulerArr = [SchedulerData]()
//                for t in schedulers
//                {
//                   guard let name = t["name"] as? String,let content = t["content"] as? String,let address = t["addr"] as? String ,let time = t["time"] as? Int,let id = t["id"] as? String
//                   else { return }
//                
//                    let s = SchedulerData(time: String(time), date: "dd", title: name, introduce: content, address: address, id: id)
//                    schedulerArr.append(s)
//                }
//                
//                
////                block(result: (pics,exhibitorArr,schedulerArr ), status: status)
//            }
//            
//        }
//    }
//    
//    
//    func getMethodRequest(url:String,completeBlock:NetBlock){
//    
//        net = AFHTTPRequestOperation(request: NSURLRequest(URL: NSURL(string: url)!))
//    
//        net.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, result:AnyObject!) -> Void in
//            if let jsonData = result as? NSData
//            {
//                  if let json = try?  NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments)
//                  {
//                   completeBlock(result: json, status: .NetWorkStatusSucess(0))
//                }
//            }
//            
//            }) { ( operating:AFHTTPRequestOperation!, err:NSError!) -> Void in
//                completeBlock(result: nil, status: .NetWorkStatusError("网络错误"))
//        }
//        
//    }
//    
//    func start(){
//    
//      net.start()
//    }
//}