//
//  SeachVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/24.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class GlobalSearchVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var net:NetWorkData!
    var exhibitorArr : [ExhibitorData]!
    var schedulerArr : [SchedulerData]!
    var emptyView:THActivityView?
    var list:[[AnyObject]]!
    var searchBar:UITextField!
    var table:UITableView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let application = UIApplication.sharedApplication()
        application.setStatusBarStyle(.Default, animated: true)
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
        searchBar = UITextField(frame: CGRectMake(0,0,Profile.width()-80,30))
//        searchBar.keyboardType = .WebSearch
        searchBar.returnKeyType = .Search
        searchBar.font = Profile.font(15)
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.delegate = self

        self.view.addSubview(searchBar)
        
        let leftView = UIImageView(frame: CGRectMake(5, 0, 15, 15))
        leftView.image = UIImage(named: "searchVC_search")
        
        let backLeft = UIView(frame: CGRectMake(0, 0, 25, 15))
        backLeft.addSubview(leftView)
        searchBar.leftView = backLeft
        searchBar.leftViewMode = .Always
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChangeNotification", name: UITextFieldTextDidChangeNotification, object: nil)
        
        navBack.addSubview(searchBar)
        
        
        let cancelBt = UIButton(type: .Custom)
        cancelBt.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)+10, 0, 45, 30)
        navBack.addSubview(cancelBt)
        cancelBt.titleLabel?.font = Profile.font(16)
        cancelBt.setTitle("取消", forState: .Normal)
        cancelBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        cancelBt.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)
        
        
         self.navigationItem.titleView = navBack
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[searchBar]-70-|", options: [], metrics: nil, views: ["searchBar":searchBar]))
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[searchBar(30)]", options: [], metrics: nil, views: ["searchBar":searchBar]))
//        
       
//
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[searchBar]-10-[cancelBt]-15-|", options: [], metrics: nil , views: ["searchBar":searchBar,"cancelBt":cancelBt]))
//        self.view.addConstraint(NSLayoutConstraint.layoutVerticalCenter(cancelBt, toItem: searchBar))
//        
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(SearchTableFootCell.self , forCellReuseIdentifier: "SearchTableFootCell")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        table.registerClass(SearchExhibitorCell.self, forCellReuseIdentifier: "SearchExhibitorCell")
        table.registerClass(SearchSchedulerCell.self, forCellReuseIdentifier: "SearchSchedulerCell")
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[searchBar]-5-[table]-0-|", options: [], metrics: nil, views: ["searchBar":searchBar,"table":table]))
    }

    func textFieldTextDidChangeNotification(){
      print("change \(searchBar.text)")
       self.fetchSearchData(searchBar.text!)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.fetchSearchData(searchBar.text!)
        return true
    }
    

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        print("s \(string) text \(textField.text)  return type \(textField.returnKeyType.rawValue)")
        
        return true
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
           return 30
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
        return 30
    }
    
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let subArr = list[section]
//        
//        if subArr.count < 5
//        {
//            return nil
//        }
//        
//        let foot = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SearchTableFootView") as! SearchTableFootView
//        
//        if subArr is [ExhibitorData]{
//        
//           foot.title.text = "查看更多展商"
//        }
//        else
//        {
//           foot.title.text = "查看更多日程"
//        }
//        
//        return foot
//    }
    
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
            
            let backBt = UIBarButtonItem(title: "", style:.Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backBt
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
        title.font = Profile.font(10)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(title, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[searchImage]-5-[title]", aView: searchImage, bView: title ))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchListVC: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    var list:[AnyObject]!
    var table:UITableView!
     var searchBar:UITextField!
    var searchArr:[AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatSearchView()
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(SearchTableFootCell.self , forCellReuseIdentifier: "SearchTableFootCell")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        table.registerClass(SearchExhibitorCell.self, forCellReuseIdentifier: "SearchExhibitorCell")
        table.registerClass(SearchSchedulerCell.self, forCellReuseIdentifier: "SearchSchedulerCell")
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))

    }
    
    func creatSearchView()
    {
        let navBack = UIView(frame: CGRectMake(0,0,Profile.width()-60,30))
//        navBack.backgroundColor = UIColor.redColor()
        searchBar = UITextField(frame: CGRectMake(0,0,Profile.width()-115,30))
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.delegate = self
        searchBar.font = Profile.font(15)
        self.view.addSubview(searchBar)
        
        let leftView = UIImageView(frame: CGRectMake(5, 0, 15, 15))
        leftView.image = UIImage(named: "searchVC_search")
        
        let backLeft = UIView(frame: CGRectMake(0, 0, 25, 15))
        backLeft.addSubview(leftView)
        searchBar.leftView = backLeft
        searchBar.leftViewMode = .Always
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldTextDidChangeNotification", name: UITextFieldTextDidChangeNotification, object: nil)
        
        navBack.addSubview(searchBar)
        
        
        let cancelBt = UIButton(type: .Custom)
        cancelBt.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)+10, 0, 45, 30)
        navBack.addSubview(cancelBt)
        cancelBt.titleLabel?.font = Profile.font(16)
        cancelBt.setTitle("取消", forState: .Normal)
        cancelBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        cancelBt.addTarget(self, action: "cancelAction", forControlEvents: .TouchUpInside)
        
        
        self.navigationItem.titleView = navBack
    }
    
    func textFieldTextDidChangeNotification(){
        self.fetchSearchArr(searchBar.text!)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.fetchSearchArr(searchBar.text!)
        return true
    }

    func fetchSearchArr(searchStr:String){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            if let tempArr = self.list as? [ExhibitorData]
            {
               var allData = [ExhibitorData]()
               for element in tempArr
               {
                   let name = element.name! as NSString
                   let rang = name.rangeOfString(searchStr)
                   if rang.location == NSNotFound
                   {
                      continue
                   }
                   let att = NSMutableAttributedString(string: element.name!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(16)])
                
                   att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                   element.searchAttribute = att
                   allData.append(element)
                }
                self.searchArr = allData
            }
            else
            {
                let tempArr = self.list as! [SchedulerData]
                var allData = [SchedulerData]()
                
                for element in tempArr
                {
                    let name = element.title! as NSString
                    let rang = name.rangeOfString(searchStr)
                    if rang.location == NSNotFound
                    {
                        continue
                    }
                    let att = NSMutableAttributedString(string: element.title!, attributes: [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName: Profile.font(15)])
                    
                    att.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: rang)
                    element.searchAttribute = att
                    allData.append(element)
                }

                self.searchArr = allData
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
                if self.searchArr.count == 0{
                
                
                }
                self.table.reloadData()
            })
        }
    }
    
    func cancelAction(){
        self.navigationController!.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if list == nil
        {
            tableView.separatorStyle = .None
            return 0
        }
        tableView.separatorStyle = .SingleLine
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
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

