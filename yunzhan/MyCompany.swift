//
//  MyCompany.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/25.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class MyCompanyVC: UIViewController {
    
    var dataArr:[[CompanyData]]!
    var net:NetWorkData!
    var hotelCompany:CompanyVC!
    var constructionCompany:CompanyVC!
    var segmentV:TSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相关推荐"

        segmentV = TSegmentedControl(sectionTitles: ["装修公司","酒店住宿"])
        segmentV.addTarget(self, action: "segmentChange", forControlEvents: .ValueChanged)
        segmentV.frame = CGRectMake(0, 64, Profile.width(), 40)
        segmentV.selectionIndicatorColor = Profile.rgb(223, g: 32, b: 82)
        segmentV.textColor = Profile.rgb(102, g: 102, b: 102)
        segmentV.selectionIndicatorHeight = 1
        segmentV.font = Profile.font(15.0)
        segmentV.selectionIndicatorColor = Profile.rgb(223, g: 32, b: 82)
        segmentV.selectionIndicatorMode = HMSelectionIndicatorFillsTop
        //        segmentV.backgroundColor = UIColor.blueColor()
        self.view.addSubview(segmentV)

        
        constructionCompany = CompanyVC()
        constructionCompany.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(constructionCompany.view)
        var  tempView = constructionCompany.view
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-104-[tempView]-0-|", options: [], metrics: nil, views: ["tempView":tempView]))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(constructionCompany.view))
        self.addChildViewController(constructionCompany)
        
        
        
        hotelCompany = CompanyVC()
        hotelCompany.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hotelCompany.view)
        tempView = hotelCompany.view
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-104-[tempView]-0-|", options: [], metrics: nil, views: ["tempView":tempView]))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(hotelCompany.view))
        self.addChildViewController(hotelCompany)
        
        tempView.hidden = true

        
        self.fetchData()

    }
    
    func segmentChange()
    {
        if segmentV.selectedIndex == 0
        {
            hotelCompany.view.hidden = true
            constructionCompany.view.hidden = false
            
        }
        else
        {
            hotelCompany.view.hidden = false
            constructionCompany.view.hidden = true
        }
    }

    
        func fetchData(){
     
        weak var wself =  self
        
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        net = NetWorkData()
        net.getCompanyOfExhibitor { (result, status) -> (Void) in

            loadV.removeFromSuperview()
            if status == NetStatus.NetWorkStatusError
            {
                return
            }
            
            if let arr = result as? [[CompanyData]]{
            
                wself?.dataArr = arr
                
                if arr.count == 2
                {
                  wself?.constructionCompany.setCompanyData(wself?.dataArr[0])
                  wself?.hotelCompany.setCompanyData(wself?.dataArr[1])
                }
                else
                {
                    if arr.count == 0
                    {
                       return
                    }
                    
                    let subArr = arr[0]
                    if subArr.count == 0
                    {
                      return
                    }
                    let element = subArr[0]
                    
                    if element.type == .Hotel
                    {
                       wself?.hotelCompany.setCompanyData(subArr)
                    }
                    else
                    {
                        wself?.constructionCompany.setCompanyData(subArr)
                    }
                }
                
            }

        }
        net.start()
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        if dataArr == nil
//        {
//          return 0
//        }
//        
//        return dataArr.count
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        let subArr = dataArr[section]
//        return subArr.count
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        let subArr = dataArr[indexPath.section]
//        let element = subArr[indexPath.row]
//        
//        if element.type == .Hotel
//        {
//           let height = element.figureOutContentHeight(CGSizeMake(Profile.width() - 30, 1000), font: Profile.font(12))
//           return 105 + height
//        }
//        else
//        {
//           return 90
//        }
//   }
//    
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45
//    }
//    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MoreTableHeadView") as! MoreTableHeadView
//        
//        let subArr = dataArr[section]
//        let element = subArr[0]
//        
//        if element.type == .Hotel
//        {
//            head.iconImage.image = UIImage(named: "hotelHead")
//        }
//        else
//        {
//            head.iconImage.image = UIImage(named: "companyHead")
//        }
//
//        return head
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        
//        let subArr = dataArr[indexPath.section]
//        let temp = subArr[indexPath.row]
//        
//        if temp.type == .Hotel
//        {
//            let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell") as! HotelCell
//            cell.fillHotelData(temp.name, roomNu: temp.roomNu, scroe: temp.score, phoneNu: temp.phone, address: temp.address, route: temp.route)
//            return cell
//        }
//        else
//        {
//            let cell = tableView.dequeueReusableCellWithIdentifier("CompanyCell") as! CompanyCell
//            cell.fillCompanyData(temp.name, phone: temp.phone , mobile: temp.mobile, personName: temp.contact)
//            return cell
//        }
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
}



class CompanyVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView!
    var dataArr:[CompanyData]!
    var net:NetWorkData!
    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
//        table.registerClass(MoreTableHeadView.self, forHeaderFooterViewReuseIdentifier: "MoreTableHeadView")
        table.registerClass(CompanyCell.self , forCellReuseIdentifier: "CompanyCell")
        table.registerClass(HotelCell.self, forCellReuseIdentifier: "HotelCell")

    }
    
    func setCompanyData(data:[CompanyData]?)
    {
       if data == nil
       {
         return
        }
        dataArr = data!
        table.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if dataArr == nil
        {
            return 0
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let element = dataArr[indexPath.row]
        
        if element.type == .Hotel
        {
            let height = element.figureOutContentHeight(CGSizeMake(Profile.width() - 30, 1000), font: Profile.font(12))
            return 105 + height
        }
        else
        {
            return 90
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let temp = dataArr[indexPath.row]
        if temp.type == .Hotel
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("HotelCell") as! HotelCell
            cell.fillHotelData(temp.name, roomNu: temp.roomNu, scroe: temp.score, phoneNu: temp.phone, address: temp.address, route: temp.route)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CompanyCell") as! CompanyCell
            cell.fillCompanyData(temp.name, phone: temp.phone , mobile: temp.mobile, personName: temp.contact)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}









class HotelCell: UITableViewCell,UIAlertViewDelegate {
    
    let titleL:UILabel
    let phoneBt:UIButton
    let addressL:UILabel
    let routeL:UILabel
    let roomNuL:UILabel
    let scoreV:CommentScoreView
    var phoneStr:String!
    let scoreL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        phoneBt = UIButton(type: .Custom)
        phoneBt.titleLabel?.font = Profile.font(12)
        phoneBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState:.Normal)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false
        
        addressL = UILabel()
        addressL.translatesAutoresizingMaskIntoConstraints = false
        
        routeL = UILabel()
        routeL.translatesAutoresizingMaskIntoConstraints = false
        
        roomNuL = UILabel()
        roomNuL.translatesAutoresizingMaskIntoConstraints = false
        
        
        scoreV = CommentScoreView()
        scoreV.setStarTypeIsBig(false)
        scoreV.translatesAutoresizingMaskIntoConstraints = false
        
        scoreL = UILabel()
        scoreL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(titleL)
        titleL.font = Profile.font(15)
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]", aView: titleL, bView: nil))
        
        
        self.contentView.addSubview(roomNuL)
        roomNuL.font = Profile.font(13)
        roomNuL.textColor = Profile.rgb(51, g: 51, b: 51)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[roomNuL]-15-|", aView: roomNuL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(roomNuL, toItem: titleL))
        
        
        self.contentView.addSubview(scoreV)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(scoreV, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[scoreV(75)]", options: [], metrics: nil, views: ["scoreV":scoreV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[scoreV(15)]", options: [], metrics: nil, views: ["scoreV":scoreV,"titleL":titleL]))
        
        
        scoreL.font = Profile.font(11)
        scoreL.textColor = Profile.rgb(255, g: 199, b: 92)
        self.contentView.addSubview(scoreL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(scoreL, toItem: scoreV))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreV]-5-[scoreL]", aView: scoreV, bView: scoreL))
        
        
        phoneBt.addTarget(self, action: "makeACall", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(phoneBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneBt, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[scoreV]-0-[phoneBt(25)]", options: [], metrics: nil, views: ["scoreV":scoreV,"phoneBt":phoneBt]))
        
        
        
        
        addressL.numberOfLines = 0
        addressL.font = Profile.font(12)
        addressL.textColor = Profile.rgb(102, g: 102, b: 102)
        self.contentView.addSubview(addressL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[phoneBt]-0-[addressL]", options: [], metrics: nil, views: ["phoneBt":phoneBt,"addressL":addressL]))
        
        
        
        routeL.numberOfLines = 0
        routeL.font = Profile.font(12)
        routeL.textColor = Profile.rgb(102, g: 102, b: 102)
        self.contentView.addSubview(routeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(routeL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[addressL]-5-[routeL]", options: [], metrics: nil, views: ["routeL":routeL,"addressL":addressL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[routeL]-15-|", options: [], metrics: nil, views: ["routeL":routeL]))
        
    }

    
    func makeACall(){
    
        let alert = UIAlertView(title: "提示", message: "拨打：\(phoneStr)", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.cancelButtonIndex == buttonIndex
        {
           return
        }
        
        let url = NSURL(string: "tel://\(phoneStr)")
        UIApplication.sharedApplication().openURL(url!)
    }
   
    func fillHotelData(title:String?,roomNu:Int?,scroe:Double?,phoneNu:String?,address:String?,route:String?)
    {
        titleL.text = title
        
        if roomNu != nil
        {
            roomNuL.text = "\(roomNu!)个房间"
        }
        if scroe != nil
        {
          scoreV.setScore(scroe!)
//           scoreV.setScore(4.0)
          scoreL.text = "\(scroe!)"
        }
        
        if phoneNu != nil
        {
            phoneStr = phoneNu!
            let att = NSMutableAttributedString(string: "电话：", attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
            att.appendAttributedString(NSAttributedString(string: phoneNu!, attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(255, g: 199, b: 92)]))
            phoneBt.setAttributedTitle(att, forState: .Normal)
//           phoneBt.setTitle("电话：\(phoneNu!)", forState: .Normal)
        }
        if address != nil
        {
          addressL.text = "地址：\(address!)"
        }
        if route != nil
        {
           routeL.text = "交通：\(route!)"
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CompanyCell: UITableViewCell,UIAlertViewDelegate {
    
    let titleL:UILabel
    let phoneBt:UIButton
    let mobileBt:UIButton
    var mobileNu:String!
    var phoneNu:String!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        phoneBt = UIButton(type: .Custom)
        phoneBt.titleLabel?.font = Profile.font(13)
        phoneBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState:.Normal)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false

        
        
        mobileBt = UIButton(type: .Custom)
        mobileBt.titleLabel?.font = phoneBt.titleLabel?.font
        mobileBt.setTitleColor(phoneBt.titleColorForState(.Normal), forState:.Normal)
        mobileBt.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(titleL)
        titleL.font = Profile.font(15)
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]", aView: titleL, bView: nil))

        
//        phoneBt.backgroundColor = UIColor.yellowColor()
        phoneBt.addTarget(self, action: "makePhoneCall", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(phoneBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneBt, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[phoneBt]", options: [], metrics: nil, views: ["titleL":titleL,"phoneBt":phoneBt]))

//        mobileBt.backgroundColor = UIColor.redColor()
        mobileBt.addTarget(self, action: "makeMobileCall", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(mobileBt)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(mobileBt, toItem: phoneBt))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[phoneBt(24)]-0-[mobileBt(24)]", options: [], metrics: nil, views: ["mobileBt":mobileBt,"phoneBt":phoneBt]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(mobileBt, toItem: titleL))
        
    }

    
    func fillCompanyData(title:String?,phone:String?,mobile:String?,personName:String?)
    {
        titleL.text = title
        if phone != nil
        {
            phoneNu = phone!
            let att = NSMutableAttributedString(string: "电话：", attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
            att.appendAttributedString(NSAttributedString(string: phoneNu!, attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(255, g: 199, b: 92)]))
            phoneBt.setAttributedTitle(att, forState: .Normal)

//           phoneBt.setTitle("电话：\(phone!)", forState: .Normal)
        }
        
        if mobile != nil
        {
            mobileNu = mobile!
            
            let att = NSMutableAttributedString(string: "联系人：", attributes: [NSFontAttributeName:Profile.font(13),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)])
            
            

            if personName != nil
            {
                att.appendAttributedString(NSAttributedString(string: personName!, attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(102, g: 102, b: 102)]))
//               mobileBt.setTitle("联系人：\(personName!)  \(mobile!)", forState: .Normal)
            }
            att.appendAttributedString(NSAttributedString(string: "  \(mobile!)", attributes: [NSFontAttributeName:Profile.font(12),NSForegroundColorAttributeName:Profile.rgb(255, g: 199, b: 92)]))
            mobileBt.setAttributedTitle(att, forState: .Normal)
        }
    
    }
    
    
    func makePhoneCall(){
    
        let alert = UIAlertView(title: "提示", message: "拨打：\(phoneNu)", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 1
        alert.show()

    }
    
    func makeMobileCall(){
      
        let alert = UIAlertView(title: "提示", message: "拨打：\(mobileNu)", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = 2
        alert.show()
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.cancelButtonIndex == buttonIndex
        {
            return
        }
        
        var url:NSURL!
        if alertView.tag == 1
        {
           url = NSURL(string: "tel://\(phoneNu)")
        }
        else
        {
           url = NSURL(string: "tel://\(mobileNu)")
        }
        
        UIApplication.sharedApplication().openURL(url)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

