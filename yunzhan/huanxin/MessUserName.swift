//
//  MessUserName.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/11.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class MessageUserNameProfile: NSObject {
    
    static let shareManager = MessageUserNameProfile()
    var userDic:NSMutableDictionary
    private override init() {
        
        let pathArr = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path =  "\(pathArr[0])/userName.plist"
        
        if let dic = NSMutableDictionary(contentsOfFile: path)
        {
           userDic = dic
        }
        else
        {
           userDic = NSMutableDictionary()
        }
        super.init()
    }
    
    func saveName(name:String,key:String)
    {
        
      let originalName = userDic[key] as? String
      if originalName == name
      {
         return
      }
        
       userDic.setValue(name, forKey: key)
        let pathArr = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = "\(pathArr[0])/userName.plist"
       userDic.writeToFile(path, atomically: true)
    }
    
    func userName(key:String)->String{
    
        if let name = userDic[key]
        {
           return name as! String
        }
        return ""
    }
    
}