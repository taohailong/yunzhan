//
//  MyFavorite.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class MySchedulerListVC: SchedulerController {
   
    
    override func setNavgationBarAttribute(change: Bool) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
        self.title = "我的活动"
        table.tableHeaderView = nil
        self.fetchData()
    }
    
    
    
    
    override func creatSchedulerTable(){
        
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        //        self.tableView.tableHeaderView = searchBar
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        table.registerClass(SchedulerCell.self , forCellReuseIdentifier: "SchedulerCell")
        self.view.addSubview(table)
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))

        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
    }

    
    override func schedulerRefresh() {
        
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
//                    let warnV = THActivityView(string: "网络错误")
//                    warnV.show()
                    
                    let errView = THActivityView(netErrorWithSuperView: wself?.view)
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
                _ = THActivityView(emptyDataWarnViewWithString: "您还没有收藏活动", withImage: "noSchedulerData", withSuperView: wself!.view)
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
           
            var subA = wself?.dataArr[indexPath.section]
            wself?.dataArr.removeAtIndex(indexPath.section)
            subA?.removeAtIndex(indexPath.row)

            if subA!.count != 0
            {
                wself?.dataArr.insert(subA!, atIndex: indexPath.section)
            }
            else
            {
               wself?.dateArr.removeAtIndex(indexPath.section)
            }

            wself?.table.reloadData()
            
        })
        
        delectNet.start()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var data:SchedulerData!
        let subArr = dataArr[indexPath.section]
        data = subArr[indexPath.row]
        
        weak var wself =  self
        let schedulerInfo = SchedulerInfoVC()
        schedulerInfo.callBlock = { wself?.fetchData() }
        schedulerInfo.schedulerID = data.id
        schedulerInfo.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(schedulerInfo, animated: true)
    }

}



class MyExhibitorList: Exhibitor {
    
    
    override func setNavgationBarAttribute(change: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
        self.title = "我的展商"
    }

    override func creatTable(){
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.sectionIndexBackgroundColor = UIColor.clearColor()
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(self.table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(self.table))
        
    }

    
    override func setupRefresh(){
    
     self.fetchExhibitorData()
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
                    let errView = THActivityView(netErrorWithSuperView: wself?.view)
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
                if wself != nil
                {
                    _ = THActivityView(emptyDataWarnViewWithString: "您还没有收藏展商", withImage: "noExhibitorData", withSuperView: wself?.view)
                }
                return
            }
            
            wself?.dataArr = list.list
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
    
         if (editingStyle != .Delete) {
            return
        }
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
        weak var wself = self
        let delectNet = NetWorkData()
        delectNet.delectMyExhibitor(p.id, block: { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                return
            }
            
//            let subA = wself?.dataArr[indexPath.section]
            subArr.removeAtIndex(indexPath.row)
            wself?.dataArr.removeAtIndex(indexPath.section)
            
            if subArr.count != 0
            {
                wself?.dataArr.insert(subArr, atIndex: indexPath.section)
                
            }
            else
            {
               wself?.prefixArr?.removeAtIndex(indexPath.section)
            }
            
            wself?.table.reloadData()
        })
        
        delectNet.start()
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cellData:ExhibitorData!
        let subArr = dataArr[indexPath.section]
        cellData = subArr[indexPath.row]
    
        weak var wself = self
        let exhibitorCV = ExhibitorController()
        exhibitorCV.callBackBlock = { wself?.fetchExhibitorData() }
        exhibitorCV.title = cellData.name
        exhibitorCV.id = cellData.id
        exhibitorCV.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(exhibitorCV, animated: true)
    }

    
}
