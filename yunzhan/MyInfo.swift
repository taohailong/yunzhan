//
//  MyInfo.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/31.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class MyInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView!
//    var 
    weak var nameField:UITextField!
    weak var jobField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的信息"
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.delegate = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.separatorStyle = .SingleLine
        table.dataSource = self
        table.registerClass(UserInfoCell.self, forCellReuseIdentifier: "UserInfoCell")
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        let rightBt = UIButton(type: .Custom)
        rightBt.titleLabel?.font = Profile.font(17)
        rightBt.frame = CGRectMake(0, 0, 40, 30)
        rightBt.setTitleColor(Profile.NavBarColor(), forState: .Normal)
        rightBt.setTitle("提交", forState: .Normal)
        rightBt.addTarget(self, action: "commitAction", forControlEvents: .TouchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBt)
    }
    
    func commitAction(){
       
        let name = nameField.text
        let title = jobField.text
        
        if name?.isEmpty == true
        {
            let load = THActivityView(string: "请输入您的姓名")
            load.show()
            return
        }
        
        var warnStr = ""
        if title?.characters.count > 10
        {
           warnStr = "职称超过10个字符"
        }
        
        if name?.characters.count > 5
        {
           warnStr = "姓名超过5个字符"
        }
        if warnStr.isEmpty != true
        {
            let load = THActivityView(string: warnStr)
            load.show()
            return
        }
        
        weak var wself = self
        let load = THActivityView(activityViewWithSuperView: self.view)
       let net = NetWorkData()
        net.updateUserInfo(name, job: title) { (result, status) -> (Void) in
            load.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if let string = result as? String
                {
                    let warnV = THActivityView(string: string)
                    warnV.show()
                }
            }
            wself?.navigationController?.popViewControllerAnimated(true)
        }
        net.start()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell") as! UserInfoCell
        
        
        let userData = UserData.shared
        if indexPath.row == 0
        {
            cell.imageView?.image = UIImage(named: "userinfo_name")
            nameField =  cell.textField
            nameField.text = userData.name
            nameField.placeholder = "请输入您的姓名"
        }
        else
        {
            cell.imageView?.image = UIImage(named: "userinfo_job")
            jobField =  cell.textField
            jobField.text = userData.title
            jobField.placeholder = "请输入您的职称"
        }
        return cell
    }
}

class UserInfoCell: UITableViewCell {
    let textField : UITextField
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textField = UITextField()
        textField.font = Profile.font(13)
        textField.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(textField)
        self.selectionStyle = .None
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(textField, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-50-[textField]-5-|", aView: textField, bView: nil))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
