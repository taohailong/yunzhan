//
//  MyRegist.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/25.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class MyRegistVC: UIViewController {
    
    var net:NetWorkData!
    var webV:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webV = UIWebView()
        webV.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webV)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(webV))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(webV))
        self.fetchRegistData()
    }
    
    func fetchRegistData(){
    
        weak var wself = self
       let loadV = THActivityView(activityViewWithSuperView: self.view)
       net = NetWorkData()
       net.getRegistUrl { (result, status) -> (Void) in
        
         loadV.removeFromSuperview()
          if status == .NetWorkStatusError
          {
             return
          }
          if let url = result as? String
          {
             if let u = NSURL(string:url)
             {
                wself?.webV.loadRequest(NSURLRequest(URL:u))
             }
            
          }
        }
        net.start()
    }
    
}