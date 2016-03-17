//
//  JSPatchManager.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/2/1.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import UIKit

class JSPatchManager: NSObject {
static var share = JSPatchManager()
    
     override init() {
        
    }
    
    func setJSpatch(){
    
        
       let path = self.getJsPath()
//        let path = self.getLocalJSFile()
       let script = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
       if script != nil
       {
          self.startJsEngine(script! as String)
       }
       self.fetchJs()
    }
    
    
    func startJsEngine(js:String)
    {
        if js == ""
        {
          return
        }
        JPEngine.startEngine()
        JPEngine.evaluateScript(js)
    }
    
    
    func fetchJs(){
//       print(NSThread.currentThread())
       let url = Profile.globalHttpHead("api/app/tool/readdebug", parameter: "name=\(self.getFileName())")
       let net = NetWorkData()
    
        let wself:JSPatchManager? = self
       net.getMethodRequest(url) { (result, status) -> (Void) in

           
//           print(NSThread.currentThread())
            if status != .NetWorkStatusError
            {
                if let dic = result as? [String:AnyObject]
                {
                   let js = dic["data"] as! String
                   wself?.saveJs(js)
                   
//                    第一次加载完成 本地没有数据时要加载js
                    let path = wself?.getJsPath()
                    let script = try? NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
                    if script == nil
                    {
                        wself?.startJsEngine(js)
                    }
 
                }
           }
           else
          {
            
          }
        
      }
      net.start()
    }

    func saveJs(js:String)
    {
       let path = self.getJsPath()
       _ = try? js.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
       
    }

    func getJsPath()->String
    {
        let library = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let jsPath = "\(library[0])/\(self.getFileName())"
        return jsPath
    }
    
    func getFileName()->String
    {
       let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
       return "\(version!).js"
    }
    
    
    
//    MARK: test
    
    func getLocalJSFile()->String{
    
        let patch = NSBundle.mainBundle().pathForResource("demo", ofType: "js")
        return patch!
    }
    
    func commitJsToServer()
    {
        let patch =  self.getLocalJSFile()
        let script = try! NSString(contentsOfFile: patch, encoding: NSUTF8StringEncoding)
//        let script = ""
    
        let net = NetWorkData()
        net.commitJSToServer(self.getFileName(), text: script as String)
        net.start()
    }
    
    
//   MARK runnloop
    
    func setRunnloop(){
    
    
    }
    
    func removeRunnloop(){
    
      
    }
    
    deinit
    {
       print("deinit")
    }
    
}
