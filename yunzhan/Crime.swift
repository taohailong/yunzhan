//
//  Crime.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/3/8.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class CrimeVC:UITableViewController {
    
    var wall_id = ""
    private let net : NetWorkData = NetWorkData()
    private var selectIndex : Int?
    private let contentArr = ["色情低俗","广告骚扰","政治敏感","欺诈骗钱","违法（暴力恐怖）","侵权"]
    override func viewDidLoad() {
        
        self.title = "举报"
        self.settleTable()
        self.creatNavRightBar()
    }

    
    func settleTable()
    {
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        self.tableView.separatorColor = UIColor.rgb(243, g: 243, b: 243)
        self.tableView.registerClass(TableNoSeparateHeadView.self , forHeaderFooterViewReuseIdentifier: "TableNoSeparateHeadView")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func creatNavRightBar(){
    
       let rightBar = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: "rightBarAction")
        rightBar.tintColor = Profile.NavBarColorGenuine
       self.navigationItem.rightBarButtonItem = rightBar
    }
    
    func rightBarAction(){
    
        if selectIndex != nil
        {
            weak var wself = self
           net.warnCrime(wall_id, crimeType:contentArr[selectIndex!] , block: { (result, status) -> (Void) in
            
              if status == .NetWorkStatusError
              {
                 return
              }

               if let mes = result as? String
               {
                  let showV = THActivityView(string: mes)
                  showV.show()
                  wself?.navigationController?.popViewControllerAnimated(true)
               }
            
           })
            net.start()
        }
        else
        {
            let showV = THActivityView(string: "请选择类型")
            showV.show()
        }
      
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArr.count
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableNoSeparateHeadView") as! TableNoSeparateHeadView
        
        headView.contentL.font = Profile.font(15)
        headView.contentL.textColor = UIColor.rgb(153, g: 153, b: 153)
        headView.contentL.text = "请选择举报原因"
        headView.contentView.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        return headView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        cell?.textLabel?.textColor = UIColor.rgb(51, g: 51, b: 51)
        cell?.textLabel?.font = Profile.font(15)
        cell?.textLabel?.text = contentArr[indexPath.row]
    
        return cell!
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if selectIndex != nil
        {
           let previousCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectIndex!, inSection: 0))
            previousCell?.accessoryView = nil
            previousCell?.accessoryType = .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.specialAccessoryType(.Checkmark)
        selectIndex = indexPath.row
    }
    
}