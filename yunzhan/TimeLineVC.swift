//
//  TimeLineVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/20.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class TimeLineVC: UIViewController,ShareCoverageProtocol,UITableViewDelegate,UITableViewDataSource {
    var table:UITableView!
    var refreshV:THLRefreshView!
    var dataArr:[TimeMessage]!
    var net:NetWorkData!
    var shareElement:TimeMessage!
    var loading:Bool = false
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if dataArr == nil
//        {
//            self.refreshControl?.beginRefreshing()
//        }
//    }
    
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
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
    
        self.view.addSubview(table)
//        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[table]-15-|", options: [], metrics: nil, views: ["table":table]))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            table.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = table.backgroundColor
        self.timeLineRefresh()
//        self.fetchTimeLineList()
    }
    
    
    func timeLineRefresh(){
    
        weak var wself = self
        refreshV = THLRefreshView()
        refreshV.isManuallyRefreshing = true
        refreshV.setBeginRefreshBlock { () -> Void in
          wself?.fetchTimeLineList()
        }
        refreshV.addToScrollView(table);
        
    }
    

    
    func fetchTimeLineList(){
    
        
        weak var wself = self
        let index = 0
//        let loadView = THActivityView(activityViewWithSuperView: self.view)
//        self.refreshControl?.beginRefreshing()
        net = NetWorkData()
        net.getTimeLineList(index) { (result, status) -> (Void) in
            wself?.refreshV.endRefreshing()
 
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let warnV = THActivityView(string: "网络错误")
                    warnV.show()
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
         
            if let list = result as? [TimeMessage]{
            
                
                if list.count == 0{
                
                   _ = THActivityView(emptyDataWarnViewWithString: "快来互动，上传图片吧", withImage: "noPicData", withSuperView: wself?.view)
                    wself?.dataArr = [TimeMessage]()
                    wself?.table.reloadData()
                    return
                }
                
               (wself?.dataArr = list)!
               wself?.table.reloadData()
               wself?.addLoadMoreView(list.count)
            }
            
        }
        net.start()
        
  }
    
    
    func loadMoreData(){
       
        if loading == true
        {
           return
        }
        loading = true
        weak var wself = self
        var index :Int!
        if dataArr == nil
        {
            index = 0
        }
        else
        {
            index = dataArr.count
        }
        
//        let loadView = THActivityView(activityViewWithSuperView: self.view)
        net = NetWorkData()
        net.getTimeLineList(index) { (result, status) -> (Void) in
            
            wself?.loading = false
//            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if let warnStr = result as? String
                {
                    let warnView = THActivityView(string: warnStr)
                    warnView.show()
                }
            
                return
            }
            
            if let list = result as? [TimeMessage]{
            
                wself?.dataArr.appendContentsOf(list)
                wself?.table.reloadData()
                wself?.addLoadMoreView(list.count)
            }
            
        }
        net.start()
    }
    
    func addLoadMoreView(count:Int){
    
        if count < 20{
        
         self.table.tableFooterView = UIView()
        }
        else
        {
           self.table.tableFooterView = MoreTableFootView(frame: CGRectMake(0, 0, Profile.width(), 40))
        }
    
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if dataArr == nil
        {
          return 0
        }
        return dataArr.count
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 46
        }
        else if indexPath.row == 1
        {
            let element = dataArr[indexPath.section]
            if element.contentHeight == 0
            {
                return 1
            }
            //评论内容
            return  CGFloat(Float(12.0) + element.contentHeight!)
        }
        else if indexPath.row == 2
        {
            return (Profile.width() - 46)/2 + 15
        }
        else
        {
//            状态栏
          return 40
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if dataArr.count - 1 == section
        {
          return 10
        }
        return 0.5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let element = dataArr[indexPath.section]
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePersonCell") as! TimeLinePersonCell
            
            cell.filPersonInfo(nil, name: element.personName, title: element.personTitle, time: element.time)
            return cell

        }
        else if indexPath.row == 1
        {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineContentCell") as! TimeLineContentCell
            cell.contentL.text = element.comment
            return cell

        }
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimeLinePicCell") as! TimeLinePicCell
            
            cell.loadPicUrl(element.picThumbUrl,height: element.picHeight)
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
                let commentInfo = TimeLineInfoVC()
                commentInfo.timeData = element
                commentInfo.hidesBottomBarWhenPushed = true
                commentInfo.becomeFirstRes = true
                wself!.navigationController?.pushViewController(commentInfo, animated: true)
                
            }
            cell.forwardBlock = {
              wself?.shareAction(element)
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 2
        {
            let element = dataArr[indexPath.section]
            
            weak var wself = self
            let commentInfo = TimeLineInfoVC()
            commentInfo.block = { wself?.table.reloadData() }
            commentInfo.timeData = element
            commentInfo.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(commentInfo, animated: true)
            
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        guard let view = self.table.tableFooterView
            else{
          return
        }
        
        let offset = scrollView.contentOffset
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = scrollView.bounds.size.height - inset.bottom
        let h = size.height
        
        if (h - offset.y - y < 40 && view.bounds.size.height>10)
        {
           self.loadMoreData()
        }
        
    }
    
    
    func favoriteAction(message:TimeMessage){
       
        let user = UserData.shared
        if user.token == nil
        {
            self.timeLineShowLoginVC()
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
                }
               
            }
        }
        favoriteNet.start()
    }
    
    
    func timeLineShowLoginVC(){
        
        let logVC = LogViewController()
        logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
        
    }

    func shareAction(let data:TimeMessage){
    
        
        let user = UserData.shared
        if user.token == nil
        {
            self.timeLineShowLoginVC()
            return
        }
        
       let shareView = ShareCoverageView(delegate: self)
        shareView.token = UserData.shared.token
        shareView.wallID = data.id
        shareView.showInView(self.tabBarController?.view)
        shareElement = data
    }
    
    func shareActionFinish(success: Bool) {
        
        let shareNet = NetWorkData()
        weak var wself = self
        shareNet.getForwardNu(shareElement.id!) { (result, status) -> (Void) in
            
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
                wself?.shareElement.forwardNu = nu
                wself?.table.reloadData()
            }
        }
        shareNet.start()
        
    }
    
    
    deinit{
        
        net.cancel()
        net = nil
    }

}

class TimeLinePicCell:UITableViewCell {
    let picImageV:UIImageView
//    let heightImage:CGFloat = 115.0
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        picImageV = UIImageView()
        picImageV.translatesAutoresizingMaskIntoConstraints = false
        picImageV.image = UIImage(named: "default_big")
        picImageV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        picImageV.contentMode = .Center
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(picImageV)
        self.setSubViewLayout()
//        self.contentView.addConstraints(NSLayoutConstraint.layoutVerticalFull(picImageV))
    }
    
    
    func setSubViewLayout(){
    
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[picImageV]-15-|", options: [], metrics: nil, views: ["picImageV":picImageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[picImageV]-8-|", options: [], metrics: nil, views: ["picImageV":picImageV]))
        //        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(picImageV))
        self.selectionStyle = .None
        //        self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func loadPicUrl(url:String?,height:Double?)
    {
       if url != nil
       {
//           picImageV.sd_setImageWithURL(NSURL(string: url!), placeholderImage: nil ,complete)
        weak var wimage = picImageV
        picImageV.contentMode = .Center
        
        if height < 115
        {
           picImageV.contentMode = .ScaleAspectFit
        }
        
        picImageV.sd_setImageWithURL(NSURL(string: url!)!, placeholderImage: UIImage(named: "default_big"), completed: { (let image: UIImage!, err: NSError!, type: SDImageCacheType!, url:NSURL!) -> Void in
            
            if err == nil {
              wimage?.contentMode = .ScaleToFill
            }
        })

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
        forwardBt.titleLabel?.font = Profile.font(12)
        forwardBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        forwardBt.translatesAutoresizingMaskIntoConstraints = false
        
        commentBt = UIButton(type: .Custom)
        commentBt.titleLabel?.font = Profile.font(12)
        commentBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        commentBt.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteBt = UIButton(type: .Custom)
        favoriteBt.titleLabel?.font = Profile.font(12)
        favoriteBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        favoriteBt.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
//        forwardBt.backgroundColor = UIColor.redColor()
        forwardBt.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        forwardBt.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        forwardBt.setImage(UIImage(named: "forward_timeLine"), forState: .Normal)
        forwardBt.addTarget(self, action: "forwardAction", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(forwardBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(forwardBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: forwardBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 0.35, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[forwardBt(>=35)]", options: [], metrics: nil, views: ["forwardBt":forwardBt]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[forwardBt(>=20)]", options: [], metrics: nil, views: ["forwardBt":forwardBt]))
        
        
        commentBt.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        commentBt.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        commentBt.setImage(UIImage(named: "comment_timeLine"), forState: .Normal)
        commentBt.addTarget(self, action: "commentAction", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(commentBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(commentBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: commentBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
//        favoriteBt.backgroundColor = UIColor.redColor()
        favoriteBt.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        favoriteBt.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        favoriteBt.addTarget(self, action: "favoriteAction", forControlEvents: .TouchUpInside)
        favoriteBt.setImage(UIImage(named: "favorite_timeLine"), forState: .Normal)
        favoriteBt.setImage(UIImage(named: "forward_timeLine_select"), forState: .Selected)
        self.contentView.addSubview(favoriteBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(favoriteBt, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: favoriteBt, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1.75, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[favoriteBt(>=30)]", options: [], metrics: nil, views: ["favoriteBt":favoriteBt]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[favoriteBt(>=25)]", options: [], metrics: nil, views: ["favoriteBt":favoriteBt]))
        
        
        
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
        userPicV.image = UIImage(named: "settingUser")
        
        nameL = UILabel()
        nameL.translatesAutoresizingMaskIntoConstraints = false
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false
        timeL.textColor = Profile.rgb(191, g: 191, b: 191)
        timeL.font = Profile.font(11)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(userPicV)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(userPicV, toItem: self.contentView))
        
        self.contentView.addSubview(nameL)
       
        
        
        self.contentView.addSubview(timeL)
       
        
        self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }
         self.setSubViewLayout()
    }
    
    func setSubViewLayout(){
    
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[userPicV(33)]", options: [], metrics: nil, views: ["userPicV":userPicV]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userPicV(33)]", options: [], metrics: nil, views: ["userPicV":userPicV]))
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[userPicV]-10-[nameL]", aView: userPicV, bView: nameL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(nameL, toItem: self.contentView))

        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[timeL]-8-|", aView: timeL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(timeL, toItem: self.contentView))
    
    }
    
    func filPersonInfo(pic:String?,name:String?,title:String?,time:String?)
    {
        if pic != nil
        {
           userPicV.sd_setImageWithURL(NSURL(string: pic!), placeholderImage: UIImage(named: "settingUser"))
        }
        
        if name != nil
        {
            let attribute = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(15),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
            
            if title != nil
            {
              attribute.appendAttributedString(NSAttributedString(string:" -\(title!)" , attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
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
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
//        contentL.backgroundColor = UIColor.redColor()
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
        contentL.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(contentL)
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            // Fallback on earlier versions
        }
        self.setSubViewLayout()
    }
    
    
    func setSubViewLayout(){
    
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-8-[contentL]-8-|", aView: contentL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-2-[contentL]-5-|", aView: contentL, bView: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

