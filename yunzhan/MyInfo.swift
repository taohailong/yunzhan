//
//  MyInfo.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/31.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

enum ModifyUserInfonType:String{
    case qq = "qq"
    case company = "company"
    case name = "name"
    case job = "title"
}
class ModifyMyInfoVC:UIViewController {
    var InfoType:ModifyUserInfonType = .name
    var textField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateRightBarItem()
        
        textField = UITextField()
        textField.backgroundColor = UIColor.whiteColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(textField))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[textField(45)]", options: [], metrics: nil, views: ["textField":textField]))
    }
    
    func generateRightBarItem(){
    
        let rightBt = UIButton(type: .Custom)
        rightBt.titleLabel?.font = Profile.font(17)
        rightBt.frame = CGRectMake(0, 0, 40, 30)
        rightBt.setTitleColor(Profile.NavBarColor(), forState: .Normal)
        rightBt.setTitle("提交", forState: .Normal)
        rightBt.addTarget(self, action: "commitAction", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBt)
    }
    
    
    
    func commitAction(){
       
        let content = textField.text!
        
        if content.isEmpty == true
        {
            let load = THActivityView(string: "请输入")
            load.show()
            return
        }
        
        var warnStr = ""
        if content.characters.count > 6 && InfoType == .job
        {
            warnStr = "职称超过6个字符"
        }
        
        if content.characters.count > 4 && InfoType == .name
        {
            warnStr = "姓名超过4个字符"
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
        net.updateUserInfo(InfoType.rawValue, parameter: content) { (result, status) -> (Void) in
            
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

}





class MyInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView!
    var dataArr:[ModifyUserInfonType] = [ModifyUserInfonType]()
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
        
    }
    
//    func parseDataArr(){
//        
//        let userData = UserData.shared
//        if let title = userData.title
//        
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
          return 5
        }
        return 1
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
        var cellText = ""
        var cellAccessText:String? = ""
        if indexPath.row == 0
        {
            cellText = "名称"
            cellAccessText = userData.name!
        }
        else if indexPath.row == 1
        {
            cellText = "职位"
            cellAccessText = userData.title
        }
        else if indexPath.row == 2
        {
            cellText = "公司"
            cellAccessText = userData.company
        }
        else if indexPath.row == 3
        {
            cellText = "手机号"
            cellAccessText = userData.phone
        }

        else
        {
            cellText = "QQ"
            cellAccessText = userData.qq
        }
        cell.textLabel?.text = cellText
        cell.accessL.text = cellAccessText
        return cell
    }
}

class UserInfoCell: UITableViewCell {
    let accessL : UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        accessL = UILabel()
        accessL.textColor = UIColor.rgb(153, g: 153, b: 153)
        accessL.font = Profile.font(12)
        accessL.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(accessL)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(accessL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[accessL]-10-|", aView: accessL, bView: nil))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
