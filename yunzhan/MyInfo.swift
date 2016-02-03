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
    var originalStr:String?
    var InfoType:ModifyUserInfonType = .name
    var textField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        self.generateRightBarItem()
        
        textField = UITextField()
        textField.text = originalStr
        if InfoType == .qq
        {
          textField.keyboardType = .NumberPad
        }
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
        
        var warnStr = ""
        if content.characters.count > 6 && InfoType == .job
        {
            warnStr = "职称超过6个字符"
        }
        
        if content.isEmpty && InfoType == .name
        {
            warnStr = "姓名不能为空"
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的信息"
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.delegate = self
        table.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.separatorStyle = .SingleLine
        table.dataSource = self
        table.registerClass(UserInfoCell.self, forCellReuseIdentifier: "UserInfoCell")
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
    }
    
    
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
        
        let user = UserData.shared
        let modify = ModifyMyInfoVC()
        if indexPath.row == 0{
        
           modify.InfoType = .name
           modify.originalStr = user.name
           modify.title = "名称"
            
        }
        else if indexPath.row == 1{
            
            modify.InfoType = .job
            modify.originalStr = user.title
            modify.title = "职位"
        }
        
        else if indexPath.row == 2{
            modify.originalStr = user.company
            modify.InfoType = .company
            modify.title = "公司"
        }
        else if indexPath.row == 3
        {
            return
        }
        else
        {
            modify.originalStr = user.qq
            modify.InfoType = .qq
            modify.title = "QQ"
        }
        self.navigationController?.pushViewController(modify, animated: true)
    }
}



class UserInfoVC:UIViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView!
    var user:PersonData!
    var favouriteActionBlock:(Void->Void)!
    let needSendMessage:Bool
//    let exhibitorID:String
    let userID:String
    var dataArr:[[String:String]] =  [[String:String]]()
    init(userID:String,needSendMessage:Bool = false)
    {
       self.needSendMessage = needSendMessage
       self.userID = userID
//       self.exhibitorID = exhibitorID
       super.init(nibName: nil, bundle: nil)
    }
    init(user:PersonData)
    {
       self.needSendMessage = false
       self.user = user
        self.userID = ""
//        self.exhibitorID = ""
       super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详细资料"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.creatTable()
        if self.user == nil
        {
          self.getUserInfo()
        }
        else
        {
           self.parseUserData(self.user)
           self.creatSubView()
           self.table.reloadData()
        }
        
    }
    
    func creatTable(){
    
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        table.dataSource = self
        table.separatorColor = UIColor.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.registerClass(UserInfoCell.self, forCellReuseIdentifier: "UserInfoCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
//        self.creatSubView()
    }
    
    
    func creatSubView(){
    
        if self.userID == UserData.shared.userID
        {
           return
        }
        
        
       let footView = UIView(frame: CGRectMake(0,0,Profile.width(),110))
       let sendMessBt = UIButton(type: .Custom)
       sendMessBt.frame = CGRectMake(15, 20, footView.frame.size.width - 30, 35)
       sendMessBt.layer.masksToBounds = true
       sendMessBt.layer.cornerRadius = 4
       sendMessBt.setBackgroundImage(UIColor.rgb(223, g: 32, b: 82).convertToImage(), forState: .Normal)
       sendMessBt.setBackgroundImage(UIColor.rgb(219, g: 21, b: 58).convertToImage(), forState: .Highlighted)
       sendMessBt.setTitle("发送消息", forState: .Normal)
       sendMessBt.titleLabel?.font = Profile.font(14)
       sendMessBt.addTarget(self, action: "sendMessage", forControlEvents: .TouchUpInside)
       footView.addSubview(sendMessBt)
       
        
        
        let favouriteBt = UIButton(type: .Custom)
        favouriteBt.layer.masksToBounds = true
        favouriteBt.layer.cornerRadius = 4
        favouriteBt.layer.borderColor = UIColor.rgb(223, g: 32, b: 82).CGColor
        
        favouriteBt.layer.borderWidth = 1
        favouriteBt.frame = CGRectMake(15,CGRectGetMaxY(sendMessBt.frame) + 20, footView.frame.size.width - 30, 35)
        favouriteBt.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        favouriteBt.setTitleColor(UIColor.rgb(223, g: 32, b: 82), forState: .Normal)
        favouriteBt.setBackgroundImage(UIColor.rgb(243, g: 243, b: 243).convertToImage(), forState: .Normal)
        favouriteBt.setBackgroundImage(UIColor.rgb(223, g: 32, b: 82).convertToImage(), forState: .Highlighted)
        if self.user.favorite == true
        {
            favouriteBt.setTitle("取消收藏", forState: .Normal)
        }
        else
        {
             favouriteBt.setTitle("收藏名片", forState: .Normal)
        }
        
        favouriteBt.titleLabel?.font = Profile.font(14)
        favouriteBt.addTarget(self, action: "setFavourite:", forControlEvents: .TouchUpInside)
        footView.addSubview(favouriteBt)
        
         table.tableFooterView = footView
    }
    
    
    func sendMessage(){
    
        if self.checkLogStatus() == false
        {
            return
        }

        let chatView = MessageVC(conversationChatter: user.chatID)
        if chatView == nil
        {
            return
        }
        chatView?.title = user.name
        self.navigationController?.pushViewController(chatView!, animated: true)
    }
    
    
    func setFavourite(sender:UIButton){
    
        if self.checkLogStatus() == false
        {
           return
        }
        
        let favourite = self.user.favorite
        weak var wself = self
        
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        let net = NetWorkData()
        net.modifyFavouritePersonStatus(self.user.id!, isAdd: !favourite) { (result, status) -> (Void) in
           
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
            if status == .NetWorkStatusSucess
            {
                if wself?.favouriteActionBlock != nil
                {
                    wself?.favouriteActionBlock()
                }
                
                wself?.user.favorite = !favourite
                wself?.table.reloadData()
                wself?.creatSubView()
                if wself?.user.favorite == true && wself?.needSendMessage == true
                {
                   wself?.sendFavouriteMessage()
                }
            }
        }
        net.start()
    }
    
    
    func sendFavouriteMessage(){
    
      let title = UserData.shared.title == nil ? "" : UserData.shared.title!
       _ = EaseSDKHelper.sendTextMessage("我刚通过扫一扫收藏了你的名片", to: user.chatID, messageType: .eMessageTypeChat, requireEncryption: false, messageExt: [Profile.jobKey:title,Profile.nickKey:UserData.shared.name!])
    }
    
    func getUserInfo(){
    
      weak  var wself = self
      let loadView = THActivityView(activityViewWithSuperView: self.view)
      let net = NetWorkData()
        net.getUserInfo(self.userID) { (result, status) -> (Void) in
        
         loadView.removeFromSuperview()
        
          if status == NetStatus.NetWorkStatusError
          {
              return
          }
        
          if let user = result as? PersonData
          {
             wself?.user = user
             wself?.dataArr.removeAll()
             wself?.parseUserData(user)
             wself?.table.reloadData()
             wself?.creatSubView()
          }
        
        }
       net.start()
    }
    
    
    func parseUserData(user:PersonData)
    {
        self.checkObjectIsNil("名称", ob: user.name)
        self.checkObjectIsNil("职位", ob: user.title)
        self.checkObjectIsNil("公司", ob: user.company)
//        self.checkObjectIsNil("手机号", ob: user.phone)
        self.checkObjectIsNil("QQ", ob: user.qq)
    }
    
    func checkObjectIsNil(key:String,ob:String?)
    {
        if let name = ob
        {
            if name.isEmpty
            {
              return
            }
            self.dataArr.append(["key":key,"value":name])
        }
    }
    
    
    func checkLogStatus()->Bool
    {
        weak var wself = self
        if UserData.shared.token == nil
        {
            let loginVC = LogViewController()
            loginVC.setLogResturnBk({ (let success:Bool) -> Void in
                
                if success == true
                {
                    wself?.getUserInfo()
                }
            })
            self.navigationController?.pushViewController(loginVC, animated: true)
            return false
        }
        
        return true
    }

    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell") as! UserInfoCell
        cell.accessImage.hidden = true
        cell.accessImageLeftSace.constant = 6
        
        let dic = dataArr[indexPath.row]
        cell.textLabel?.text = dic["key"]
        cell.accessL.text = dic["value"]
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
        
        if let job = user.title
        {
            att.appendAttributedString(NSAttributedString(string: "  \(job)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
        }
        if user.company != nil && user.company?.isEmpty != true
        {
            att.appendAttributedString(NSAttributedString(string: "-\(user.company!)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
        }
        titleL.attributedText = att
       
        phoneL.text = user.phone
        
        let qrStr = Profile.globalHttpHead("downapp", parameter: "eid=\(Profile.exhibitor)&uid=\(user.userID!)")
        let qrImage = qrStr.toQRImage(300)
        
        qrImageView.image = qrImage
    }
    
}

