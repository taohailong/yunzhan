//
//  Scheduler.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class SchedulerController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    var net:NetWorkData!
    var dataArr:[[SchedulerData]]!
    var dateArr:[String]!
    var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-3_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        
        self.title = "日程"
        let searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width(),45))
        
        searchBar.delegate = self
        
//        let searchC = UISearchDisplayController(searchBar: <#T##UISearchBar#>, contentsController: <#T##UIViewController#>)
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = searchBar
        table.translatesAutoresizingMaskIntoConstraints = false
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
        self.view.addSubview(table)
        
        table.registerClass(SchedulerCell.self , forCellReuseIdentifier: "SchedulerCell")
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.fetchData()
    }
    
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    
    
    
    func fetchData(){

        weak var wself = self
        net = NetWorkData()
        net.getSchedulList { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
              return
            }
            
            let tuple = result as! (schedulerList:[[SchedulerData]],dateArr:[String])
            wself?.dataArr = tuple.schedulerList
            wself?.dateArr = tuple.dateArr
            wself?.table.reloadData()
        }
        net.start()
//        let a = SchedulerData(time: "20:00", date: "06/11", title: "爱玛电动车", introduce: "新品发布会", address: "五号展厅", id: "123456")
//        
//        let b = SchedulerData(time: "20:00", date: "06/11", title: "爱玛电动车", introduce: "新品发布会", address: "五号展厅", id: "123456")
//        
//        dataArr = [[a],[b]]
      
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if dataArr == nil
        {
          return 0
        }
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subArr = dataArr[section]
        return subArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let head = dateArr[section]
        return head
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let subArr = dataArr[indexPath.section]
        let schedule = subArr[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerCell") as! SchedulerCell
        cell.fullDataToCell(schedule)
        
        return cell
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
//        timeL.font = Profile.font(10)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        dateL = UILabel()
        dateL.translatesAutoresizingMaskIntoConstraints = false
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        introduce = UILabel()
        introduce.translatesAutoresizingMaskIntoConstraints = false
        
        address = UILabel()
        address.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        timeL.textColor = Profile.rgb(51, g: 51, b: 51)
        timeL.font = Profile.font(15)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
        //         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: timeL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -15))
        
        
        
        
        let spot = UIView()
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 4.0
        
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-15-[spot(8)]", options: [], metrics: nil, views: ["spot":spot,"timeL":timeL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
        dateL.textColor = Profile.rgb(153, g: 153, b: 153)
        dateL.font = Profile.font(13)
        
        self.contentView.addSubview(dateL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-17-[dateL]", options: [], metrics: nil, views: ["dateL":dateL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: dateL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 10))
        
        
        introduce.textColor = Profile.rgb(102, g: 102, b: 102)
        introduce.font = Profile.font(13)
        self.contentView.addSubview(introduce)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-35-[introduce]-(>=2)-|", options: [], metrics: nil, views: ["introduce":introduce,"timeL":timeL]))
        
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
        
        
        self.contentView.addSubview(typeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(typeL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[titleL]-10-[typeL]", options: [], metrics: nil, views: ["typeL":typeL,"titleL":titleL]))
        
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
