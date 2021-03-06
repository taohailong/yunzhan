//
//  SettingController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/5.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate,ScanProtocol {
    
    @IBOutlet weak var table: UITableView!
    private var isNewMess = false
    var tableArr = [[(name:String,image:String)]]()
    func newMessReloadTabel(new:Bool)
    {
        isNewMess = new
        if table != nil
        {
            table.reloadData()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        //       返回按钮去掉文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
        self.figureTableArr()
        
        self.title = "我的"
        table.registerClass(SettingHeadCell.self , forCellReuseIdentifier: "SettingHeadCell")
        table.registerClass(SettingCommonCell.self , forCellReuseIdentifier: "SettingCommonCell")
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.registerHunxinNotic()
    }
    
    
    func figureTableArr(){
    
        var firstSection = [(name:String,image:String)]()
        firstSection.append((name:"我的展商",image:"settingMyExhibitor"))
        firstSection.append((name:"我的活动",image:"settingActivty"))
        firstSection.append((name:"我的订单",image:"settingMyOrder"))
        
        tableArr.append(firstSection)
        
        
        if ModelProfile.needScroeModel()
        {
            var secondSection = [(name:String,image:String)]()
            secondSection.append(("我的积分","settingScore"))
            tableArr.append(secondSection)
        }
       
        
        var thirdSection = [(name:String,image:String)]()
        thirdSection.append(("我的联系人","settingMyConnect"))
        thirdSection.append(("我的消息","setting_chat"))
        tableArr.append(thirdSection)
        
        
        var fourthSection = [(name:String,image:String)]()
        fourthSection.append(("扫一扫","settingRQ"))
        tableArr.append(fourthSection)
        

        var fifthSection = [(name:String,image:String)]()
        
        if ModelProfile.needRegistModel()
        {
            fifthSection.append(("预约报名","settingMyRegist"))
        }
        
        fifthSection.append(("相关推荐","settingMyHotel"))
        tableArr.append(fifthSection)
        
        
        var sixthSection = [(name:String,image:String)]()
        sixthSection.append(("反馈","settingSuggestion"))
        tableArr.append(sixthSection)
        
        
        var seventhSection = [(name:String,image:String)]()
        seventhSection.append(("设置","settingUp"))
        tableArr.append(seventhSection)
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + tableArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
          return 1
        }
        
        return tableArr[section - 1].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
          let cell = tableView.dequeueReusableCellWithIdentifier("SettingHeadCell") as! SettingHeadCell
            
            let user = UserData.shared
            if user.token == nil
            {
                weak var wself = self
              cell.setLoginBtBlock({ () -> Void in
               wself?.showLoginVC( )
              })
            }
            else
            {
              cell.fillData(nil, name: user.name, phone: user.phone ,title:user.title ,company: user.company)
            }
            
           return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingCommonCell") as! SettingCommonCell
            cell.textLabel?.font = Profile.font(15)
            cell.messageSpot.hidden = true
            cell.textLabel?.textColor = Profile.rgb(102, g: 102, b: 102)
            cell.accessoryType = .DisclosureIndicator
            
            let composeData:(name:String,image:String) = tableArr[indexPath.section - 1][indexPath.row]
            
            if composeData.name == "我的消息"
            {
                //                去掉消息红点
                cell.messageSpot.hidden = !isNewMess
            }
            
             cell.fillData(composeData.image, title: composeData.name)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
   
        if indexPath.section == 0{
            
            return 75
        }
        else
        {
            return 45
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func checkLoginStatusWithPushLoginVC()->Bool
    {
        
        let user = UserData.shared
        if user.token == nil
        {
            self.showLoginVC()
            return false
        }
        
        return true
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var controller:UIViewController!
        
        if indexPath.section == 0
        {
            if self.checkLoginStatusWithPushLoginVC() == false
            {
                return
            }
            
            controller = MyInfoVC()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
    
        
        let composeData:(name:String,image:String) = tableArr[indexPath.section - 1][indexPath.row]
        if composeData.name != "扫一扫"
        {
            if self.checkLoginStatusWithPushLoginVC() == false
            {
                return
            }
        }

        if composeData.name == "我的展商"
        {
            controller = MyExhibitorList()
        }
        else if composeData.name == "我的活动"
        {
            controller = MySchedulerListVC()
        }
        else if composeData.name == "我的订单"
        {
            controller = MyOrderListVC()
        }
        else if composeData.name == "我的积分"
        {
            controller = ScoreVC()
        }
        else if composeData.name == "我的联系人"
        {
            controller = ContactsListVC()
        }
        else if composeData.name == "扫一扫"
        {
            let scanVC = QRScanViewController()
            scanVC.delegate = self
            controller = scanVC
        }
        else if composeData.name == "预约报名"
        {
            controller = MyRegistVC()
        }
        else if composeData.name == "相关推荐"
        {
            controller = MyCompanyVC()
        }
        else if composeData.name == "反馈"
        {
            controller = SuggestionVC()
        }
        else if composeData.name == "设置"
        {
            controller = LogOutVC()
        }
        else if composeData.name == "我的消息"
        {
            controller = ApplyListViewController()
        }
        
        if controller != nil
        {
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    
//    MARK: ScanDelegate
    func scanActionCompleteWithResult(string: String!) {
        
        let elementDic = string.figureUrlElement()
        
        let exhibitor = elementDic["eid"]
        if exhibitor != Profile.exhibitor
        {
            return
        }
        let userID = elementDic["uid"]
        
        if userID == nil
        {
            return
        }
        
        let userVC = UserInfoVC(userID: userID!,needSendMessage: true)
        userVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    
    
    
    func showLoginVC(){
    
       let logVC = LogViewController()
       logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
    }
    
// MARK: 环信登出代理通知
    func registerHunxinNotic()
    {
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    func didLoginFromOtherDevice() {
        UserData.shared.logOutHuanxin()
        self.navigationController?.popToRootViewControllerAnimated(true)
        table.reloadData()
    }

    deinit{
    
       EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }
}


class LogOutVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    var table:UITableView!
    override func viewDidLoad() {
        
        self.title = "设置"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = UIColor.rgb(243, g: 243, b: 243)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.registerClass(UITableViewHeaderFooterView.self , forHeaderFooterViewReuseIdentifier: "common")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.registerClass(UITableViewCell.self , forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
          return 2
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 1
        {
          return 15
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("common")
        head?.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        return head
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("common")
        head?.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        return head
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        if indexPath.section == 0
        {
        
            if indexPath.row == 0
            {
                cell?.accessoryType = .DisclosureIndicator
                cell?.imageView?.image = UIImage(named: "about")
                cell?.textLabel?.text = "关于"
                cell?.textLabel?.textColor = Profile.rgb(102, g: 102, b: 102)
                cell?.textLabel?.font = Profile.font(15)
            }
            else
            {
                cell?.accessoryType = .DisclosureIndicator
                cell?.imageView?.image = UIImage(named: "warnImage")
                cell?.textLabel?.text = "举报"
                cell?.textLabel?.textColor = Profile.rgb(102, g: 102, b: 102)
                cell?.textLabel?.font = Profile.font(15)
            }
            
        }
        else
        {
            cell?.textLabel?.textColor = Profile.rgb(51, g: 51, b: 51)
            cell?.textLabel?.font = Profile.font(16)
            cell?.textLabel?.textAlignment = .Center
           cell?.textLabel?.text = "退出登录"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let about = AboutVC()
                self.navigationController?.pushViewController(about , animated: true)
                return
            }
            
            let web = CommonWebController(url: Profile.globalHttpHead("report", parameter: nil))
            web.title = "举报说明"
            self.navigationController?.pushViewController(web, animated: true)
           
        }
        else
        {
            let alert = UIAlertView(title: "提示", message: "您要退出登录吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show()
           
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
       if buttonIndex == alertView.cancelButtonIndex
       {
          return
        }
      let user = UserData.shared
        user.clearUserData()
      self.navigationController?.popToRootViewControllerAnimated(true)
    }
}



class SettingHeadCell: UITableViewCell {
    
    let userImage:UIImageView
    let titleL:UILabel
    let phoneL:UILabel
    var loginBt:UIButton?
    var tapBlock:((Void)->Void)?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(named: "settingUser")
        userImage.contentMode = .ScaleAspectFit
        titleL = UILabel()
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(20)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        phoneL = UILabel()
        phoneL.textColor = Profile.rgb(51, g: 51, b: 51)
        phoneL.font = Profile.font(15)
        phoneL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    
        self.contentView.addSubview(userImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage]", options: [], metrics: nil, views: ["userImage":userImage]))
           self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userImage]-10-|", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraint(NSLayoutConstraint(item: userImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
    
        self.contentView.addSubview(phoneL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneL, toItem: titleL))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[phoneL]", options: [], metrics: nil, views: ["titleL":titleL,"phoneL":phoneL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: phoneL, attribute: .Top, relatedBy: .Equal, toItem: titleL, attribute: .Bottom, multiplier: 1.0, constant: 5))
        
        
        
        
        loginBt = UIButton(type: .Custom)
        loginBt?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(loginBt!)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(loginBt!, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(loginBt!, toItem: titleL))
        loginBt?.setTitle("点击登录", forState: .Normal)
        loginBt?.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        loginBt?.titleLabel?.font = Profile.font(15)
        loginBt?.addTarget(self, action: "logAction", forControlEvents: .TouchUpInside)
    }
    
    func logAction()
    {
       tapBlock!()
    }
    func fillData(userUrl:String? ,name:String? ,phone:String?,title:String?,company:String?)
    {
        if userUrl != nil
        {
            userImage.sd_setImageWithURL(NSURL(string: userUrl!), placeholderImage: UIImage(named: "settingUser"))
        }
        titleL.hidden = false
        phoneL.hidden = false
        
        var constraint : NSLayoutConstraint? = nil
        for temp in  self.contentView.constraints
        {
            if let f = temp.firstItem as? UIView
            {
                if f == phoneL&&temp.secondAttribute == .Bottom&&temp.firstAttribute == .Top
                {
                    constraint = temp
                    break
                }
            }
        }
       
        if name == nil
        {
          constraint?.constant = 14
        }
        else
        {
          constraint?.constant = 5
        }
        
        if name != nil
        {
            let att = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(17),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
        
            if title != nil
            {
              att.appendAttributedString(NSAttributedString(string: "  \(title!)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }
            
            if company != nil && company?.isEmpty != true
            {
               att.appendAttributedString(NSAttributedString(string: "-\(company!)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }
            
            titleL.attributedText = att
        }
        phoneL.text = phone
        loginBt?.hidden = true
    }
    
    func setLoginBtBlock(block:(Void->Void)?)
    {
        tapBlock = block
       loginBt?.hidden = false
//        userImage.hidden = true
        titleL.hidden = true
        phoneL.hidden = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SettingCommonCell: UITableViewCell {
//    @IBOutlet weak var titleL: UILabel!
//    @IBOutlet weak var iconImage: UIImageView!
    var messageSpot:UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageSpot = UIView()
        messageSpot.hidden = true
        messageSpot.backgroundColor = Profile.rgb(252, g: 58, b: 62)
        messageSpot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(messageSpot)
        messageSpot.layer.masksToBounds = true
        messageSpot.layer.cornerRadius = 3.5
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(messageSpot, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-117-[messageSpot(7)]", options: [], metrics: nil, views: ["messageSpot":messageSpot]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[messageSpot(7)]", options: [], metrics: nil, views: ["messageSpot":messageSpot]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fillData(imageName:String?,title:String){
       
        if imageName != nil
        {
            self.textLabel?.text = title
//          iconImage.image = UIImage(named: imageName!)
            self.imageView?.image = UIImage(named: imageName!)
//            self.imageView?.backgroundColor = UIColor.redColor()
        }
        
    }
}

