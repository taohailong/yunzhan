//
//  MyFavorite.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class MySchedulerListVC: SchedulerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
        self.title = "我的活动"
        table.tableHeaderView = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func fetchData() {
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.myFavoriteScheduler { (result, status) -> (Void) in
            
            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.view)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchData()
                        werr?.removeFromSuperview()
                    })
                }
                else
                {
                    if let warnStr = result as? String
                    {
                        let warnView = THActivityView(string: warnStr)
                        warnView.show()
                    }
                }
                return
            }
            
            
            let tuple = result as! (schedulerList:[[SchedulerData]],dateArr:[String])
            
            if tuple.dateArr.count == 0
            {
                let nodataV = THActivityView(emptyDataWarnViewWithString: "您还没有收藏活动", withImage: "noSchedulerData", withSuperView: wself!.view)
                nodataV.tag = 10
                return
            }
        
            wself?.dataArr = tuple.schedulerList
            wself?.dateArr = tuple.dateArr
            wself?.table.reloadData()
        }
        net.start()
    
    }
    
    
    //    滑动删除 部分
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
        weak var wself = self
        let delectNet = NetWorkData()
        delectNet.delectMyScheduler(p.id, block: { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                return
            }
            
            let subA = wself?.dataArr[indexPath.section]
            wself?.dateArr.removeAtIndex(indexPath.section)
            subArr.removeAtIndex(indexPath.row)
            wself?.dataArr.removeAtIndex(indexPath.section)
            
            if subArr.count != 0
            {
               wself?.dataArr.insert(subA!, atIndex: indexPath.section)
            }
            
            wself?.table.reloadData()
        })
        
        delectNet.start()
    }
    
}



class MyExhibitorList: Exhibitor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
        self.title = "我的展商"
        table.tableHeaderView = nil
    }

    override func setNavgationBarAttribute(change: Bool) {
        
    }
   override func fetchExhibitorData(){
    
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.myFavoriteExhibitor { (result, status) -> (Void) in
            
            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.view)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchExhibitorData()
                        werr?.removeFromSuperview()
                    })
                }
                else
                {
                    if let warnStr = result as? String
                    {
                        let warnView = THActivityView(string: warnStr)
                        warnView.show()
                    }
                }
                return
            }
            
            guard let list = result as? (prefixArr:[String],list:[[ExhibitorData]])
                else{
                    return
            }
            
            if list.prefixArr.count == 0
            {
                let nodataV = THActivityView(emptyDataWarnViewWithString: "您还没有收藏活动", withImage: "noExhibitorData", withSuperView: wself!.view)
                nodataV.tag = 10
                return
            }
            
            wself?.dataArr = list.list
            print(list.list)
            wself?.prefixArr = list.prefixArr
            wself?.table.reloadData()
        }
        net.start()
        
    }
    
    
    //    滑动删除 部分
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
        weak var wself = self
        let delectNet = NetWorkData()
        delectNet.delectMyExhibitor(p.id, block: { (result, status) -> (Void) in
            
            
            if status == .NetWorkStatusError
            {
                return
            }
            
            let subA = wself?.dataArr[indexPath.section]
            subArr.removeAtIndex(indexPath.row)
            wself?.prefixArr?.removeAtIndex(indexPath.section)
            
            wself?.dataArr.removeAtIndex(indexPath.section)
            
            if subArr.count != 0
            {
                wself?.dataArr.insert(subA!, atIndex: indexPath.section)
            }
            
            wself?.table.reloadData()
        })
        
        delectNet.start()
    }
    
    
}
