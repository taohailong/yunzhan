//
//  SettingController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/5.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
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
    
    func setNavgationBarAttribute(change:Bool)
    {
        if change == true
        {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
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
            self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.Default, animated: true)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-5_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        
        self.title = "我的"
        table.registerClass(SettingHeadCell.self , forCellReuseIdentifier: "SettingHeadCell")
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
          return 1
        }
        else if section == 1
        {
          return 3
        }
        else
        {
            return 1
        }
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
                wself?.showLoginVC()
              })
            }
            else
            {
              cell.fillData(nil, name: user.name, phone: user.phone ,title:user.title )
            }
            
           return cell
        }
        else
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("SettingCommonCell") as! SettingCommonCell
            cell.textLabel?.font = Profile.font(15)
            cell.textLabel?.textColor = Profile.rgb(102, g: 102, b: 102)
            
            var imageName:String?, title:String
            switch indexPath {
             
            case let s where s.section == 1 && s.row == 0:
                imageName = "settingActivty"
                title = "我的活动"
            case let s where s.section == 1 && s.row == 1:
                
                imageName = "settingMyExhibitor"
                title = "我的展商"
                
            case let s where s.section == 1 && s.row == 2:
                
                imageName = "settingMyConnect"
                title = "我的联系人"
    
            case let s where s.section == 2:
                
                imageName = "settingSuggestion"
                title = "反馈"
    
            default:
                
                imageName = "settingUp"
                title = "设置"
             
            }
            cell.fillData(imageName, title: title)
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0
        {
          return
        }
        else if indexPath.section == 1
        {
            let user = UserData.shared
            if user.token == nil
            {
                self.showLoginVC()
                return
            }
            
            if indexPath.row == 0
            {
                let schedulerList = MySchedulerListVC()
                schedulerList.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(schedulerList, animated: true)
            }
            else if indexPath.row == 1
            {
                let exhibitorList = MyExhibitorList()
                exhibitorList.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(exhibitorList, animated: true)
            }
            else
            {
                let contactList = ContactsListVC()
                contactList.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(contactList, animated: true)
            }
        }
        else if indexPath.section == 2
        {
            let suggest = SuggestionVC()
            suggest.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(suggest, animated: true)
        }
        else
        {
            let aboutVC = LogOutVC()
            aboutVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
    }
    
    func showLoginVC(){
    
       let logVC = LogViewController()
       logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
    
    }
    
}



class LogOutVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    var table:UITableView!
    override func viewDidLoad() {
        
        self.title = "设置"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = Profile.rgb(227, g: 231, b: 231)
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
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        if indexPath.section == 0{
        
            cell?.accessoryType = .DisclosureIndicator
            cell?.imageView?.image = UIImage(named: "about")
            cell?.textLabel?.text = "关于"
            cell?.textLabel?.textColor = Profile.rgb(102, g: 102, b: 102)
            cell?.textLabel?.font = Profile.font(15)
        }
        else
        {
            cell?.textLabel?.textColor = Profile.rgb(51, g: 51, b: 51)
            cell?.textLabel?.font = Profile.font(18)
            cell?.textLabel?.textAlignment = .Center
           cell?.textLabel?.text = "退出登陆"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0
        {
//            self
        }
        else
        {
            let alert = UIAlertView(title: "提示", message: "您要退出登陆吗", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
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
//        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: userImage))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
    
        self.contentView.addSubview(phoneL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[phoneL]", options: [], metrics: nil, views: ["titleL":titleL,"phoneL":phoneL]))
        
        loginBt = UIButton(type: .Custom)
        loginBt?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(loginBt!)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(loginBt!, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(loginBt!, toItem: titleL))
        loginBt?.setTitle("点击登陆", forState: .Normal)
        loginBt?.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        loginBt?.titleLabel?.font = Profile.font(15)
        loginBt?.addTarget(self, action: "logAction", forControlEvents: .TouchUpInside)
    }
    
    func logAction()
    {
       tapBlock!()
    }
    func fillData(userUrl:String? ,name:String? ,phone:String?,title:String?)
    {
        if userUrl != nil
        {
            userImage.sd_setImageWithURL(NSURL(string: userUrl!), placeholderImage: UIImage(named: "settingUser"))
        }
        titleL.hidden = false
        phoneL.hidden = false
        
//        titleL.text = "\(title)\(name)"
        titleL.text = name
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
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    func fillData(imageName:String?,title:String){
       
        if imageName != nil
        {
            self.textLabel?.text = title
//          iconImage.image = UIImage(named: imageName!)
            self.imageView?.image = UIImage(named: imageName!)
        }
        
//        titleL.text = title
    }
}

