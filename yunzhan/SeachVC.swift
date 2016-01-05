//
//  SeachVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/24.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class GlobalSearchVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate {
    
    var net:NetWorkData!
    var exhibitorArr : [ExhibitorData]!
    var schedulerArr : [SchedulerData]!
    var emptyView:THActivityView?
    var list:[[AnyObject]]!
    var searchBar:UISearchBar!
    var table:UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let application = UIApplication.sharedApplication()
        application.setStatusBarStyle(.Default, animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        let navBack = UIView(frame: CGRectMake(0,0,Profile.width()-30,30))
        searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width()-80,30))
        searchBar.delegate = self
        searchBar.placeholder = "搜索展商、活动"
        searchBar.changeSearchBarBackColor(UIColor.whiteColor())
        navBack.addSubview(searchBar)
        
        
        let cancelBt = UIButton(type: .Custom)
        cancelBt.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)+10, 0, 45, 30)
        navBack.addSubview(cancelBt)
        cancelBt.titleLabel?.font = Profile.font(16)
        cancelBt.setTitle("取消", forState: .Normal)
        cancelBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        cancelBt.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)
        
        
         self.navigationItem.titleView = navBack
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(SearchTableFootCell.self , forCellReuseIdentifier: "SearchTableFootCell")
        table.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        table.registerClass(SearchExhibitorCell.self, forCellReuseIdentifier: "SearchExhibitorCell")
        table.registerClass(SearchSchedulerCell.self, forCellReuseIdentifier: "SearchSchedulerCell")
        self.view.addSubview(table)
        
//        let foot = UIView(frame: CGRectMake(0,Profile.width)
//        table.tableFooterView =
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[searchBar]-5-[table]-0-|", options: [], metrics: nil, views: ["searchBar":searchBar,"table":table]))
        
         self.emptyView = THActivityView(emptyDataWarnViewWithString: "未搜索内容", withImage: "noSearchData", withSuperView: self.view)
    }
    
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchSearchData(searchBar.text!)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.fetchSearchData(searchBar.text!)
        searchBar.resignFirstResponder()
    }

    
    func fetchSearchData(search:String){
       
        if  search.isEmpty == true
        {
           return
        }
        
        let load = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
       net = NetWorkData()
       net.getGlobalSearchResult(search) { (result, status) -> (Void) in
        
        if wself?.emptyView?.superview != nil
        {
           wself?.emptyView?.removeFromSuperview()
        }
        load.removeFromSuperview()
        if status == .NetWorkStatusError
        {
            if let string = result as? String
            {
                let warnV = THActivityView(string: string)
                warnV.show()
            }
        }
        else
        {
            if result is [[AnyObject]]{
               
                wself?.list = result as! [[AnyObject]]
                wself?.table.reloadData()
                
                if wself?.list.count == 0
                {
                     wself?.emptyView = THActivityView(emptyDataWarnViewWithString: "没有搜索到相关内容", withImage: "noSearchData", withSuperView: wself?.view)
                }
            }
        }
        
        }
       net.start()
    }
    
    func cancelAction(){
       self.dismissViewControllerAnimated(true) { () -> Void in
        
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if list == nil
        {
           tableView.separatorStyle = .None
          return 0
        }
        tableView.separatorStyle = .SingleLine
        return list.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sub = list[section]
        
        if sub.count < 5
        {
          return sub.count
        }
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 4
        {
           return 35
        }

        
        let subArr = list[indexPath.section]
        if subArr is [ExhibitorData]{
            
            return 60
        }
        else
        {
            return 40
        }

    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let foot = tableView.dequeueReusableHeaderFooterViewWithIdentifier("UITableViewHeaderFooterView")
        foot?.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        return foot
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableHeadView") as! TableHeadView
        head.contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        head.contentL.font = Profile.font(13)
        head.contentView.backgroundColor = UIColor.whiteColor()
        let subArr = list[section]
        if subArr is [ExhibitorData]{
            
            head.contentL.text = "展商"
        }
        else
        {
            head.contentL.text = "日程"
        }
        
        return head

     }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let subArr = list[indexPath.section]
        
        if indexPath.row == 4
        {
            let cell =  tableView.dequeueReusableCellWithIdentifier("SearchTableFootCell") as! SearchTableFootCell
            if subArr is [ExhibitorData]{
                
                cell.title.text = "查看更多展商"
            }
            else
            {
                cell.title.text = "查看更多日程"
            }
            return cell
        }

        
        if let element = subArr[indexPath.row] as? ExhibitorData
        {
           let cell =  tableView.dequeueReusableCellWithIdentifier("SearchExhibitorCell") as! SearchExhibitorCell
           cell.fillData(element)
           return cell
        }
        else
        {
             let element = subArr[indexPath.row] as! SchedulerData
            let cell =  tableView.dequeueReusableCellWithIdentifier("SearchSchedulerCell") as! SearchSchedulerCell
            cell.titleL.text = "\(element.date)-\(element.time)"
            cell.contentL.attributedText = element.searchAttribute
            return cell

        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let subArr = list[indexPath.section]
        if indexPath.row == 4
        {
            let subVC = SearchListVC()
            
            subVC.list = subArr
            self.navigationController?.pushViewController(subVC, animated: true)
              return
        }
        
        
        if let element = subArr[indexPath.row] as? ExhibitorData
        {
           let exhibitorVC = ExhibitorController()
            exhibitorVC.id = element.id
            self.navigationController?.pushViewController(exhibitorVC, animated: true)
        }
        else
        {
            let element = subArr[indexPath.row] as! SchedulerData
            
            let schedulerVc = SchedulerInfoVC()
            schedulerVc.schedulerID = element.id
            self.navigationController?.pushViewController(schedulerVc, animated: true)
        }


    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if searchBar.isFirstResponder() == true
        {
            searchBar.resignFirstResponder()
        }
        
    }

    
}


class SearchExhibitorCell:ExhibitorCell {
    override func fillData(data: ExhibitorData) {
        
        if data.iconUrl != nil
        {
            contentImage.sd_setImageWithURL(NSURL(string: data.iconUrl!)!, placeholderImage: UIImage(named: "default"))
        }
        titleL.attributedText = data.searchAttribute
        addressL.text = data.location
    }
}

class SearchSchedulerCell: UITableViewCell {
    let titleL:UILabel
    let contentL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(13)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleL)
        self.contentView.addSubview(contentL)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(contentL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-30-[contentL]-15-|", options: [], metrics: nil, views: ["contentL":contentL,"titleL":titleL]))
        self.backgroundColor = UIColor.whiteColor()
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SearchTableFootCell: UITableViewCell {
    
    var title : UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .DisclosureIndicator
        let searchImage = UIImageView(frame: CGRectMake(15, 5, 10, 10))
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchImage.image = UIImage(named: "searchVC_search")
        self.contentView.addSubview(searchImage)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(searchImage, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[searchImage]", aView: searchImage, bView: nil ))
        
        
        title = UILabel(frame: CGRectMake(CGRectGetMaxX(searchImage.frame)+5, 5, 200, 12))
        self.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Profile.rgb(116, g: 158, b: 197)
        title.font = Profile.font(11)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(title, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[searchImage]-5-[title]", aView: searchImage, bView: title ))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchListVC: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    var list:[AnyObject]!
    var table:UITableView!
     var searchBar:UISearchBar!
    var searchArr:[AnyObject]!
    var emptyView:THActivityView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatSearchView()
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
//        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(SearchTableFootCell.self , forCellReuseIdentifier: "SearchTableFootCell")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        table.registerClass(SearchExhibitorCell.self, forCellReuseIdentifier: "SearchExhibitorCell")
        table.registerClass(SearchSchedulerCell.self, forCellReuseIdentifier: "SearchSchedulerCell")
        table.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        table.tableFooterView = UIView()
    }
    
    func creatSearchView()
    {
        let navBack = UIView(frame: CGRectMake(0,0,Profile.width()-60,30))
//        navBack.backgroundColor = UIColor.redColor()
        searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width()-110,30))
        searchBar.delegate = self
        searchBar.changeSearchBarBackColor(UIColor.whiteColor())
        navBack.addSubview(searchBar)
        
        
        let cancelBt = UIButton(type: .Custom)
        cancelBt.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)+10, 0, 45, 30)
        navBack.addSubview(cancelBt)
        cancelBt.titleLabel?.font = Profile.font(16)
        cancelBt.setTitle("取消", forState: .Normal)
        cancelBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        cancelBt.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)

        
        self.navigationItem.titleView = navBack
        
        
        
        let backBt = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .Plain, target: self, action: "navPopOut")
        self.navigationItem.leftBarButtonItem = backBt
        //            self.navigationItem.backBarButtonItem

    }

    func navPopOut(){
    
       self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchSearchArr(searchBar.text!)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.fetchSearchArr(searchBar.text!)
    }

    func fetchSearchArr(searchStr:String){
        
        if searchStr.isEmpty == true
        {
          return
        }
        
        
        if list is [ExhibitorData]
        {
          weak var wself = self
          let net = NetWorkData()
            net.searchExhibitor(searchStr, block: { (result, status) -> (Void) in
                
                if wself?.emptyView?.superview != nil
                {
                    wself?.emptyView?.removeFromSuperview()
                }

                if status == .NetWorkStatusError
                {
                    if let string = result as? String
                    {
                        let warnV = THActivityView(string: string)
                        warnV.show()
                    }
                }

                if let earr = result as? [ExhibitorData]
                {
                   wself?.getSearchDataBack(earr)
                }
            })
            net.start()
        }
        else
        {
            
            weak var wself = self
            let net = NetWorkData()
            net.searchScheduler(searchStr, block: { (result, status) -> (Void) in
                
                if status == .NetWorkStatusError
                {
                    if let string = result as? String
                    {
                        let warnV = THActivityView(string: string)
                        warnV.show()
                    }
                }
                
                if let earr = result as? [SchedulerData]
                {
                    wself?.getSearchDataBack(earr)
                }
            })
            net.start()

        }
    }
    
    func getSearchDataBack(arr:[AnyObject])
    {
        
        if self.emptyView?.superview != nil
        {
            self.emptyView?.removeFromSuperview()
        }

        if arr.count == 0
        {
           self.emptyView = THActivityView(emptyDataWarnViewWithString: "没有搜索到相关内容", withImage: "noSearchData", withSuperView: self.view)
        }
        
        self.searchArr = arr
        self.table.reloadData()
    }
    
    func cancelAction(){
        self.navigationController!.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if list == nil
        {
//            tableView.separatorStyle = .None
            return 0
        }
//        tableView.separatorStyle = .SingleLine
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var subArr :[AnyObject]! = nil
        if self.searchArr == nil
        {
            subArr = list
        }
        else
        {
            subArr = searchArr
        }
        if subArr == nil
        {
            return 0
        }
        return subArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var subArr :[AnyObject]! = nil
        if self.searchArr == nil
        {
            subArr = list
        }
        else
        {
            subArr = searchArr
        }

        
        if subArr is [ExhibitorData]{
            
            return 60
        }
        else
        {
            return 40
        }
        
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let foot = tableView.dequeueReusableHeaderFooterViewWithIdentifier("UITableViewHeaderFooterView")
//        foot?.contentView.backgroundColor = UIColor.whiteColor()
//        return foot
//    }

    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableHeadView") as! TableHeadView
        head.contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        head.contentL.font = Profile.font(13)
        head.contentView.backgroundColor = UIColor.whiteColor()
        
        var subArr :[AnyObject]! = nil
        if self.searchArr == nil
        {
          subArr = list
        }
        else
        {
           subArr = searchArr
        }
        
        if subArr is [ExhibitorData]{
            
            head.contentL.text = "展商"
        }
        else
        {
            head.contentL.text = "日程"
        }
        
        return head
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var subArr :[AnyObject]! = nil
        if self.searchArr == nil
        {
            subArr = list
        }
        else
        {
            subArr = searchArr
        }

        
         if let element = subArr[indexPath.row] as? ExhibitorData
        {
            let cell =  tableView.dequeueReusableCellWithIdentifier("SearchExhibitorCell") as! SearchExhibitorCell
            cell.fillData(element)
            return cell
        }
        else
        {
            let element = subArr[indexPath.row] as! SchedulerData
            let cell =  tableView.dequeueReusableCellWithIdentifier("SearchSchedulerCell") as! SearchSchedulerCell
            cell.titleL.text = "\(element.date)-\(element.time)"
            cell.contentL.attributedText = element.searchAttribute
            return cell
            
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var subArr :[AnyObject]! = nil
        if self.searchArr == nil
        {
            subArr = list
        }
        else
        {
            subArr = searchArr
        }

        
        if let element = subArr[indexPath.row] as? ExhibitorData
        {
            let exhibitorVC = ExhibitorController()
            exhibitorVC.id = element.id
            self.navigationController?.pushViewController(exhibitorVC, animated: true)
        }
        else
        {
            let element = subArr[indexPath.row] as! SchedulerData
            
            let schedulerVc = SchedulerInfoVC()
            schedulerVc.schedulerID = element.id
            self.navigationController?.pushViewController(schedulerVc, animated: true)
        }
        
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if searchBar.isFirstResponder() == true
        {
            searchBar.resignFirstResponder()
        }
        
    }

    
}

