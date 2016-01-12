//
//  ApplyViewController.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/6.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation

class ConversionData: NSObject {
    var new:Bool = false
    let conversionID:String
    let name:String
    var userID:String
    var workTitle:String?
    let time:String
    var message:String?
    let conversionType:EMMessageType
    init(model:EMMessage) {
    
        self.userID = model.to
        self.new = !model.isRead
        let time = Int(model.timestamp)
        self.time = time.toTimeString("yy-MM-dd HH:mm")
        self.conversionID = model.conversationChatter
        self.conversionType = model.messageType
        
//        自己发送
        if UserData.shared.messID == model.from
        {
           self.name = MessageUserNameProfile.shareManager.userName(model.to)
        }
        else
        {
            if let dic = model.ext as? [String:String]
            {
                self.name = dic[Profile.nickKey]!
                MessageUserNameProfile.shareManager.saveName(self.name, key: model.from)
            }
            else
            {
                self.name = ""
            }

        }
            
        
        let m = model.messageBodies[model.messageBodies.count - 1] as! EMTextMessageBody
        
        if m.messageBodyType == .eMessageBodyType_Text
        {
           self.message = m.text
        }
        else if m.messageBodyType == .eMessageBodyType_Image
        {
           self.message = "[image]"
        }
        else
        {
            self.message = "[no]"
        }
    }
}



class ApplyListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate  {

    var dataSource:[ConversionData]! = [ConversionData]()
    var table:UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fecthConversationData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        table.registerClass(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
        
        
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    
    func didUnreadMessagesCountChanged() {
        self.fecthConversationData()
    }
    
    func didUpdateGroupList(groupList: [AnyObject]!, error: EMError!) {
        self.fecthConversationData()
    }
    
    
    func fecthConversationData(){
        
       self.formateConversationData()
       table.reloadData()
    }
    
    
    func formateConversationData()
    {
        let conversationArr:NSArray = EaseMob.sharedInstance().chatManager.conversations!
        
        let sort = conversationArr.sortedArrayUsingComparator { (obj1:AnyObject,obj2: AnyObject) -> NSComparisonResult in
            
            let c1 = obj1 as! EMConversation
            let c2 = obj2 as! EMConversation
            
            let mess1 = c1.latestMessage()
            let mess2 = c2.latestMessage()
            
            if  mess1 == nil
            {
                 EaseMob.sharedInstance().chatManager.removeConversationByChatter!(c1.chatter, deleteMessages: true, append2Chat: true)
                return NSComparisonResult.OrderedAscending
            }
            
            if mess2 ==  nil
            {
                EaseMob.sharedInstance().chatManager.removeConversationByChatter!(c2.chatter, deleteMessages: true, append2Chat: true)
                return NSComparisonResult.OrderedAscending
            }
            
            if mess1.timestamp > mess2.timestamp{
                return NSComparisonResult.OrderedAscending
            }
            else
            {
                return NSComparisonResult.OrderedDescending
            }
        }
        
        dataSource.removeAll()
        
        for temp in sort as! [EMConversation]
        {
            if temp.conversationType == .eConversationTypeChat
            {
                let last = temp.latestMessage()
                if last == nil
                {
                  continue
                }
                let element = ConversionData(model: last)
                element.userID = temp.chatter
            
                dataSource.append(element)
            }
        }
       
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataSource == nil
        {
            return 0
        }
        
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationListCell") as! ConversationListCell
        
        let element = dataSource[indexPath.row]
        cell.timeL.text = element.time
        cell.nameL.text = element.name
        cell.contentL.text = element.message
        if element.new == true
        {
           cell.indicateView.hidden = false
        }
        else
        {
          cell.indicateView.hidden = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let element = dataSource[indexPath.row]
        let chatView = MessageVC()
        chatView.title = element.name
        chatView.conversationChatter = element.conversionID
        chatView.conversationType = .eConversationTypeChat
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    deinit
    {
    
       EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }
}

class ConversationListCell: UITableViewCell {
    let indicateView:UIView
//    let workL:UILabel
    let timeL:UILabel
    let nameL:UILabel
    let contentL:UILabel
    let userImage:UIImageView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        indicateView = UIView()
        indicateView.backgroundColor = Profile.rgb(252, g: 58, b: 62)
        indicateView.translatesAutoresizingMaskIntoConstraints = false
        indicateView.layer.masksToBounds = true
        indicateView.layer.cornerRadius = 3.5
        
//        workL = UILabel()
//        workL.translatesAutoresizingMaskIntoConstraints = false
        
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        nameL = UILabel()
//        nameL.backgroundColor = UIColor.redColor()
        nameL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
//        contentL.backgroundColor = UIColor.redColor()
        contentL.numberOfLines = 0
        contentL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        userImage.image = UIImage(named: "messCellUserImage")
        self.contentView.addSubview(userImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userImage]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage]", options: [], metrics: nil, views: ["userImage":userImage]))
        
        
       
        self.contentView.addSubview(indicateView)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-0-[indicateView(7)]", options: [], metrics: nil, views: ["indicateView":indicateView,"userImage":userImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[indicateView(7)]", options: [], metrics: nil, views: ["indicateView":indicateView]))
        
        
        self.contentView.addSubview(timeL)
        timeL.textColor = Profile.rgb(153, g: 153, b: 153)
        timeL.font = Profile.font(11)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[timeL]-15-|", aView: timeL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[timeL]", aView: timeL, bView: nil))

        
        
        self.contentView.addSubview(nameL)
        nameL.textColor = Profile.rgb(51, g: 51, b: 51)
        nameL.font = Profile.font(14)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[nameL]", options: [], metrics: nil, views: ["userImage":userImage,"nameL":nameL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(nameL, toItem: timeL))


        
        
        self.contentView.addSubview(contentL)
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
//        contentL.backgroundColor = UIColor.blackColor()
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[contentL]-(>=30)-|", options: [], metrics: nil, views: ["userImage":userImage,"contentL":contentL]))

         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[contentL(<=30)]-8-|", options: [], metrics: nil, views: ["contentL":contentL]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[nameL]-7-[contentL(<=30)]", options: [], metrics: nil, views: ["contentL":contentL,"nameL":nameL]))
        
        
        
        let accessView = UIImageView()
        accessView.image = UIImage(named: "cell_narrow")
        accessView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(accessView)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(accessView, toItem: contentL))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-10-[accessView]-15-|", aView:timeL , bView: accessView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[accessView]-15-|", aView: accessView, bView: nil))

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


