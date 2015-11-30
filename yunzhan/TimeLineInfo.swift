//
//  TimeLineInfo.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/24.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class TimeLineInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate,ShareCoverageProtocol {
    
    var timeData:TimeMessage!
    var commentArr:[TimeMessage]!
    var table:UITableView!
    var commentField:UITextField!
    var accessView:UIView!
    var net:NetWorkData!
    var sendNet:NetWorkData!
    var block:(Void->Void)!
    var becomeFirstRes : Bool = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if becomeFirstRes == true
        {
            commentField.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNoticOfKeyboard()
        self.title = "图片详情"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.registerClass(TimeLineContentCell.self , forCellReuseIdentifier: "TimeLineContentCell")
        table.registerClass(TimeLinePicCell.self , forCellReuseIdentifier: "TimeLinePicCell")
        table.registerClass(TimeLinePersonCell.self, forCellReuseIdentifier: "TimeLinePersonCell")
        table.registerClass(TimeLineStatusCell.self , forCellReuseIdentifier: "TimeLineStatusCell")
        table.registerClass(ExhibitorMoreCell.self , forCellReuseIdentifier: "ExhibitorMoreCell")
        table.registerClass(TimeCommentCell.self, forCellReuseIdentifier: "TimeCommentCell")
        table.registerClass(MoreTableHeadView.self , forHeaderFooterViewReuseIdentifier: "MoreTableHeadView")
        self.view.addSubview(table)
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
//        table.separatorStyle = .None
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            table?.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }

        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-0-[table]-45-|", aView: table, bView: nil))
        
        accessView = self.getAccessInputView()
        self.view.addSubview(accessView)
        
        self.fetchCommentList()
    }
    
    
    
    
    func fetchCommentList(){
        
        weak var wself = self
        net = NetWorkData()
        net.getMessageCommentList(timeData.id!) { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                if let string = result as? String
                {
                    let warnV = THActivityView(string: string)
                    warnV.show()
                }
            }
            else
            {
                if let list = result as? [TimeMessage]
                {
                    wself?.commentArr = list
                    wself?.table.reloadData()
                }
            }
 
        }
        net.start()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if commentArr == nil
        {
            return 1
        }
        
        if commentArr.count == 0
        {
            return 1
        }

        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
          return 4
        }
        
        else
        {
            return commentArr.count
        }
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0
        {
           return 0.5
        }
        else
        {
            return 46
        }
    }
   
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1
        {
            let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MoreTableHeadView") as! MoreTableHeadView
            head.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
            head.iconImage.image = UIImage(named: "comment_more")
            return head
        }
        else
        {
          return nil
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
   
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return CGFloat(timeData.picHeight)
            }
            else if indexPath.row == 1
            {
                return 46
            }
            else if indexPath.row == 2
            {
                if timeData.contentHeight == nil
                {
                    return 0
                }
                return  CGFloat(Float(16.0) + timeData.contentHeight!)
            }
            else
            {
                return 40
            }
        }
        else
        {
            let element = commentArr[indexPath.row]
             if element.contentHeight == nil
             {
               return 60.0
             }
            let height = CGFloat(65) + CGFloat(element.contentHeight!)
//            print(height)
//            print(element.comment)
              return height
        }
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0{
            
            let element = timeData
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePicCell") as! TimeLinePicCell
                cell.loadPicUrl(element.picUrl,height: element.picHeight)
                return cell
            }
            else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePersonCell") as! TimeLinePersonCell
                cell.filPersonInfo(nil, name: element.personName, title: element.personTitle, time: element.time)
                return cell
            }
            else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineContentCell") as! TimeLineContentCell
                cell.contentL.text = element.comment
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineStatusCell") as! TimeLineStatusCell
                cell.fillDataAttribute(element.forwardNu!, commentNu: element.feedBackNu!, favoriteNu: element.favoriteNu!)
                if element.favorited == true
                {
                    cell.favoriteBt.selected = true
                }
                else
                {
                    cell.favoriteBt.selected = false
                }
                weak var wself = self
                cell.favoriteBlock = {
                    wself?.favoriteAction(element)
                }

                cell.commentBlock = {
                  wself?.commentField.becomeFirstResponder()
                }
                cell.forwardBlock = {
                  wself?.shareAction(element)
                }
                return cell
            }
        }
        else
        {
           
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeCommentCell") as! TimeCommentCell
//            let element = commentArr[indexPath.row - 1]
            let element = commentArr[indexPath.row]
            cell.fillCommentData(nil, title: element.personTitle, name: element.personName, time: element.time, content: element.comment)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        commentField.resignFirstResponder()
    }
    
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        if commentField.isFirstResponder() == true
//        {
//           commentField.resignFirstResponder()
//        }
//    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if commentField.isFirstResponder() == true
        {
            commentField.resignFirstResponder()
        }

    }
    func getAccessInputView()->UIView{
        
//        let height = Double(Profile.height) - 49.0
        let backV = UIView(frame: CGRectMake(0,Profile.height() - 49.0,Profile.width(),49))
        backV.backgroundColor = UIColor.whiteColor()
        
        let separateV = UIView(frame: CGRectMake(0,0,CGRectGetWidth(backV.frame),0.5))
//        separateV.translatesAutoresizingMaskIntoConstraints = false
        separateV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        backV.addSubview(separateV)
        
        
        commentField = UITextField(frame: CGRectMake(15,10,Profile.width()-70,30))
        commentField.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        commentField.placeholder = " 我也说一句："
        commentField.textColor = Profile.rgb(102, g: 102, b: 102)
        commentField.font = Profile.font(13)
        commentField.layer.masksToBounds = true
        commentField.layer.cornerRadius = 4
        commentField.leftView = UIView(frame: CGRectMake(0,0,7,30))
        commentField.leftViewMode = .Always
        backV.addSubview(commentField)
        
        let sendBt = UIButton(type: .Custom)
        sendBt.frame = CGRectMake(CGRectGetMaxX(commentField.frame)+5, 5, 45, 40)
        sendBt.titleLabel?.font = Profile.font(15)
        sendBt.setTitleColor(Profile.rgb(51, g: 51, b: 51), forState: .Normal)
        sendBt.addTarget(self, action: "sendMessageAction", forControlEvents: .TouchUpInside)
        sendBt.setTitle("发送", forState: .Normal)
        backV.addSubview(sendBt)
        
        return backV
    }
    
    func sendMessageAction(){
    
        let user = UserData.shared
        if user.token == nil
        {
            self.timeLineInfoShowLoginVC()
            return
        }
        
        if commentField.text?.isEmpty == true
        {
           return
        }
        
        commentField.resignFirstResponder()
        
        weak var wself = self
        
        sendNet = NetWorkData()
        sendNet.sendCommentToMessage(timeData.id!, comment: commentField.text!) { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                if let string = result as? String
                {
                    let warnV = THActivityView(string: string)
                    warnV.show()
                }
            }
            else
            {
                wself?.timeData.feedBackNu = (wself?.timeData.feedBackNu)! + 1
                wself?.commentField.text = nil
//                wself?.table.reloadData()
                wself?.fetchCommentList()
            }
        }
        sendNet.start()
    }
    
    
    func favoriteAction(message:TimeMessage){
        
        let user = UserData.shared
        if user.token == nil
        {
            self.timeLineInfoShowLoginVC()
            return
        }
        weak var wself = self
        let favoriteNet = NetWorkData()
        favoriteNet.makeFavoriteToMessage(message.id!) { (result, status) -> (Void) in
            
            if status == .NetWorkStatusError
            {
                if let string = result as? String
                {
                    let warnV = THActivityView(string: string)
                    warnV.show()
                }
            }
            else
            {
                if let nu = result as? Int
                {
                    message.favoriteNu = nu
                    if message.favorited == true
                    {
                        message.favorited = false
                    }
                    else
                    {
                        message.favorited = true
                    }
                    wself?.table.reloadData()
                    if wself?.block != nil
                    {
                        wself?.block()
                    }
                }

            }
        }
        favoriteNet.start()
    }

    
    func shareAction(mess:TimeMessage){
        
        let user = UserData.shared
        if user.token == nil
        {
            self.timeLineInfoShowLoginVC()
            return
        }

        
        let shareView = ShareCoverageView(delegate: self)
        shareView.token = UserData.shared.token
        shareView.wallID = mess.id
        shareView.showInView(self.navigationController!.view)
    }
    
    func shareActionFinish(success: Bool) {
        let shareNet = NetWorkData()
        weak var wself = self
        shareNet.getForwardNu(timeData.id!) { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                if let str = result as? String
                {
                    let warnV = THActivityView(string: str)
                    warnV.show()
                }
                return
            }
            
            if let nu = result as? Int
            {
                wself?.timeData.forwardNu = nu
                wself?.table.reloadData()
                if wself?.block != nil
                {
                    wself?.block()
                }
            }
        }
        shareNet.start()
    }

    
    
    func timeLineInfoShowLoginVC(){
        
        let logVC = LogViewController()
        logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
        
    }

    
    func registerNoticOfKeyboard(){
    
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardWillShowNotification, object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    func keyboardShown(let notic:NSNotification){
    
        let dic = notic.userInfo
        let sizeValue = dic![UIKeyboardFrameEndUserInfoKey]
        let keyboardSize = sizeValue?.CGRectValue.size
        self.accessViewAnimate(CGRectGetMaxY(accessView.frame) - (keyboardSize?.height)! - 49.0)
    }
    
    
    func keyboardHidden(let notification:NSNotification){
        self.accessViewAnimate(Profile.height() - 49.0)
    }
    
    
    func accessViewAnimate(y:CGFloat){
    
       UIView.animateWithDuration(0.2, animations: { () -> Void in
        
           self.accessView.frame = CGRectMake(CGRectGetMinX(self.accessView.frame), y, CGRectGetWidth(self.accessView.frame), CGRectGetHeight(self.accessView.frame))
        
        })
    }
    
    deinit{
        
        net.cancel()
        net = nil
    }

    
}

class TimeCommentCell: UITableViewCell {
    
    let userImage:UIImageView
    let titleL:UILabel
    let timeL:UILabel
    let contentL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(named: "settingUser")
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        timeL = UILabel()
        timeL.font = Profile.font(11)
        timeL.textColor = Profile.rgb(153, g: 153, b: 153)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
        contentL.textColor = Profile.rgb(102, g: 102, b: 102)
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
//        contentL.backgroundColor = UIColor.redColor()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(userImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage(33)]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userImage(33)]", options: [], metrics: nil, views: ["userImage":userImage]))
        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[userImage]-10-[titleL]", aView: userImage, bView: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]", aView: titleL, bView: nil))
        
        
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-6-[timeL]", aView: titleL, bView: timeL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(timeL, toItem: titleL))
        
        
        
        self.contentView.addSubview(contentL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[contentL]-15-|", aView: contentL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-6-[contentL]", aView: timeL, bView: contentL))
        
    }

    
    func fillCommentData(imageUrl:String?,title:String?,name:String?,time:String?,content:String?)
    {
        if imageUrl != nil
        {
            userImage.sd_setImageWithURL(NSURL(string: imageUrl!), placeholderImage: UIImage(named: "settingUser"))
        }
        
        
        if name != nil
        {
            let titleAtt = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(15),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
            
            if title != nil
            {
                titleAtt.appendAttributedString(NSAttributedString(string: "- \(title!)", attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }

            titleL.attributedText = titleAtt
        }
        timeL.text = time
        contentL.text = content
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MoreTableHeadView: UITableViewHeaderFooterView {
    
    let iconImage : UIImageView
    override init(reuseIdentifier: String?) {
        
        iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        
        let backV = UIView()
        backV.backgroundColor = UIColor.whiteColor()
        backV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backV)
        
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(backV))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[backV]-0-|", options: [], metrics: nil, views: ["backV":backV]))
        
        self.contentView.addSubview(iconImage)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[iconImage]", aView: iconImage, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconImage]-(-21)-[backV]", options: [], metrics: nil, views: ["iconImage":iconImage,"backV":backV]))
        
        
        
        let separateV = UIView()
        separateV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addSubview(separateV)
        separateV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separateV))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separateV(0.5)]-0-|", options: [], metrics: nil, views: ["separateV":separateV]))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

