//
//  MessageVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/6.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class MessageModel: NSObject {
    var cellHeight:CGFloat = 10
    var nickName:String?
    var text:String?
    
    var isSender:Bool = false
    let bodyType:MessageBodyType
    let originalMessage:EMMessage
    init(mess:EMMessage) {
     
//        self.nickName = mess.from
        self.originalMessage = mess
        let body = mess.messageBodies[0] as! EMTextMessageBody
        self.bodyType = body.messageBodyType
        
        if self.bodyType == .eMessageBodyType_Text
        {
            self.text = body.text
        }
        else if self.bodyType == .eMessageBodyType_Image
        {
            self.text = "[image]"
        }
        else
        {
            self.text = "[no]"
        }
        
        if mess.from == UserData.shared.messID
        {
           self.isSender = true
        }
        
        if let dic = mess.ext as? [String:String]
        {
            self.nickName = dic[Profile.nickKey]!
        }

    }
}


class MessageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate,UITextFieldDelegate {
    var messageTimeIntervalTag:Int64 = 0
    var conversationChatter:String!
    var conversationType:EMConversationType = .eConversationTypeChat
    var table:UITableView!
    var messsagesSource = [EMMessage]()
    var conversation:EMConversation!
    var dataSource:[AnyObject] = [AnyObject]()
    var textView:UITextField!
    var toolBar:UIView!
    var refreshEnable:Bool = false
    
     init?(conversationChatter:String?,type:EMConversationType = .eConversationTypeChat) {
       
        super.init(nibName: nil, bundle: nil)
        if  conversationChatter == nil || conversationChatter!.isEmpty == true
        {
            return nil
        }
        self.conversationChatter = conversationChatter!
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
//        保存名称
        MessageUserNameProfile.shareManager.saveName(self.title!, key: conversationChatter)
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.dataSource = self
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.delegate = self
        table.separatorStyle = .None
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 40
        table.registerClass(MessTimeCell.self, forCellReuseIdentifier: "MessTimeCell")
        table.registerClass(MessCellRight.self, forCellReuseIdentifier: "MessCellRight")
        table.registerClass(MessCellLeft.self, forCellReuseIdentifier: "MessCellLeft")
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[table]", options: [], metrics: nil, views: ["table":table]))
        
        self.creatTextView()
        self.registChatManager()
        self.loadMessageDataFromBD()
    }
    
    
//MARK:TextView,Keyboard
    func creatTextView(){
    
        toolBar = UIView()
        toolBar.backgroundColor = UIColor.whiteColor()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toolBar)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[table]-0-[toolBar(49)]", options: [], metrics: nil, views: ["toolBar":toolBar,"table":table]))
        
        self.view.addConstraint(NSLayoutConstraint(item: toolBar, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(toolBar))
        
        
        let separateV = UIView()
        separateV.backgroundColor = Profile.rgb(210, g: 210, b: 210)
        separateV.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(separateV)
        toolBar.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separateV))
        toolBar.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[separateV(0.5)]", options: [], metrics: nil, views: ["separateV":separateV]))
        
        
        textView = UITextField()
        textView.placeholder = "回复:"
        textView.font = Profile.font(13)
        textView.layer.borderColor = UIColor.clearColor().CGColor
        textView.borderStyle = .RoundedRect
        textView.delegate = self
        textView.returnKeyType = .Send
        textView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        textView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.addSubview(textView)
        toolBar.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[textView]-15-|", aView: textView, bView: nil))
        toolBar.addConstraint(NSLayoutConstraint.layoutVerticalCenter(textView, toItem: toolBar))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[textView(30)]", options: [], metrics: nil, views: ["textView":textView]))
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var job = ""
        if UserData.shared.title != nil
        {
           job = UserData.shared.title!
        }
        var name = ""
        if UserData.shared.name != nil
        {
           name = UserData.shared.name!
        }
        
        self.sendTextMess(textField.text!, ext: [Profile.jobKey:job,Profile.nickKey:name])
        textField.text = nil
        return true
    }
    
    
    func keyboardWillShow(notic:NSNotification){
        
        let value = notic.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let size = value.CGRectValue().size
        self.toolBarFrameChange(-size.height)
    }
    
    
    func keyboardWillHide(notic:NSNotification)
    {
        self.toolBarFrameChange(0)
    }
    
    
    func toolBarFrameChange(height:CGFloat){
        
        for constraint in self.view.constraints
        {
            if constraint.firstItem as! NSObject == self.toolBar && constraint.firstAttribute == .Bottom
            {
                constraint.constant = height
            }
        }
        
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        if self.dataSource.count == 0
        {
            return
        }
        self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataSource.count -  1, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        textView.resignFirstResponder()
    }

    
    
    func registChatManager(){
    
       conversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(conversationChatter, conversationType: conversationType)
        
        if conversation == nil
        {
           return
        }
        conversation.markAllMessagesAsRead(true)
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
//    MARK:UITable
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let element = dataSource[indexPath.row]
        
        if let cellData = element as? String
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("MessTimeCell") as! MessTimeCell
            cell.timeL.text = cellData
            return cell
        }
        else
        {
            let cellData = element as! MessageModel
            
            let indentifier = cellData.isSender == true ? "MessCellRight":"MessCellLeft"
            let cell = tableView.dequeueReusableCellWithIdentifier(indentifier) as! MessCellRight
            cell.messL.text = cellData.text
            return cell
        }
        
    }
    
    
    func refreshHeadView(isAdd:Bool){
    
        if isAdd == true
        {
          table.tableHeaderView = MoreTableFootView(frame: CGRectMake(0, 0, Profile.width(), 40))
        }
        else
        {
          table.tableHeaderView = nil
        }
    
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        guard let view = self.table.tableHeaderView
            else{
                return
        }
//        if refreshEnable == false
//        {
//           return
//        }
        
        let offset = scrollView.contentOffset
//        let size = scrollView.contentSize
//        let inset = scrollView.contentInset
//        let y = scrollView.bounds.size.height - inset.bottom
//        let h = size.height
        
        if (offset.y < 40 && view.bounds.size.height>10)
        {
            self.loadMessageDataFromBD()
        }

    }
    
    
//MARK:dataFormate
    
    func loadMessageDataFromBD(){
    
        if conversation == nil
        {
           return
        }
        self.messageTimeIntervalTag = -1;
        var timestamp:Int64 = 0;
        
        if (messsagesSource.count > 0) {
            timestamp = self.messsagesSource[0].timestamp
        }
        else if(self.conversation.latestMessage() != nil){
            timestamp = self.conversation.latestMessage().timestamp + 1;
        }
        else{
            timestamp = Int64(NSDate().timeIntervalSince1970) * 100 + 1
        }
        
        self.loadMessage(timestamp, count:10, append: true,animation: false)
    }
    
    
    
    func loadMessage(before:Int64,count:NSInteger,append:Bool,animation:Bool)
    {
        weak var wself = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
           let temp = wself?.conversation.loadNumbersOfMessages(UInt(count), before: before)
           if temp == nil
           {
              return
           }
           let messArr = temp as! [EMMessage]
          
            if  messArr.count == 0
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   self.refreshHeadView(false) 
                })
                return
            }
 
           let formatte = wself?.formatMessage(messArr)
            var scrollIndex = 0
            if append == true
            {
                for (index,value) in messArr.enumerate()
                {
                   self.messsagesSource.insert(value, atIndex: index)
                }
                
                if let s = self.dataSource.first as? String
               {
                  for element in formatte!
                  {
                     if element is String && element as! String == s
                     {
                          self.dataSource.removeFirst()
                          break
                     }
                    
                  }
                }
                
                scrollIndex = self.dataSource.count
                
                for (index,obj) in formatte!.enumerate()
                {
                    self.dataSource.insert(obj, atIndex: index)
                }
            }
            else
            {
                self.dataSource.removeAll()
                self.dataSource = formatte!
                
                self.messsagesSource.removeAll()
                self.messsagesSource += messArr
            }
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if messArr.count < 10
                {
                    self.refreshHeadView(false)
                }
                else
                {
                    self.refreshHeadView(true)
                }
                
                self.table.reloadData()
                self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataSource.count - scrollIndex - 1, inSection: 0), atScrollPosition: .Top, animated: animation)
            })
        }
    }
    
    
    func addMessageToDataSource(message:EMMessage){
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
        
        let arr = self.formatMessage([message])
        
        self.dataSource += arr
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.table.reloadData()
            self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: self.dataSource.count -  1, inSection: 0), atScrollPosition: .Top, animated: true)
        })

     }
    
    }
    
    
    
    func formatMessage(arr: [EMMessage])-> [AnyObject]
    {
        var backArr = [AnyObject]()
        for temp in arr
        {
          let interval = (messageTimeIntervalTag - temp.timestamp) / 1000
          if messageTimeIntervalTag < 0 || interval > 60 || interval < -60
          {
            let time = Int(temp.timestamp)
            backArr.append(time.toTimeString("yyyy年MM月dd日 HH:mm"))
            messageTimeIntervalTag = temp.timestamp
            
          }
           
          let model = MessageModel(mess: temp)
          backArr.append(model)
        }
        
        return backArr
    }
    
    

// MARK:环信代理、发送方法
    func didReceiveOfflineMessages(offlineMessages: [AnyObject]!) {
        
        if offlineMessages.count == 0
        {
          return
        }
        conversation.markAllMessagesAsRead(true)
        
        var timestamp:Int64 = 0
        if conversation.latestMessage() == nil
        {
            timestamp = conversation.latestMessage().timestamp + 1
        }
        else
        {
           timestamp = Int64(NSDate().timeIntervalSince1970) * 100 + 1
         }
        self.loadMessage(timestamp, count: self.dataSource.count + offlineMessages.count, append: false,animation: true)
    }
    
    
    
    
    func didReceiveMessage(message: EMMessage!) {
        
        if conversation.chatter == message.conversationChatter
        {
            conversation.markMessageWithId(message.messageId, asRead: true)
            self.addMessageToDataSource(message)
        }
    }
    

    func sendTextMess(text:String,ext:[String:String]?)
    {
        let mess = EaseSDKHelper.sendTextMessage(text, to: conversation.chatter, messageType: .eMessageTypeChat, requireEncryption: false, messageExt: ext)
        self.addMessageToDataSource(mess)
    }
    
    deinit{
    
      EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }
}

class MessTimeCell: UITableViewCell {
    
    let timeL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        timeL = UILabel()
        timeL.font = Profile.font(11)
        timeL.textColor = UIColor.whiteColor()
        timeL.backgroundColor = Profile.rgb(221, g: 221, b: 221)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        let titleBack = UIView()
        titleBack.backgroundColor = timeL.backgroundColor
        titleBack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleBack)
        
        
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[timeL]-8-|", aView: timeL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(timeL, toItem: self.contentView))
        self.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: titleBack, attribute: .Width, relatedBy: .Equal, toItem: timeL, attribute: .Width, multiplier: 1.0, constant: 10))
        self.contentView.addConstraint(NSLayoutConstraint(item: titleBack, attribute: .Height, relatedBy: .Equal, toItem: timeL, attribute: .Height, multiplier: 1.0, constant: 6))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: titleBack, attribute: .CenterY, relatedBy: .Equal, toItem: timeL, attribute: .CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: titleBack, attribute: .CenterX, relatedBy: .Equal, toItem: timeL, attribute: .CenterX, multiplier: 1.0, constant: 0))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessCellRight:UITableViewCell {
    
    let messL:UILabel
//    let nameL:UILabel
    let userImage:UIImageView
    let backImage:UIImageView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        messL = UILabel()
        messL.font = Profile.font(14)
        messL.numberOfLines = 0
//        messL.backgroundColor = UIColor.redColor()
        messL.translatesAutoresizingMaskIntoConstraints = false
        
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(named: "messCellUserImage")
        
        
        backImage = UIImageView()
//        backImage.backgroundColor = UIColor.greenColor()
        backImage.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        self.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addSubview(backImage)
//        self.contentView.addSubview(nameL)
        self.contentView.addSubview(userImage)
        self.contentView.addSubview(messL)
        
        self.setSubViewLayout()
    }

    
    func setSubViewLayout(){
        
        backImage.image = UIImage(named: "MessRight")
        messL.textColor = UIColor.whiteColor()
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[userImage(35)]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage(35)]-12-|", options: [], metrics: nil, views: ["userImage":userImage]))
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=80)-[messL]-20-[userImage]", options: [], metrics: nil, views: ["messL":messL,"userImage":userImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-17-[messL]-14-|", options: [], metrics: nil, views: ["messL":messL]))
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .CenterY, relatedBy: .Equal, toItem: messL, attribute: .CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .CenterX, relatedBy: .Equal, toItem: messL, attribute: .CenterX, multiplier: 1.0, constant: 3))
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .Width, relatedBy: .Equal, toItem: messL, attribute: .Width, multiplier: 1.0, constant: 24))
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .Height, relatedBy: .Equal, toItem: messL, attribute: .Height, multiplier: 1.0, constant: 14))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessCellLeft: MessCellRight {
    
    override func setSubViewLayout() {
        
        backImage.image = UIImage(named: "MessLeft")
        messL.textColor = Profile.rgb(51, g: 51, b: 51)
        

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[userImage(35)]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage(35)]", options: [], metrics: nil, views: ["userImage":userImage]))
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-20-[messL]-(>=80)-|", options: [], metrics: nil, views: ["messL":messL,"userImage":userImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-17-[messL]-14-|", options: [], metrics: nil, views: ["messL":messL]))
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .CenterY, relatedBy: .Equal, toItem: messL, attribute: .CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .CenterX, relatedBy: .Equal, toItem: messL, attribute: .CenterX, multiplier: 1.0, constant: -3))
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .Width, relatedBy: .Equal, toItem: messL, attribute: .Width, multiplier: 1.0, constant: 24))
        self.contentView.addConstraint(NSLayoutConstraint(item: backImage, attribute: .Height, relatedBy: .Equal, toItem: messL, attribute: .Height, multiplier: 1.0, constant: 14))

    }
}




