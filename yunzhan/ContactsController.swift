//
//  ContactsController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/9.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class ContactsListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var net:NetWorkData!
    var prefixArr:[String]!
    var table :UITableView!
    var dataArr:[[PersonData]]!
//    var phoneNu:String!
    override func viewDidLoad() {
        
        self.title = "我的联系人"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
//        table.separatorStyle = .None
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.tableFooterView = UIView()
        table.registerClass(ContactsPersonCell.self, forCellReuseIdentifier: "ContactsPersonCell")
//        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        table.sectionIndexBackgroundColor = UIColor.clearColor()
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
        if let emptyView = wself?.view.viewWithTag(10)
        {
            emptyView.removeFromSuperview()
        }
            
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
                let nodataV = THActivityView(emptyDataWarnViewWithString: "您还没有收藏联系人", withImage: "noContactData", withSuperView: wself!.view)
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
//        print(dataArr)
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
        weak var wself = self
        cell.userInfoBlock = { wself?.showUserInfoVC(p.id!)}
//        cell.chatBlock = { wself?.showChatView(p) }
        
        cell.layoutMargins = UIEdgeInsetsZero
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
         self.showChatView(p)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var subArr = dataArr[indexPath.section]
        let p = subArr[indexPath.row]
        self.deleteFavouritePerson(p.id!,indexPath: indexPath)
    }
    
    

    func deleteFavouritePerson(personID:String,indexPath:NSIndexPath){
    
        weak var wself = self
        let delectNet = NetWorkData()
        delectNet.modifyFavouritePersonStatus(personID, isAdd: false) { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                return
            }
            
            var tempArr = wself!.dataArr[indexPath.section]
            tempArr.removeAtIndex(indexPath.row)
            
            if tempArr.count == 0
            {
                wself?.prefixArr.removeAtIndex(indexPath.section)
                wself?.dataArr.removeAtIndex(indexPath.section)
            }
            else
            {
                wself?.dataArr.removeAtIndex(indexPath.section)
                wself?.dataArr.insert(tempArr, atIndex: indexPath.section)
            }
            
            wself?.table.reloadData()
        }
        delectNet.start()
    
    }
    
    
    func showChatView(person :PersonData){
        
        let chatView = MessageVC(conversationChatter: person.chatID)
        if chatView == nil
        {
            return
        }
        chatView?.title = person.name
        self.navigationController?.pushViewController(chatView!, animated: true)
    }
    
    
    func showUserInfoVC(userID:String){
        
        weak var wself = self
        let userInfo = UserInfoVC(userID: userID)
        userInfo.favouriteActionBlock = { wself?.fetchContactList() }
        self.navigationController?.pushViewController(userInfo, animated: true)
    }
    

    deinit
    {
//      print("deinit")
    }
}




class ContactsPersonCell: UITableViewCell,UIAlertViewDelegate {
    let nameL:UILabel
    let titleL:UILabel
    var phoneBt:UIButton
    var chatBlock:(Void->Void)?
    var userInfoBlock:((Void)->Void)?
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
        
        
        nameL.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "showUserInfoAction")
        nameL.addGestureRecognizer(tap)
        nameL.textColor = Profile.rgb(51, g: 51, b: 51)
        nameL.font = Profile.font(15)
        self.contentView.addSubview(nameL)
        nameL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[nameL]", options: [], metrics: nil, views: ["nameL":nameL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[nameL]", options: [], metrics: nil, views: ["nameL":nameL,"titleL":titleL]))
        
    
    }

    func fillData(title: String?,name: String? ,phone: String?)
    {
        titleL.text = title
        nameL.text =  name
    }

    
    func chatBlockAction(){
        
        if chatBlock != nil
        {
           chatBlock!()
        }
    
    }
    
    
    func showUserInfoAction(){
        
        if userInfoBlock != nil
        {
            userInfoBlock!()
        }
    }

    
    
    func makeCall(){
    
        let alert = UIAlertView(title: "提示", message: "拨打：\(phoneBt.currentTitle!)", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == alertView.cancelButtonIndex
        {
            return
        }
        
        let url = NSURL(string: "tel://\(phoneBt.currentTitle!)")
        UIApplication.sharedApplication().openURL(url!)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

