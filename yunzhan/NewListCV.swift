//
//  NewListCV.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/20.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class NewsListVC:PullDownTableViewController {
    
    var net:NetWorkData!
    var dataArr:[NewsData]!
//    var table: UITableView!
    
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
        
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(NewCell.self , forCellReuseIdentifier: "NewCell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(self.tableView))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(self.tableView))
        
        self.newsRefresh()
    }

    func newsRefresh(){
        
        weak var wself = self
        let height = Profile.height() - 153
        
        self.addHeadViewWithTableEdge(UIEdgeInsetsMake(0, 0, 0, 0), withFrame: CGRectMake(0.0, 0 - height,Profile.width(),height)) { () -> Void in
            wself?.fetchData()
        }
        
        self.headViewBeginLoading()
    }

    
    func fetchData(){
        
        weak var wself = self
        net = NetWorkData()
        net.getNewsList { (result, status) -> (Void) in
            
            wself?.headViewEndLoading()
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
                wself?.tableView.reloadData()
                return

            }
           
            wself?.dataArr = arr
            wself?.tableView.reloadData()
        }
        net.start()
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if dataArr == nil
        {
            return 0
        }
        return dataArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewCell") as! NewCell
        let new = dataArr[indexPath.row]
        cell.fillData(new)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
override     
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let new = dataArr[indexPath.row]
        let web = CommonWebController(url: new.link)
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
    

}