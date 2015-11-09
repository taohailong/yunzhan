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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-5_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        
        self.title = "我的"
        table.registerClass(SettingHeadCell.self , forCellReuseIdentifier: "SettingHeadCell")
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
            cell.fillData("爱玛电动车销售总监", name: "样样", phone: "1234567891")
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
    }
    
    
    
}


class SettingHeadCell: UITableViewCell {
    
    let userImage:UIImageView
    let titleL:UILabel
    let phoneL:UILabel
    var loginBt:UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
//        userImage.image = UIImage(named: "settingUser")
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

    }

    func fillData(userUrl:String,name:String,phone:String)
    {
       userImage.sd_setImageWithURL(NSURL(string: userUrl), placeholderImage: UIImage(named: "settingUser"))
       titleL.text = name
       phoneL.text = phone
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

