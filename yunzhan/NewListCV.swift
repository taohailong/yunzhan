//
//  NewListCV.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/20.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class NewsListVC:UITableViewController {
    
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
        
//        table = UITableView(frame: CGRectZero, style: .Plain)
//        table.dataSource = self
//        table.delegate = self
        tableView.registerClass(NewCell.self , forCellReuseIdentifier: "NewCell")
        tableView.tableFooterView = UIView()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "newsRefreshBegin", forControlEvents: .ValueChanged)

        
//        self.view.addSubview(table)
//        table.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
//        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.fetchData()
    }

    func newsRefreshBegin(){
        
        self.fetchData()
        
    }

    
    func fetchData(){
        
        self.refreshControl?.beginRefreshing()
//        let loadView = THActivityView(activityViewWithSuperView: self.navigationController?.view)
        weak var wself = self
        net = NetWorkData()
        net.getNewsList { (result, status) -> (Void) in
            
            wself?.refreshControl?.endRefreshing()
//            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.tableView.superview)
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
            
            guard let arr = result as? [NewsData] else { return }
            
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