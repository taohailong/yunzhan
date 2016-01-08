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
        
        if let dic = model.ext as? [String:String]
        {
           self.name = dic[Profile.nickKey]!
           self.workTitle = dic[Profile.jobKey]
        }
        else
        {
          self.name = ""
            self.workTitle = ""
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
//    static let shareApplyView = self
    var dataSource:[ConversionData]! = [ConversionData]()
    var table:UITableView!
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
        self.fecthConversationData()
        
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
        cell.workL.text = element.workTitle
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
    let workL:UILabel
    let timeL:UILabel
    let nameL:UILabel
    let contentL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        indicateView = UIView()
        indicateView.backgroundColor = Profile.rgb(252, g: 58, b: 62)
        indicateView.translatesAutoresizingMaskIntoConstraints = false
        indicateView.layer.masksToBounds = true
        indicateView.layer.cornerRadius = 2.5
        
        workL = UILabel()
        workL.translatesAutoresizingMaskIntoConstraints = false
        
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        nameL = UILabel()
        nameL.backgroundColor = UIColor.redColor()
        nameL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
        contentL.backgroundColor = UIColor.redColor()
        contentL.numberOfLines = 0
        contentL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

       
        
        
        self.contentView.addSubview(workL)
        workL.textColor = Profile.rgb(153, g: 153, b: 153)
        workL.font = Profile.font(11)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[workL]", aView: workL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[workL]", aView: workL, bView: nil))
        
        
        
        self.contentView.addSubview(timeL)
        timeL.textColor = Profile.rgb(153, g: 153, b: 153)
        timeL.font = Profile.font(11)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[timeL]-15-|", aView: timeL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[timeL]", aView: timeL, bView: nil))

        
        self.contentView.addSubview(nameL)
        nameL.textColor = Profile.rgb(51, g: 51, b: 51)
        nameL.font = Profile.font(14)
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[nameL(40)]", options: [], metrics: nil, views: ["nameL":nameL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-5-[nameL]", aView: timeL, bView: nameL))

        
        
        self.contentView.addSubview(indicateView)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[indicateView(5)]", options: [], metrics: nil, views: ["indicateView":indicateView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[indicateView(5)]", options: [], metrics: nil, views: ["indicateView":indicateView]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(indicateView, toItem: nameL))

        
        
        let accessView = UIImageView()
        accessView.image = UIImage(named: "cell_narrow")
        accessView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(accessView)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(accessView, toItem: nameL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[accessView]-15-|", aView: accessView, bView: nil))
        
        
        
        
        self.contentView.addSubview(contentL)
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[nameL]-20-[contentL]-(>=25)-|", options: [], metrics: nil, views: ["nameL":nameL,"contentL":contentL]))
      self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(contentL, toItem: nameL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[contentL(<=30)]", options: [], metrics: nil, views: ["contentL":contentL]))
//      self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[contentL]-10-|", aView: contentL, bView: nil))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-10-[contentL]", aView: timeL, bView: contentL))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


