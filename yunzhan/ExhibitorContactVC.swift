//
//  ExhibitorContactVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/14.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class ExhibitorContactVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let net = NetWorkData()
    var table:UITableView!
    var tableHeadArr = [String]()
    var tableContentArr = [[NSAttributedString]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "组委会和重要联系人"
        table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.tableFooterView = UIView()
        table.tableHeaderView = UIView(frame: CGRectMake(0,0,Profile.width(),5))
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 45
        table.registerClass(SchedulerInfoTitleHeadView.self , forHeaderFooterViewReuseIdentifier: "SchedulerInfoTitleHeadView")
        table.registerClass(ExhibitorAdCommonCell.self, forCellReuseIdentifier: "ExhibitorAdCommonCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.fetchContactData()
        
    }
    
    
    func fetchContactData(){
    
        weak var wself = self
        let load = THActivityView(activityViewWithSuperView: self.view)
       net.exhibitorAdvertiseContact { (result, status) -> (Void) in
        
        load.removeFromSuperview()
        if status == .NetWorkStatusError
        {
          return
        }
        
        if let compose = result as? (title:[String],content:[[NSAttributedString]])
        {
           wself?.tableHeadArr = compose.title
           wself?.tableContentArr = compose.content
            wself?.table.reloadData()
        }
      }
      net.start()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableHeadArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableContentArr[section].count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SchedulerInfoTitleHeadView") as! SchedulerInfoTitleHeadView
        head.titleL.textColor = UIColor.rgb(51, g: 51, b: 51)
        head.titleL.text = tableHeadArr[section]
        return head
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorAdCommonCell") as! ExhibitorAdCommonCell
        cell.title.attributedText = tableContentArr[indexPath.section][indexPath.row]
        return cell
    }
}

class ExhibitorAdCommonCell: UITableViewCell {
    let title:UILabel
//    let title:UITextView

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        title = UILabel()
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(title)
        
        let left = NSLayoutConstraint(item: title, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1.0, constant: 29.5)
        self.contentView.addConstraint(left)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: title, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1.0, constant: 15))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-7-[title]-7-|", aView: title, bView: nil))
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
