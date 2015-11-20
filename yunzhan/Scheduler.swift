//
//  Scheduler.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class SchedulerController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate {
    var net:NetWorkData!
//    var test:[T]?
    var dataArr:[[SchedulerData]]!
    var dateArr:[String]!
    var table:UITableView!
    var searchArr:[SchedulerData]!
    var searchCV:UISearchDisplayController!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
    func setNavgationBarAttribute(change:Bool)
    {
        if change == true
        {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.LightContent, animated: true)
        }
        else
        {
            if self.navigationController?.viewControllers.count == 1
            {
                return
            }
            self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.Default, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-3_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
//        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        
        let dict = [NSFontAttributeName: Profile.font(18)]
        self.navigationController!.navigationBar.titleTextAttributes = dict
        
        
        self.title = "日程"
        let searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width(),45))
        
//        searchBar.delegate = self
        
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.tableHeaderView = searchBar
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
        table.registerClass(TableHeadView.self , forHeaderFooterViewReuseIdentifier: "TableHeadView")
        self.view.addSubview(table)
        
        table.registerClass(SchedulerCell.self , forCellReuseIdentifier: "SchedulerCell")
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        
        searchCV = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchCV.searchResultsDelegate = self
        searchCV.searchResultsDataSource = self
        searchCV.delegate = self
        searchCV.searchResultsTableView.registerClass(ExhibitorCell.self, forCellReuseIdentifier: "ExhibitorCell")
        
        self.fetchData()
    }
    
    
//    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        searchBar.setShowsCancelButton(true, animated: true)
//        return true
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
    
    
    
    
    func fetchData(){
       
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.getSchedulList { (result, status) -> (Void) in
            
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
            wself?.dataArr = tuple.schedulerList
            wself?.dateArr = tuple.dateArr
            wself?.table.reloadData()
        }
        net.start()
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView != table
        {
           return 1
        }
        
        if dataArr == nil
        {
          return 0
        }
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView != table
        {
            if searchArr == nil
            {
                return 0
            }
            return (searchArr?.count)!
        }
        
        let subArr = dataArr[section]
        return subArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView != table
        {
            return nil
        }
        
        let headData = dateArr[section]
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableHeadView") as! TableHeadView
        let attribute = NSMutableAttributedString(string: headData, attributes: [NSFontAttributeName:Profile.font(15),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)])
        head.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        head.contentL.attributedText = attribute
        return head
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != table
        {
            return 0
        }

        return 40
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let head = dateArr[section]
//        return head
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cellData:SchedulerData? = nil
        if tableView != table
        {
            cellData = searchArr![indexPath.row]
        }
        else
        {
            let subArr = dataArr[indexPath.section]
            cellData = subArr[indexPath.row]
        }
        
        let cell = table.dequeueReusableCellWithIdentifier("SchedulerCell") as! SchedulerCell
        cell.fullDataToCell(cellData!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var data:SchedulerData!
        if tableView != table
        {
           data = searchArr[indexPath.row]
        }
        else
        {
            let subArr = dataArr[indexPath.section]
            data = subArr[indexPath.row]
        }
        
        let schedulerInfo = SchedulerInfoVC()
        schedulerInfo.schedulerID = data.id
        schedulerInfo.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(schedulerInfo, animated: true)
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        if let s = searchString where s.isEmpty == false
        {
            self.fetchSearchData(s)
        }
        
        if searchArr == nil
        {
            return false
        }
        else
        {
            return true
        }
    }

    
    
    
    func fetchSearchData(searchStr:String){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            var allData = [SchedulerData]()
            for subArr in self.dataArr
            {
                for temp in subArr
                {
                    allData.append(temp)
                }
            }
            let predicate = NSPredicate(format: "self contains %@",searchStr)
            
            let search = allData.filter({ (t) -> Bool in
                predicate.evaluateWithObject(t.title)
            })
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.searchArr = search
                self.searchCV.searchResultsTableView.reloadData()
            })
        }
    }

}

class SchedulerCell: UITableViewCell {
    
    let typeL:UILabel
    
    let timeL:UILabel
    let dateL:UILabel
    
    let titleL:UILabel
    let introduce:UILabel
    let address:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        typeL = UILabel()
        typeL.font = Profile.font(11)
        typeL.textColor = Profile.rgb(153, g: 153, b: 153)
        typeL.translatesAutoresizingMaskIntoConstraints = false
    
        timeL = UILabel()
        timeL.font = Profile.font(11)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        dateL = UILabel()
        dateL.font = Profile.font(10)
        dateL.translatesAutoresizingMaskIntoConstraints = false
        
        titleL = UILabel()
        titleL.font = Profile.font(10)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        introduce = UILabel()
        introduce.font = Profile.font(10)
        introduce.translatesAutoresizingMaskIntoConstraints = false
        
        address = UILabel()
        address.font = Profile.font(10)
        address.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        timeL.textColor = Profile.rgb(51, g: 51, b: 51)
        timeL.font = Profile.font(15)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: timeL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -15))
        
        
        let upView = UIView()
        upView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(upView)
        upView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-0-[upView]-0-|", aView: upView, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-74-[upView(0.5)]", options: [], metrics: nil, views: ["upView":upView,"timeL":timeL]))
        
        
        let spot = UIView()
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 4.0
        
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-70-[spot(8)]", options: [], metrics: nil, views: ["spot":spot,"timeL":timeL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
        dateL.textColor = Profile.rgb(153, g: 153, b: 153)
        dateL.font = Profile.font(13)
        
        self.contentView.addSubview(dateL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-17-[dateL]", options: [], metrics: nil, views: ["dateL":dateL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: dateL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 10))
        
        
        introduce.textColor = Profile.rgb(102, g: 102, b: 102)
        introduce.font = Profile.font(13)
        self.contentView.addSubview(introduce)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-40-[introduce]-(>=2)-|", options: [], metrics: nil, views: ["introduce":introduce,"timeL":timeL]))
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(introduce, toItem: self.contentView))
        introduce.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        self.contentView.addSubview(titleL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(titleL, toItem: introduce))
        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -5))
        
        address.textColor = Profile.rgb(153, g: 153, b: 153)
        address.font = Profile.font(13)
        self.contentView.addSubview(address)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(address, toItem: introduce))
        self.contentView.addConstraint(NSLayoutConstraint(item: address, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
    }
    
    
    func fullDataToCell(data:SchedulerData){
        
        timeL.text = data.time
        dateL.text = data.date
        titleL.text = data.title
        introduce.text = data.introduce
        address.text = data.address
       
        if data.type == true
        {
          typeL.text = "类型:公开"
        }
        else
        {
          typeL.text = "类型:不公开"
        }
    }

    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
