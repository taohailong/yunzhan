//
//  ContactsController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/9.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class ContactsListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    var net:NetWorkData!
    var prefixArr:[String]!
    var table :UITableView!
    var dataArr:[[PersonData]]!
    var phoneNu:String!
    override func viewDidLoad() {
        
        self.title = "我的联系人"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
//        table.separatorColor = Profile.rgb(210, g: 210, b: 210)
        table.separatorStyle = .None
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.tableFooterView = UIView()
        table.registerClass(ContactsPersonCell.self, forCellReuseIdentifier: "ContactsPersonCell")
//        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.fetchContactList()
    }
    
    
    func fetchContactList(){
     
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.myContactsList { (result, status) -> (Void) in
        
        loadView.removeFromSuperview()
        if status == .NetWorkStatusError
        {
            if result == nil
            {
                let errView = THActivityView(netErrorWithSuperView: wself!.view)
                weak var werr = errView
                errView.setErrorBk({ () -> Void in
                    wself?.fetchContactList()
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

        guard let list = result as? (prefixArr:[String],person :[[PersonData]])
        else{
                return
            }
        
            if list.prefixArr.count == 0
            {
                let nodataV = THActivityView(emptyDataWarnViewWithString: "您还没有收藏活动", withImage: "noContactData", withSuperView: wself!.view)
                nodataV.tag = 10
                return
            }

            
            wself?.prefixArr = list.prefixArr
            wself?.dataArr = list.person
            wself?.table.reloadData()
        }
        net.start()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if prefixArr == nil
        {
           return 0
        }
        
        return prefixArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arr = dataArr[section]
        print(dataArr)
        return arr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 63
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonCell") as! ContactsPersonCell
        let arr = dataArr[indexPath.section]
        let p = arr[indexPath.row]
        cell.fillData(p.title, name: p.name, phone: p.phone)
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefixArr[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    
        return prefixArr
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        let s = prefixArr!.indexOf(title)
        return s!
    }
    
    
//    滑动删除 部分
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
        weak var wself = self
        let delectNet = NetWorkData()
        delectNet.delectContact(p.exhibitorID!, personID: p.id!) { (result, status) -> (Void) in
          
            if status == .NetWorkStatusError
            {
               return
            }
            
            let subA = wself?.dataArr[indexPath.section]
            subArr.removeAtIndex(indexPath.row)
            wself?.prefixArr.removeAtIndex(indexPath.section)
            
            wself?.dataArr.removeAtIndex(indexPath.section)
            if subArr.count != 0
            {
                wself?.dataArr.insert(subA!, atIndex: indexPath.section)
            }
//            wself?.dataArr.insert(subA!, atIndex: indexPath.section)

            wself?.table.reloadData()
        }
        delectNet.start()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let subA = self.dataArr[indexPath.section]
        let person = subA[indexPath.row]
        
       
        if let url = person.phone
        {
             phoneNu = url
             let alert = UIAlertView(title: "提示", message: "拨打：\(person.phone!)", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show()
          
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == alertView.cancelButtonIndex
        {
            return
        }
        
         let url = NSURL(string: "tel://\(phoneNu)")
         UIApplication.sharedApplication().openURL(url!)
    }
    
}




class ContactsPersonCell: UITableViewCell {
    let nameL:UILabel
    let titleL:UILabel
    var phoneBt:UIButton

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        nameL = UILabel()
        titleL = UILabel()
        phoneBt = UIButton(type: .Custom)

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(13)
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        
        nameL.textColor = Profile.rgb(51, g: 51, b: 51)
        nameL.font = Profile.font(15)
        self.contentView.addSubview(nameL)
        nameL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[nameL]", options: [], metrics: nil, views: ["nameL":nameL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[nameL]", options: [], metrics: nil, views: ["nameL":nameL,"titleL":titleL]))
        
        
        
        phoneBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Disabled)
        phoneBt.titleLabel?.font = Profile.font(15)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false
        phoneBt.setImage(UIImage(named: "exhibitorPhone"), forState: .Disabled)
        phoneBt.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        self.contentView.addSubview(phoneBt)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[nameL]-35-[phoneBt]", options: [], metrics: nil, views: ["phoneBt":phoneBt,"nameL":nameL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(phoneBt, toItem: nameL))
        phoneBt.enabled = false
    }

    func fillData(title: String?,name: String? ,phone: String?)
    {
        titleL.text = title
        nameL.text =  name
        phoneBt.setTitle(phone, forState: UIControlState.Normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

