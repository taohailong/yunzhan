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
        self.view.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        self.generateRightBarItem()
        
        textField = UITextField()
        textField.leftViewMode = .Always
        textField.leftView = UIView(frame: CGRectMake(0,0,20,10))
        textField.backgroundColor = UIColor.whiteColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(textField))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-75-[textField(45)]", options: [], metrics: nil, views: ["textField":textField]))
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
//        weak var user = UserData.shared
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
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
        
        if section == 0
        {
          return 5
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell") as! UserInfoCell
        
        
        if indexPath.section == 1
        {
            let qr = UIImage(named: "QRUserInfoIcon")
            cell.textLabel?.text = "我的二维码"
            
            let attachment = NSTextAttachment()
            attachment.bounds = CGRectMake(0, 0, 20, 20);
            attachment.image = qr
            let attachStr = NSAttributedString(attachment: attachment)
            cell.accessL.attributedText = attachStr
            return cell
        }
        
        
        cell.accessImage.hidden = false
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
            cell.accessImage.hidden = true
            cell.accessImageLeftSace.constant = 6
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1
        {
           let qrVC = self.navigationController?.storyboard!.instantiateViewControllerWithIdentifier("MyQRVC") as! MyQRVC
            self.navigationController?.pushViewController(qrVC, animated: true)
            return
        }
        
        let modify = ModifyMyInfoVC()
        if indexPath.row == 0{
        
           modify.InfoType = .name
           modify.title = "名称"
            
        }
        else if indexPath.row == 1{
            modify.InfoType = .job
            modify.title = "职位"
        }
        
        else if indexPath.row == 2{
        
            modify.InfoType = .company
            modify.title = "公司"
        }
        else if indexPath.row == 3
        {
            return
        }
        else
        {
            modify.InfoType = .qq
            modify.title = "QQ"
        }
        self.navigationController?.pushViewController(modify, animated: true)
    }
}



class userInfoVC:MyInfoVC {
    
    let user:UserDataModel
    init(user:UserDataModel)
    {
       self.user = user
       super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详细资料"
        table.allowsSelection = false
    }
    
    func creatSubView(){
    
    
        
    
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell") as! UserInfoCell
        cell.accessImage.hidden = true
        cell.accessImageLeftSace.constant = 6
        let userData = user
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
    let accessImage:UIImageView
    var accessImageLeftSace:NSLayoutConstraint!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        accessL = UILabel()
        accessL.textColor = UIColor.rgb(153, g: 153, b: 153)
        accessL.font = Profile.font(12)
        accessL.translatesAutoresizingMaskIntoConstraints = false
        
        
        accessImage = UIImageView()
        accessImage.translatesAutoresizingMaskIntoConstraints = false
        accessImage.image = UIImage(named: "cell_narrow")
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(accessImage)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(accessImage, toItem: self.contentView))
        
        accessImageLeftSace = NSLayoutConstraint(item: accessImage, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1.0, constant: -15)
        self.contentView.addConstraint(accessImageLeftSace)
        
        
        self.contentView.addSubview(accessL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(accessL, toItem: self.contentView))
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[accessL]-10-[accessImage]", aView: accessL, bView: accessImage))
        
        
        self.textLabel?.font = Profile.font(14)
        self.textLabel?.textColor = UIColor.rgb(51, g: 51, b: 51)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: MyQR



class MyQRVC: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var phoneL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
        self.title = "我的二维码"
    }
    
    func fillData(){
       
        let user = UserData.shared
        
        let att = NSMutableAttributedString(string: user.name!, attributes: [NSFontAttributeName:Profile.font(17),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
        
        if let job = user.title,let company = user.company
        {
            att.appendAttributedString(NSAttributedString(string: "  \(job)-\(company)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
        }
        titleL.attributedText = att
       
        phoneL.text = user.phone
        
        let qrStr = "zhangzhantong,\(Profile.exhibitor),\(user.token!)"
        let qrImage = qrStr.toQRImage(300)
        
        qrImageView.image = qrImage
    }
    
}

