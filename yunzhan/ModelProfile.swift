//
//  ModelProfile.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/2/29.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import UIKit

class ModelProfile: NSObject {
  
 
    class func setModelProfile() {
        
        let net = NetWorkData()
        net.getNetModelProfile { (result, status) -> (Void) in
            
            if let dic = result as? NSDictionary
            {
                ModelProfile.saveProfileData(dic)
            }
        }
        net.start()

    }
    
    private class func saveProfileData(let dic:NSDictionary) {
        
      dic.writeToFile(ModelProfile.getModelProfilePath(), atomically: true)

    }
    
    private class func getModelProfile() ->NSDictionary?{
    
       let dic = NSDictionary(contentsOfFile: ModelProfile.getModelProfilePath())
       return dic
    }
    
    
    private class func getModelProfilePath()->String
    {
        let library = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let jsPath = "\(library[0])/modelConfigure"
        return jsPath
    }

    
    class func needRegistModel()->Bool {
        
        return ModelProfile.getValue("预约报名")
        
    }
    
    
    class func needScroeModel() ->Bool {
        return ModelProfile.getValue("我的积分")
    }
    
    
   private class func getValue(let key:String)->Bool {
        
        let dic = ModelProfile.getModelProfile()
        
        if let b = dic?[key] as? Bool
        {
            return b
        }
        else
        {
            return false
        }

    }
    
}
