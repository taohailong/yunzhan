//
//  TimeLineVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/20.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class TimeLineVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var table:UITableView!
    var dataArr:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.registerClass(TimeLineContentCell.self , forCellReuseIdentifier: "TimeLineContentCell")
        table.registerClass(TimeLinePicCell.self , forCellReuseIdentifier: "TimeLinePicCell")
        table.registerClass(TimeLinePersonCell.self, forCellReuseIdentifier: "TimeLinePersonCell")
        table.registerClass(TimeLineStatusCell.self , forCellReuseIdentifier: "TimeLineStatusCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        
        table?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            table?.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
           return 130
        }
        else if indexPath.row == 1
        {
          return 35
        }
        else if indexPath.row == 2
        {
          return 50
        }
        else
        {
          return 40
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
             let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePicCell") as! TimeLinePicCell
             cell.loadPicUrl("http://www.ddc.net.cn/upload/20080918014052_big.jpg")
             return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePersonCell") as! TimeLinePersonCell
            cell.filPersonInfo(nil, name: "阳阳 ", title: "-艾玛总监", time: "7/20-12:30")
            return cell
        }
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineContentCell") as! TimeLineContentCell
            cell.contentL.text = "本人在电动车厂工作。因工厂现在是淡季，闲着没事在家装电动车卖卖 ，高配车型，最低价格。有意者请联系15190213190"
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineStatusCell") as! TimeLineStatusCell
            cell.fillDataAttribute(300, commentNu: 80, favoriteNu: 200)
            cell.favoriteBlock = { }
            cell.commentBlock = { }
            cell.forwardBlock = { }
            return cell
        }
    }
    
}

class TimeLinePicCell:UITableViewCell {
    let picImageV:UIImageView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        picImageV = UIImageView()
        picImageV.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(picImageV)
        self.contentView.addConstraints(NSLayoutConstraint.layoutVerticalFull(picImageV))
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(picImageV))
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }

    }
    func loadPicUrl(url:String?)
    {
       if url != nil
       {
           picImageV.sd_setImageWithURL(NSURL(string: url!), placeholderImage: nil)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class TimeLineStatusCell: UITableViewCell {
    typealias TapBlock = (Void)->(Void)
    
    let forwardBt:UIButton
    let commentBt:UIButton
    let favoriteBt:UIButton
    var favoriteBlock:TapBlock!
    var commentBlock:TapBlock!
    var forwardBlock:TapBlock!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        forwardBt = UIButton(type: .Custom)
        forwardBt.titleLabel?.font = Profile.font(10)
        forwardBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        forwardBt.translatesAutoresizingMaskIntoConstraints = false
        
        commentBt = UIButton(type: .Custom)
        commentBt.titleLabel?.font = Profile.font(10)
        commentBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        commentBt.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteBt = UIButton(type: .Custom)
        favoriteBt.titleLabel?.font = Profile.font(10)
        favoriteBt.setTitleColor(Profile.rgb(102, g: 102, b: 1025), forState: .Normal)
        favoriteBt.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        forwardBt.setImage(UIImage(named: "forward_timeLine"), forState: .Normal)
        forwardBt.addTarget(self, action: "forwardAction", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(forwardBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(forwardBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: forwardBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 0.5, constant: 0))
        
        
        commentBt.setImage(UIImage(named: "comment_timeLine"), forState: .Normal)
        commentBt.addTarget(self, action: "commentAction", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(commentBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(commentBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: commentBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        
        
        favoriteBt.addTarget(self, action: "favoriteAction", forControlEvents: .TouchUpInside)
        favoriteBt.setImage(UIImage(named: "favorite_timeLine"), forState: .Normal)
        self.contentView.addSubview(favoriteBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(favoriteBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: favoriteBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.5, constant: 0))
        
        
        let separateVerticalOne = UIView()
        separateVerticalOne.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        separateVerticalOne.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separateVerticalOne)
        self.contentView.addConstraint(NSLayoutConstraint(item: separateVerticalOne, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 0.66, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[separateVerticalOne(0.5)]", options: [], metrics: nil, views: ["separateVerticalOne":separateVerticalOne]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[separateVerticalOne]-3-|", options: [], metrics: nil, views: ["separateVerticalOne":separateVerticalOne]))
        
        
        let separateVerticalTwo = UIView()
        separateVerticalTwo.backgroundColor = Profile.rgb(243, g: 243, b: 243)

        separateVerticalTwo.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separateVerticalTwo)
        self.contentView.addConstraint(NSLayoutConstraint(item: separateVerticalTwo, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.32, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[separateVerticalTwo(0.5)]", options: [], metrics: nil, views: ["separateVerticalTwo":separateVerticalTwo]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[separateVerticalTwo]-3-|", options: [], metrics: nil, views: ["separateVerticalTwo":separateVerticalTwo]))

        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
                        // Fallback on earlier versions
        }

    }

    func favoriteAction(){
       
         if favoriteBlock != nil
         {
           favoriteBlock()
        }
    }
    
    func commentAction(){
        
       if commentBlock != nil
       {
          commentBlock()
        }
    }
    
    
    func forwardAction(){
        
      if forwardBlock != nil
      {
         forwardBlock()
        }
    }
    
    func fillDataAttribute(forward:Int,commentNu:Int,favoriteNu:Int)
    {
        forwardBt.setTitle(String(forward), forState: .Normal)
        commentBt.setTitle(String(commentNu), forState: .Normal)
        favoriteBt.setTitle(String(favoriteNu), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TimeLinePersonCell: UITableViewCell {
    let userPicV:UIImageView
    let nameL:UILabel
    let timeL:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userPicV = UIImageView()
        userPicV.translatesAutoresizingMaskIntoConstraints = false
        
        nameL = UILabel()
        nameL.translatesAutoresizingMaskIntoConstraints = false
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false
        timeL.textColor = Profile.rgb(102, g: 102, b: 102)
        timeL.font = Profile.font(10)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(userPicV)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userPicV(30)]", options: [], metrics: nil, views: ["userPicV":userPicV]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userPicV(30)]", options: [], metrics: nil, views: ["userPicV":userPicV]))
        
        
        self.contentView.addSubview(nameL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[userPicV]-10-[nameL]", aView: userPicV, bView: nameL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(nameL, toItem: self.contentView))
        
        
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[timeL]-15-|", aView: timeL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(timeL, toItem: self.contentView))
        
        self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }

    }
    
    func filPersonInfo(pic:String?,name:String?,title:String?,time:String?)
    {
        if pic != nil
        {
           userPicV.sd_setImageWithURL(NSURL(string: pic!), placeholderImage: nil)
        }
        
        if name != nil
        {
            let attribute = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
            
            if title != nil
            {
              attribute.appendAttributedString(NSAttributedString(string: title!, attributes: [NSFontAttributeName:Profile.font(10),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)]))
            }
            
            nameL.attributedText = attribute
        }
        timeL.text = time
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TimeLineContentCell: UITableViewCell {
    let contentL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        contentL = UILabel()
        contentL.textColor = Profile.rgb(51, g: 51, b: 51)
        contentL.font = Profile.font(13)
        contentL.numberOfLines = 0
        contentL.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(contentL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[contentL]-15-|", aView: contentL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-5-[contentL]-5-|", aView: contentL, bView: nil))
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

