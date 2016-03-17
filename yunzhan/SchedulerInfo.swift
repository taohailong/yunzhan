//
//  SchedulerInfo.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/10.
//  Copyright © 2015年 miaomiao. All rights reserved.
//
/*

//private int slevel = 0; 活动级别,0: 展会期间的活动, 1: 非展会期间活动
private int smode = 0; //活动方式,0: 公开, 1: 不公开
private int stype = 1; //活动类型,1:宴会,2:论坛,3:企业活动
*/
import Foundation
class SchedulerInfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var schedulerData: SchedulerData!
    var table : UITableView!
    var contacts:[PersonData]!
    var guests:[PersonData]!
    var contents:[String]!
    var net:NetWorkData!
    var schedulerID:String!
    var callBlock:((Void)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "活动详情"
        
        let favoriteBt = UIButton(type: .Custom)
        favoriteBt.frame = CGRectMake(0, 0, 35, 35)
//        favoriteBt.backgroundColor = UIColor.blackColor()
        favoriteBt.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        favoriteBt.setImage(UIImage(named: "favorite"), forState: .Normal)
        favoriteBt.setImage(UIImage(named: "favorite_select"), forState: .Selected)
        favoriteBt.addTarget(self, action: "favoriteAction", forControlEvents: .TouchUpInside)
        
        let leftBar = UIBarButtonItem(customView: favoriteBt)
        self.navigationItem.rightBarButtonItem = leftBar

        
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.separatorStyle = .None
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.registerClass(SchedulerInfoHeadCell.self , forCellReuseIdentifier: "SchedulerInfoHeadCell")
        table.registerClass(SchedulerInfoTitleHeadView.self, forHeaderFooterViewReuseIdentifier: "SchedulerInfoTitleHeadView")
        
        table.registerClass(SchedulerInfoContactCell.self , forCellReuseIdentifier: "SchedulerInfoContactCell")
        table.registerClass(ExhibitorMapCell.self , forCellReuseIdentifier: "ExhibitorMapCell")
        table.registerClass(CommonOneLabelCell.self , forCellReuseIdentifier: "CommonOneLabelCell")
        table.registerClass(ExhibitorMoreCell.self , forCellReuseIdentifier: "ExhibitorMoreCell")
        table.registerClass(MoreTableHeadView.self, forHeaderFooterViewReuseIdentifier: "MoreTableHeadView")
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.checkFavoriteStatus()
        self.fetchNetData()
    }
    
    
    func checkFavoriteStatus(){
        
        let user = UserData.shared
        if user.token == nil
        {
            return
        }

        
        let network = NetWorkData()
        network.checkSchedulerStatus(schedulerID) { (status) -> Void in
            
            let leftBar = self.navigationItem.rightBarButtonItem
            if let button = leftBar?.customView as? UIButton
            {
                if status == true
                {
                    button.selected = true
                }
                else
                {
                    button.selected = false
                }
            }
        }
        network.start()
    }
    
    
    func favoriteAction(){
    
        if UserData.shared.token == nil
        {
            let loginVC = LogViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        
        if schedulerID != nil
        {
            let leftBar = self.navigationItem.rightBarButtonItem
            if let button = leftBar?.customView as? UIButton
            {
                if button.selected == true
                {
                   self.delFavorite()
                }
                else
                {
                   self.favorite()
                }
            }

        }
    }
    
    
    
    func favorite(){
       
          weak var wself = self
          let loadV = THActivityView(activityViewWithSuperView: self.view)
          let favoriteNet = NetWorkData()
          favoriteNet.addMyScheduler(schedulerID, block: { (result, status) -> (Void) in
            
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
            
            if status == .NetWorkStatusError
            {
            }
            else
            {
               let leftBar = wself?.navigationItem.rightBarButtonItem
                if let button = leftBar?.customView as? UIButton
                {
                    button.selected = true
//                    print(button)
                }
            }
          })
        favoriteNet.start()
    }

    
    func delFavorite(){
    
        weak var wself = self
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        let favoriteNet = NetWorkData()
        favoriteNet.delectMyScheduler(schedulerID, block: { (result, status) -> (Void) in
            
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
            
            if status == .NetWorkStatusError
            {
            }
            else
            {
                if wself?.callBlock != nil
                {
                   wself?.callBlock()
                }
                let leftBar = wself?.navigationItem.rightBarButtonItem
                if let button = leftBar?.customView as? UIButton
                {
                    button.selected = false
                }
            }
        })
        favoriteNet.start()
    }
    
    
    func fetchNetData(){
      
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        
        weak var wself = self
        net = NetWorkData()
        net.getSchedulerInfo(schedulerID) { (result, status) -> (Void) in
            
            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.view)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchNetData()
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

            guard let tuple = result as? (scheduler:SchedulerData,contacts:[PersonData],guests:[PersonData],contents:[String])
            else
            {
              return
            }
//            print(tuple)
            wself?.schedulerData = tuple.scheduler
            
            if tuple.guests.count != 0
            {
              wself?.guests = tuple.guests
            }
            
            if tuple.contacts.count != 0
            
            {
              wself?.contacts = tuple.contacts
            }
            wself?.contents = tuple.contents
            wself?.table.reloadData()
        }
        net.start()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var nu = 5
        if contents == nil || contents.count == 0
        {
          if guests == nil || guests.count == 0
          {
            if contacts == nil || contacts.count == 0
            {
               nu = 1
            }
          }
        }
        return nu
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0
        {
            if schedulerData == nil
            {
              return 0
            }
          return 1
        }
        
        else if section == 1
        {
          return 0
        }
        else if section == 2
        {
           if contents != nil
           {
              return contents.count
            }
            return 0
        }
        else if section == 3
        {
            if guests != nil
            {
                return guests.count
            }
            return 0
        }
        else
        {
            if contacts != nil
            {
                return contacts.count
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let commonTitleHeight:CGFloat = 27
        if section == 0
        {
          return 0.1
        }
        if section == 1
        {
          return 45
        }
        else if section == 2
        {
            if contents == nil || contents.count == 0
            {
                return 0.1
            }
            return commonTitleHeight
        }
        else if section == 3
        {
            if guests == nil || guests.count == 0
            {
                return 0.1
            }
            return commonTitleHeight
        }
        else
        {
            if contacts == nil || contacts.count == 0
            {
                return 0.1
            }
             return commonTitleHeight
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
          return nil
        }
        
        if section == 1
        {
            let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MoreTableHeadView") as! MoreTableHeadView
            head.iconImage.image = UIImage(named: "schedulerInfo")
           return head
        }
        else if section == 2
        {
            if contents == nil ||  contents.count == 0
            {
               return nil
            }
            let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SchedulerInfoTitleHeadView") as! SchedulerInfoTitleHeadView
            head.titleL.text = "大会内容"
            return head
            
        }
        else if section == 3
        {
            if guests == nil || guests.count == 0
            {
                return nil
            }
            let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SchedulerInfoTitleHeadView") as! SchedulerInfoTitleHeadView
            head.titleL.text = "参会嘉宾"
            return head
        }
        else
        {
            if contacts == nil || contacts.count == 0
            {
                return nil
            }
            let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SchedulerInfoTitleHeadView") as! SchedulerInfoTitleHeadView
            head.titleL.text = "大会联系人"
            return head
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        

        if indexPath.section == 0
        {
//            第一行高度
            return 137
        }
        else if indexPath.section == 4
        {
//            联系人
            return 60
        }
        else if indexPath.section == 2
        {
            let c = contents[indexPath.row]
            return c.boundingRectWithSize(CGSizeMake(Profile.width()-38, 1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:Profile.font(13)], context: nil).height + 12
        }
        else
        {
//          大会
          return 25
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
           
             let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoHeadCell") as! SchedulerInfoHeadCell
            cell.fillData(schedulerData.title, time: "\(schedulerData.date) \(schedulerData.time)", address: schedulerData.address, type: schedulerData.typeName, company: schedulerData.company)
            return cell
        }
        
        else if indexPath.section == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonOneLabelCell") as! CommonOneLabelCell
            cell.titleL.text = contents[indexPath.row]
            return cell
        }
        else if  indexPath.section == 3
        {
                let cell = tableView.dequeueReusableCellWithIdentifier("CommonOneLabelCell") as! CommonOneLabelCell
                let guest = guests[indexPath.row]
                
                let attributeStr = NSMutableAttributedString(string: "\(guest.title!)  ", attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)])
                
                let nameAttribute = NSMutableAttributedString(string: guest.name!, attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
                
                attributeStr.appendAttributedString(nameAttribute)
                cell.titleL.attributedText = attributeStr
                return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoContactCell") as! SchedulerInfoContactCell
            
            let person = contacts[indexPath.row]
            cell.fillData(person.title, name: person.name, chatID: person.chatID,personAdd: person.favorite)
            weak var wself = self
            weak var wperson = person
            cell.chatBlock = {wself?.showChatView(wperson!)}
            cell.favouriteBlock = { wself?.addMyContact(wperson!) }
            cell.tapBlock = { wself?.showUserInfoVC((wperson?.id)!) }

            return cell
        }
        
    }
    
    
    func checkLogStatus()->Bool
    {
        weak var wself = self
        if UserData.shared.token == nil
        {
            let loginVC = LogViewController()
            loginVC.setLogResturnBk({ (let success:Bool) -> Void in
                
                if success == true
                {
                    wself?.fetchNetData()
                }
            })
            self.navigationController?.pushViewController(loginVC, animated: true)
            return false
        }
            return true
     }

    
    
    func addMyContact(person: PersonData)
    {
        if self.checkLogStatus() == false
        {
            return
        }
        
        let isFavorite = person.favorite
        weak var wself = self
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        let tempNet = NetWorkData()
        
        tempNet.modifyFavouritePersonStatus(person.id!, isAdd: !isFavorite) { (result, status) -> (Void) in
            
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
            if status == .NetWorkStatusSucess
            {
                person.favorite = !isFavorite
                wself?.table.reloadData()
            }

        }
        
        tempNet.start()
    }


    
    func showUserInfoVC(userID:String){
        
        weak var wself = self
        let userInfo = UserInfoVC(userID: userID)
        userInfo.favouriteActionBlock = { wself?.fetchNetData() }
        self.navigationController?.pushViewController(userInfo, animated: true)
    }

    
    
    func showChatView(person:PersonData){
    
        if self.checkLogStatus() == false
        {
            return
        }
        let chatView = MessageVC(conversationChatter: person.chatID)
        if chatView == nil
        {
            return
        }
        chatView?.title = person.name
        self.navigationController?.pushViewController(chatView!, animated: true)
    
    }
    
    
    deinit{
        net = nil
    }

}

class SchedulerInfoHeadCell: UITableViewCell {
    
//    let iconImage :UIImageView
    let titleL:UILabel
    let timeL:UILabel
    let typeL:UILabel
    let addressL:UILabel
    let companyL:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
//        iconImage = UIImageView()
        timeL = UILabel()
        typeL = UILabel()
        addressL = UILabel()
        companyL = UILabel()
        titleL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        titleL.lineBreakMode = .ByCharWrapping
        titleL.numberOfLines = 0
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]-0-|", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]", aView: titleL, bView: nil))
        

        
        timeL.textColor = Profile.rgb(102, g: 102, b: 102)
        timeL.font = Profile.font(13)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(timeL)

        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-13-[timeL]", aView: titleL, bView: timeL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(timeL, toItem: titleL))
        

        addressL.textColor = timeL.textColor
        addressL.font = timeL.font
        addressL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-8-[addressL]", aView: timeL, bView: addressL))
        
        
        typeL.translatesAutoresizingMaskIntoConstraints = false
        typeL.textColor = timeL.textColor
        typeL.font = timeL.font
        self.contentView.addSubview(typeL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[addressL]-8-[typeL]", aView: addressL, bView: typeL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(typeL, toItem: timeL))
        
        companyL.translatesAutoresizingMaskIntoConstraints = false
        companyL.textColor = timeL.textColor
        companyL.font = timeL.font
        self.contentView.addSubview(companyL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(companyL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[typeL]-8-[companyL]-8-|", aView: typeL, bView: companyL))
        
    }

    func fillData(title:String?,time:String?,address:String?,type:String?,company:String?)
    {
//        iconImage.sd_setImageWithURL(NSURL(string: iconUrl), placeholderImage: nil)
        titleL.text = title
        if time != nil
        {
            timeL.text = "时间：\(time!)"
        }
        
        if address != nil
        {
            addressL.text = "地点：\(address!)"
        }
        if let f = type
        {
           typeL.text = "类型：\(f)"
        }
        else
        {
           typeL.text = "类型：非公开"
        }
        if company != nil
        {
          companyL.text = "主办单位：\(company!)"
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SchedulerInfoTitleHeadView: UITableViewHeaderFooterView {
    
    let titleL:UILabel
    override init(reuseIdentifier: String?) {
        
        titleL = UILabel()
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.whiteColor()
        let spot = UIView()
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 3.0
        
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: spot, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[spot(6)]", options: [], metrics: nil, views: ["spot":spot]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(6)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
        titleL.textColor = Profile.rgb(102, g: 102, b: 102)
        titleL.font = Profile.font(14)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("[spot]-10-[titleL]", aView: spot, bView: titleL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: spot))
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CommonOneLabelCell: UITableViewCell {
    let titleL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(13)
        titleL.numberOfLines = 0
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.setSubViewLayout()
    }

    func setSubViewLayout(){
    
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-33-[titleL]-5-|", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-5-[titleL]-5-|", aView: titleL, bView: nil))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SchedulerInfoContactCell: ExhibitorPerson {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        for temp  in self.contentView.constraints
        {
           if temp.firstAttribute == .Left && temp.secondAttribute == .Left && temp.firstItem as! NSObject == titleL
           {
              temp.constant = 33
               break
            }
        
        }
        
        
        for temp  in self.contentView.constraints
        {
            if temp.firstAttribute == .Left && temp.secondAttribute == .Left && temp.firstItem as! NSObject == phoneBt
            {
                temp.constant = 91
                return
            }
            
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
