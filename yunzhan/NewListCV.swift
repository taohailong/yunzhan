//
//  NewListCV.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/20.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class NewsListVC:UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var net:NetWorkData!
    var dataArr:[NewsData]!
    var table: UITableView!
    var refreshV:THLRefreshView!
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if dataArr == nil
//        {
//           self.refreshControl?.beginRefreshing()
//        }
//       
//    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.dataSource = self
        table.delegate = self
        table.registerClass(NewCell.self , forCellReuseIdentifier: "NewCell")
        table.tableFooterView = UIView()
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.newsRefresh()
    }

    func newsRefresh(){
        
        weak var wself = self
        
        refreshV = THLRefreshView()
        refreshV.isManuallyRefreshing = true
        refreshV.setBeginRefreshBlock { () -> Void in
             wself?.fetchData()
        }
        refreshV.addToScrollView(table);

    }

    
    func fetchData(){
        
        weak var wself = self
        net = NetWorkData()
        net.getNewsList { (result, status) -> (Void) in
            
            wself?.refreshV.endRefreshing()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let warnV = THActivityView(string: "网络错误")
                    warnV.show()
//                    let errView = THActivityView(netErrorWithSuperView: wself!.tableView)
//                    errView.translatesAutoresizingMaskIntoConstraints = true
//                    errView.frame = (wself?.tableView.bounds)!
//                    weak var werr = errView
//                    errView.setErrorBk({ () -> Void in
//                        wself?.fetchData()
//                        werr?.removeFromSuperview()
//                    })
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
            
            guard let arr = result as? [NewsData] else { return }
            
            
            if arr.count == 0
            {
                _ = THActivityView(emptyDataWarnViewWithString: "没有相关新闻哦", withImage: "noNewData", withSuperView: wself?.view)
                wself?.dataArr = [NewsData]()
                wself?.table.reloadData()
                return

            }
           
            wself?.dataArr = arr
            wself?.table.reloadData()
        }
        net.start()
        
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if dataArr == nil
        {
            return 0
        }
        return dataArr.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewCell") as! NewCell
        let new = dataArr[indexPath.row]
        cell.fillData(new)
        return cell
    }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let new = dataArr[indexPath.row]
        let web = CommonWebController(url: new.link)
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
    

}