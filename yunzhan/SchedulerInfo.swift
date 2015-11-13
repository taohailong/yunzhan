//
//  SchedulerInfo.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/10.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class SchedulerInfoVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var schedulerData: SchedulerData!
    var table : UITableView!
    var contacts:[PersonData]!
    var guests:[PersonData]!
    var contents:[String]!
    var net:NetWorkData!
    var schedulerID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "日程详情"
        
        let favoriteBt = UIButton(type: .Custom)
        favoriteBt.frame = CGRectMake(0, 0, 35, 35)
//        favoriteBt.backgroundColor = UIColor.blackColor()
        favoriteBt.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        favoriteBt.setImage(UIImage(named: "favorite"), forState: .Normal)
        favoriteBt.setImage(UIImage(named: "favorite_select"), forState: .Selected)
        favoriteBt.addTarget(self, action: "favoriteAction", forControlEvents: .TouchUpInside)
        
        let leftBar = UIBarButtonItem(customView: favoriteBt)
        self.navigationItem.rightBarButtonItem = leftBar

        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.separatorStyle = .None
        table.delegate = self
        table.dataSource = self
        table.registerClass(SchedulerInfoHeadCell.self , forCellReuseIdentifier: "SchedulerInfoHeadCell")
        table.registerClass(SchedulerInfoTitleCell.self, forCellReuseIdentifier: "SchedulerInfoTitleCell")
        table.registerClass(SchedulerInfoContactCell.self , forCellReuseIdentifier: "SchedulerInfoContactCell")
        table.registerClass(ExhibitorMapCell.self , forCellReuseIdentifier: "ExhibitorMapCell")
        table.registerClass(CommonOneLabelCell.self , forCellReuseIdentifier: "CommonOneLabelCell")
        table.registerClass(ExhibitorMoreCell.self , forCellReuseIdentifier: "ExhibitorMoreCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        
        self.fetchNetData()
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
                    print(button)
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
            print(tuple)
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if contents == nil
        {
          return 0
        }
        
        if section == 0
        {
          return 1
        }
        
        var nu = 2 + contents.count
        if contacts != nil
        {
           nu = nu+contacts.count+1
        }
        
        
        if guests != nil
        {
           nu = nu+guests.count+1
        }
        
        return   nu
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
          return 0
        }
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let commonTitleHeight:CGFloat = 30
        if indexPath.section == 0
        {
            return 145
        }
        else if indexPath.row == 0
        {
          return 35
        }
        else if indexPath.row == 1
        {
           return commonTitleHeight
        }
        else if  indexPath.row-2 < contents.count
        {
          return 25
        }
        else if guests != nil && indexPath.row-3 < contents.count+guests.count
        {
            if indexPath.row-2 == contents.count
            {
//                "参会嘉宾"
                return commonTitleHeight
            }
            else
            {
                return 25
            }
        }
        else
        {
            var nu = 2+contents.count
            if guests != nil
            {
                nu = nu+guests.count+1
            }
            
            if nu == indexPath.row
            {
//                "大会联系人"
                return commonTitleHeight
                
            }
            else
            {
                return 50
            }

        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
           
             let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoHeadCell") as! SchedulerInfoHeadCell
            cell.fillData(schedulerData.title, time: "\(schedulerData.date) \(schedulerData.time)", address: schedulerData.address, type: schedulerData.type!, company: schedulerData.company!)
            return cell
        }
        
        else if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMoreCell") as! ExhibitorMoreCell
            cell.iconImage.image = UIImage(named: "schedulerInfo")
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoTitleCell") as! SchedulerInfoTitleCell
            cell.titleL.text = "大会内容"
            return cell
        }
        else if indexPath.row-2 < contents.count
        {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonOneLabelCell") as! CommonOneLabelCell
            cell.titleL.text = contents[indexPath.row - 2]
            return cell
        }
        else if  guests != nil && indexPath.row-3 < contents.count+guests.count
        {
            if indexPath.row-2 == contents.count
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoTitleCell") as! SchedulerInfoTitleCell
                cell.titleL.text = "参会嘉宾"
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("CommonOneLabelCell") as! CommonOneLabelCell
                let guest = guests[indexPath.row-2-contents.count-1]
                
                let attributeStr = NSMutableAttributedString(string: "\(guest.title!)  ", attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)])
                
                let nameAttribute = NSMutableAttributedString(string: guest.name!, attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
                
                attributeStr.appendAttributedString(nameAttribute)
                cell.titleL.attributedText = attributeStr
                return cell
            }
        }
        else
        {
            var nu = 2+contents.count
           if guests != nil
           {
              nu = nu+guests.count+1
           }
           
           if nu == indexPath.row
           {
               let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoTitleCell") as! SchedulerInfoTitleCell
               cell.titleL.text = "大会联系人"
               return cell

            }
            else
           {
               let cell = tableView.dequeueReusableCellWithIdentifier("SchedulerInfoContactCell") as! SchedulerInfoContactCell
            
               let person = contacts[indexPath.row-nu-1]
               cell.fillData(person.title, name: person.name, phone: person.phone)
                weak var wself = self
                weak var wperson = person
               cell.tapBlock = { wself?.addMyContact(wperson!) }

               return cell
            }
        }
        
    }
    
    
    func addMyContact(person: PersonData)
    {
        if UserData.shared.token == nil
        {
            let loginVC = LogViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        
        let tempNet = NetWorkData()
        tempNet.addContact(person.exhibitorID!, personID: person.id!) { (result, status) -> (Void) in
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
        }
        tempNet.start()
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
        
//        self.contentView.addSubview(iconImage)
//        iconImage.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[iconImage]", aView: iconImage, bView: nil))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[iconImage]", aView: iconImage, bView: nil))
        
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]", aView: titleL, bView: nil))
        

        
        timeL.textColor = Profile.rgb(102, g: 102, b: 102)
        timeL.font = Profile.font(13)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(timeL)
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-15-[timeL]", options: [], metrics: nil, views: ["titleL":titleL,"timeL":timeL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-15-[timeL]", aView: titleL, bView: timeL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(timeL, toItem: titleL))
        

        addressL.textColor = timeL.textColor
        addressL.font = timeL.font
        addressL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[timeL]-10-[addressL]", aView: timeL, bView: addressL))
        
        
        typeL.translatesAutoresizingMaskIntoConstraints = false
        typeL.textColor = timeL.textColor
        typeL.font = timeL.font
        self.contentView.addSubview(typeL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[addressL]-10-[typeL]", aView: addressL, bView: typeL))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(typeL, toItem: timeL))
        
        companyL.translatesAutoresizingMaskIntoConstraints = false
        companyL.textColor = timeL.textColor
        companyL.font = timeL.font
        self.contentView.addSubview(companyL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(companyL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[typeL]-10-[companyL]", aView: typeL, bView: companyL))
        
    }

    func fillData(title:String,time:String,address:String,type:Bool,company:String)
    {
//        iconImage.sd_setImageWithURL(NSURL(string: iconUrl), placeholderImage: nil)
        titleL.text = title
        timeL.text = "时间：\(time)"
        addressL.text = "地点：\(address)"
        typeL.text = type ? "类型：公开":"类型：非公开"
        companyL.text = "主办单位：\(company)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SchedulerInfoTitleCell: UITableViewCell {
    
    let titleL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let spot = UIView()
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 4.0
        
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraint(NSLayoutConstraint(item: spot, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1.0, constant: 3))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
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
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-33-[titleL]", aView: titleL, bView: nil))
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
              return
            }
        
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
