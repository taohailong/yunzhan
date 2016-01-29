//
//  ExhibitorInfoCV.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/6.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class ExhibitorController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var net: NetWorkData!
    var check:NetWorkData!
    var id:String?
    var productArr:[ProductData]!
    var personArr:[PersonData]!
    var elementData:ExhibitorData!
    var introductArr:[PicData]!
    var height_OneSection:CGFloat = 100
    var callBackBlock:(Void->Void)!
    var close:Bool = false
    var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let favoriteBt = UIButton(type: .Custom)
        favoriteBt.frame = CGRectMake(0, 0, 35, 35)
        favoriteBt.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        favoriteBt.setImage(UIImage(named: "favorite"), forState: .Normal)
        favoriteBt.setImage(UIImage(named: "favorite_select"), forState: .Selected)
        favoriteBt.addTarget(self, action: "favoriteAction", forControlEvents: .TouchUpInside)
        
        let leftBar = UIBarButtonItem(customView: favoriteBt)
        self.navigationItem.rightBarButtonItem = leftBar
        
        
        
        table = UITableView(frame: CGRect.zero, style: UITableViewStyle.Grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.separatorStyle = .None
        table.translatesAutoresizingMaskIntoConstraints = false
        table.registerClass(ExhibitorInfoHeadCell.self, forCellReuseIdentifier: "ExhibitorInfoHeadCell")
        table.registerClass(ExhibitorMoreCell.self, forCellReuseIdentifier: "ExhibitorMoreCell")
        table.registerClass(ExhibitorProductCell.self, forCellReuseIdentifier: "ExhibitorProductCell")
        table.registerClass(ExhibitorPerson.self , forCellReuseIdentifier: "ExhibitorPerson")
        table.registerClass(ExhibitorMapCell.self , forCellReuseIdentifier: "ExhibitorMapCell")
        table.registerClass(ExhibitorIntroduceCell.self, forCellReuseIdentifier: "ExhibitorIntroduceCell")
        table.registerClass(ExhibitorMoreIndicateCell.self , forCellReuseIdentifier: "ExhibitorMoreIndicateCell")
        table.registerClass(ContentLabelCell.self, forCellReuseIdentifier: "ContentLabelCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.fetchData()
        self.checkFavoriteStatus()
    }
    
    func checkFavoriteStatus(){
    
        let user = UserData.shared
        
        if  user.token == nil
        {
            return
        }

        
        check = NetWorkData()
        check.checkExhibitorStatus(id!) { (status) -> Void in
            
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
        check.start()
    }
    
    
    
    func favoriteAction(){
    
        if UserData.shared.token == nil
        {
            let loginVC = LogViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        
        if id != nil
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
        favoriteNet.addMyExhibitor(id!, block: { (result, status) -> (Void) in
            
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
        favoriteNet.delectMyExhibitor(id!, block: { (result, status) -> (Void) in

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
                if wself?.callBackBlock != nil
                {
                   wself?.callBackBlock()
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
    
    func fetchData(){
    
        let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.getExhibitorInfo(id!) { (result, status) -> (Void) in
            
            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.view)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchData()
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

            
          guard let tuple = result as? (data:ExhibitorData,personArr:[PersonData],producArr:[ProductData],introduce:[PicData]) else
          {
            return
         }
            wself?.elementData = tuple.data
            wself?.title = wself?.elementData.name
            if tuple.personArr.count != 0
            {
                wself?.personArr = tuple.personArr
            }
            if tuple.producArr.count != 0
            {
               wself?.productArr = tuple.producArr
            }
            
            if tuple.introduce.count != 0
            {
               wself?.introductArr = tuple.introduce
            }
            
           
            wself?.table.reloadData()
        }
       net.start()
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if elementData == nil
        {
          return 0
        }
        let nu = 4
        return nu
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        if section == 0
        {
            if elementData == nil
            {
              return 0
            }
            
            height_OneSection =  elementData.getIntroductSize(Profile.font(11), size: CGSizeMake(Profile.width()-30,1000))
            if height_OneSection < 27
            {
              return 2
            }
            
          return 3
        }
        else if section == 1
        {
           if productArr == nil
           {
              return 0
           }
            
            return 1
        }
        
        else if section == 3
        {
            if introductArr == nil
            {
                return 0
            }
           return 2
        }
        else
        {
        
            if personArr == nil && elementData.addressMap == nil
            {
                return 0
            }
            else if personArr == nil && elementData.addressMap != nil
            {
                return 2
            }
            else if personArr != nil && elementData.addressMap != nil
            {
                return personArr.count + 2
            }
            else
            {
               return personArr.count + 1
            }
        }
        
//        return
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0
        {
          return 1
        }
        
        if section == 0
        {
            if elementData == nil
            {
                return 0.5
            }
            return 14
        }
        else if section == 1
        {
            if productArr == nil
            {
                return 0.5
            }
            return 14
        }
        
        if section == 3
        {
            if introductArr == nil
            {
                return 0.5
            }
            return 14
        }
        
        if personArr == nil && elementData?.addressMap == nil
        {
            return 0.5
        }
        return 14
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
              return 90
            }
            else if indexPath.row == 1
            {
                if height_OneSection > 37 && close == false
                {
                  return 37
                }
                else
                {
                   return height_OneSection + 12
                }
                
            }
            else
            {
               return 30
            }
           
            
        }
        else if indexPath.section == 1
        {
//            产品
            if productArr == nil
            {
                return 0
            }
           return 180
        }
            
        else if indexPath.section == 3
        {
            if indexPath.row == 0
            {
              return 35
            }
            else
            {
//                企业形象展示
                return (Profile.width()-20)/3*0.6+19
//              return 85
            }
        }
        else
        {
            if indexPath.row == 0
            {
//                头部
              return 35
            }
            else if personArr == nil
            {
                //                地图
               return 150
            }
            else if indexPath.row == (personArr.count + 1)
            {
//                地图
              return 150
            }
            else
            {
//                联系人
              return 60
            }
        
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorInfoHeadCell") as!ExhibitorInfoHeadCell
                
                cell.fillData(elementData.iconUrl, name: elementData.name, company: elementData.remark, addre: elementData.address, location: elementData.location, content: elementData.introduct)
                weak var wself = self
                cell.tapBlock = {
                    wself?.showZoomMap(wself?.elementData.addressMap,imageView: nil)
                }
                return cell
            }
            
            else if indexPath.row == 1
            {
               let cell = tableView.dequeueReusableCellWithIdentifier("ContentLabelCell") as! ContentLabelCell
                cell.titleL.text = elementData.introduct
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMoreIndicateCell") as! ExhibitorMoreIndicateCell
                return cell
            }
            
        }
        else if indexPath.section == 1
        {
            
           let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorProductCell") as! ExhibitorProductCell
            
            weak var wself = self
            cell.tapBlock = { wself?.showProductInfoController() }
            cell.fillImageArr(productArr)
           return cell
          
        }
            
        else if indexPath.section == 3
        {

            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMoreCell") as! ExhibitorMoreCell
                cell.iconImage.image = UIImage(named: "exhibitorIntroduct")
                cell.moreBt.hidden = false
                weak var wself = self
                cell.tapBlock = { wself?.showExhibitorImage()}
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorIntroduceCell") as! ExhibitorIntroduceCell
                cell.fillImageArr(introductArr)
                 weak var wself = self
                
                cell.block = {wself?.showExhibitorImage() }
                return cell
            }
        }
            
        else
        {
            //            展会信息
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMoreCell") as! ExhibitorMoreCell

                cell.iconImage.image = UIImage(named: "exhibitorInfoHead")
                return cell
            }
                
            else if personArr == nil
            {
                weak var wself = self
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMapCell") as! ExhibitorMapCell
                cell.block  = {
                    wself?.showZoomMap(wself?.elementData.addressMap,imageView: cell.mapImageView)
                }
                cell.fillData(elementData.location, locationUrl: elementData.addressMap)
                return cell
            }
            else if indexPath.row == personArr.count+1
            {
                 weak var wself = self
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMapCell") as! ExhibitorMapCell
                cell.block  = {
                    wself?.showZoomMap(wself?.elementData.addressMap,imageView: cell.mapImageView)
                }
                cell.fillData(elementData.location, locationUrl: elementData.addressMap)
                return cell
            }
            else
            {
                let person = personArr[indexPath.row-1]
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorPerson") as! ExhibitorPerson
                cell.fillData(person.title , name:person.name, chatID: person.chatID,personAdd: person.favorite)
                weak var wself = self
                weak var wperson = person
                cell.favouriteBlock = { wself?.addMyContact(wperson!) }
                cell.tapBlock = { wself?.showUserInfoVC((wperson?.id)!) }
                cell.chatBlock = { wself?.showChatView(wperson!)}
                return cell

            }
        }
 
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 2
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExhibitorMoreIndicateCell
            
            if cell.titleL.text == "收起"
            {
                close = false
                cell.titleL.text = "查看全部"
                height_OneSection = 100
            }
            else
            {
                close = true
                cell.titleL.text = "收起"
                height_OneSection = 120
            }
            
            
            tableView.reloadData()
           
        }
    }
    
    
    func showZoomMap(url:String?,imageView:UIImageView?){
        
        let zoom = ZoomVC()
        zoom.url = url
        
        if imageView?.image == UIImage(named: "default")
        {
          
        }
        else if imageView == nil
        {
            
        }
        else
        {
           let frame = imageView?.superview?.superview!.convertRect(imageView!.frame, toView: self.navigationController?.view)
            zoom.targetImageV = imageView
            zoom.centerPoint = CGPointMake(self.view.center.x, (frame?.origin.y)! + (imageView?.frame.size.height)!/2)
        }
        
        self.presentViewController(zoom, animated: false) { () -> Void in
            
        }

        //        self.navigationController?.pushViewController(zoom, animated: true)
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
                    wself?.fetchData()
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
    
    
    func showProductInfoController(){
        
       let productVC = ProductListVC()
        productVC.products = productArr
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    
    
    func showUserInfoVC(userID:String){
    
        weak var wself = self
        let userInfo = UserInfoVC(userID: userID)
        userInfo.favouriteActionBlock = { wself?.fetchData() }
        self.navigationController?.pushViewController(userInfo, animated: true)
    }
    
    
    func showChatView(person :PersonData){
    
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
    
    
    func showExhibitorImage()
    {
        var picHtml = ""
        
        let width = Int(Profile.width()) - 16
        for p in introductArr
        {
            if p.url != nil
            {
                let s = "<img onload =  \"{if(this.width>\(width)){ this.height= \(width)/ this.width*this.height} else{ this.width = \(width)} }\" src=\"\(p.url!)\" style=\"margin-bottom:8px\"/>"
                picHtml = picHtml + s
                
            }
        }
        
        let html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"3px\" color=\"black\">企业形象</font></p>\(picHtml)</body></html>"
//        print(html)
        let web = CommonWebController(html: html)
        web.title = "企业形象"
        self.navigationController?.pushViewController(web, animated: true)

    }
    
    deinit{
        net = nil
    }

}

class ExhibitorInfoHeadCell: UITableViewCell {
    
    let iconImage:UIImageView
    var tapBlock:(Void ->Void)?
    var height:CGFloat?
    let titleL:UILabel
//    let companyNameL:UILabel
    let addressL:UILabel
    let contentL:UILabel
    let locationBt:UIButton
    var moreBt:UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        iconImage = UIImageView()
        iconImage.image = UIImage(named: "default")
        iconImage.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        
        titleL = UILabel()
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        titleL.numberOfLines = 0
        
//        companyNameL = UILabel()
//        companyNameL.textColor = Profile.rgb(153, g: 153, b: 153)
//        companyNameL.font = Profile.font(11)
        
        
        addressL = UILabel()
        addressL.textColor = Profile.rgb(102, g: 102, b: 102)
        addressL.font = Profile.font(12)
        
        contentL = UILabel()
        contentL.numberOfLines = 0
        contentL.textColor = Profile.rgb(102, g: 102, b: 102)
        contentL.font = Profile.font(11)
        
        locationBt = UIButton(type: .Custom)
        locationBt.setTitleColor(Profile.rgb(107, g: 206, b: 234), forState: .Normal)
        locationBt.titleLabel?.font = Profile.font(13)
        locationBt.translatesAutoresizingMaskIntoConstraints = false
//        locationBt.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0)
//        locationBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 3)
//        locationL = UILabel()
//        locationL.textColor = Profile.rgb(107, g: 206, b: 234)
//        locationL.font = Profile.font(13)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        
        iconImage.contentMode = .ScaleAspectFit
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage(40)]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[iconImage(40)]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        
       
        
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconImage]-15-[titleL]-15-|", options: [], metrics: nil, views: ["iconImage":iconImage,"titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
    
        self.contentView.addSubview(addressL)
        addressL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[addressL]", options: [], metrics: nil, views: ["titleL":titleL,"addressL":addressL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL , toItem: titleL))
    
        
       
        self.contentView.addSubview(locationBt)
        locationBt.addTarget(self, action: "locationAction:", forControlEvents: .TouchUpInside)
        locationBt.setImage(UIImage(named: "exhibitorLocation"), forState:.Normal)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(locationBt, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[addressL]-8-[locationBt]", options: [], metrics: nil, views: ["locationBt":locationBt,"addressL":addressL]))
        

    }

    func locationAction(button:UIButton)
    {
        if tapBlock != nil
        {
            tapBlock!()
        }
    }
    
    func fillData(iconUrl:String?,name:String?,company:String?,addre:String?,location:String?,content:String?)
    {
        if iconUrl != nil
        {
           iconImage.sd_setImageWithURL(NSURL(string: iconUrl!), placeholderImage: UIImage(named: "default"))
        }
      
//        titleL.text = name
        if name != nil
        {
            let companyAtt = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(15),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
            if company != nil
            {
              companyAtt.appendAttributedString(NSAttributedString(string:"  \(company!)" , attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }
          titleL.attributedText = companyAtt
        }

        if addre != nil
        {
          addressL.text = "地址:\(addre!)"
        }
        
//        locationL.text = location
        if let l = location
        {
            locationBt.setTitle("  \(l)", forState: .Normal)
        }
        contentL.text = content
        
        if content != nil
        {
             let size = content!.boundingRectWithSize(CGSizeMake(Profile.width()-30,1000), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:Profile.font(11)], context: nil)
              height = size.height
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ExhibitorMoreIndicateCell: UITableViewCell {
    
    
    let titleL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(11)
        titleL.text = "查看全部"
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleL)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[titleL]-15-|", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: self.contentView))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ContentLabelCell: UITableViewCell {
    var titleL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(11)
        titleL.numberOfLines = 0
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]-15-|", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-5-[titleL]-5-|", aView: titleL, bView: nil))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





class ExhibitorProductCell: UITableViewCell {
    
    var tapBlock:((Void)->(Void))?
    var imageArr:[ProductData]!
    let iconImage:UIImageView
    let scroll :UIScrollView
      override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        iconImage = UIImageView()
        scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)

       self.selectionStyle = .None
//        self.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0)
       self.contentView.addSubview(iconImage)
       iconImage.translatesAutoresizingMaskIntoConstraints = false
       iconImage.image = UIImage(named: "productCellHead")
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-4)-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        
        let separate = UIView()
        separate.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        separate.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separate)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconImage]-10-[separate(0.5)]", options: [], metrics: nil, views: ["separate":separate,"iconImage":iconImage]))
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separate))
        
        
        
        let moreBt = UIButton(type: UIButtonType.Custom)
        moreBt.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(moreBt)
        moreBt.setTitleColor(Profile.rgb(153, g: 153, b: 153), forState: .Normal)
        moreBt.titleLabel?.font = Profile.font(11)
        moreBt.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
        moreBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        moreBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90)
        moreBt.addTarget(self, action: "tapAction", forControlEvents: .TouchUpInside)
        moreBt.setTitle("查看全部", forState: .Normal)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(moreBt, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[moreBt]-15-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-9-[moreBt]", options: [], metrics: nil, views: ["moreBt":moreBt]))
        
        
       
        
        
        scroll.pagingEnabled = true
        self.contentView.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(scroll))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separate]-0-[scroll]-0-|", options: [], metrics: nil, views: ["separate":separate,"scroll":scroll]))
    }

    func fillImageArr(arr:[ProductData]){
    
        if imageArr != nil
        {
            return
        }
        imageArr = arr
        
        var frame = CGRectMake(0,0,Profile.width() ,147.5)
        
        var i = 0
        for (index ,imageData) in arr.enumerate(){
            
            let image = UIImageView(frame: frame)
            image.contentMode = .Center
            image.tag = index
            image.backgroundColor = Profile.rgb(243, g: 243, b: 243)
            scroll.addSubview(image)
            
            if imageData.imageUrl != nil
            {
                weak var wimage = image
                image.sd_setImageWithURL(NSURL(string: imageData.imageUrl!), placeholderImage: UIImage(named: "default"), completed: { (image:UIImage!,err: NSError!, type: SDImageCacheType, url:NSURL!) -> Void in
                    
                    if err == nil && image != nil
                    {
                        wimage?.contentMode = .ScaleToFill
                    }
                })
//                image.sd_setImageWithURL(NSURL(string: imageData.imageUrl!),  placeholderImage:UIImage(named: "default") )
            }
            frame = CGRectMake(frame.origin.x + frame.size.width, 0, CGRectGetWidth(frame), frame.height)
            
            
            let back = UIView()
            back.translatesAutoresizingMaskIntoConstraints = false
            back.backgroundColor = UIColor(white: 0, alpha: 0.6)
            image.addSubview(back)
            image.addConstraints(NSLayoutConstraint.layoutHorizontalFull(back))
            image.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[back(40)]-0-|", options: [], metrics: nil, views: ["back":back]))
            
            
            let troduceL = UILabel()
            troduceL.font = Profile.font(14)
            troduceL.textColor = UIColor.whiteColor()
            troduceL.translatesAutoresizingMaskIntoConstraints = false
            back.addSubview(troduceL)
            back.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[troduceL]-0-|", aView: troduceL, bView: nil))
            back.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[troduceL]-0-|", options: [], metrics: nil, views: ["troduceL":troduceL]))
            
         
            troduceL.text = imageData.name
            
            image.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "tapAction")
            image.addGestureRecognizer(tap)
            i = index
        }
        
        scroll.contentSize = CGSizeMake(Profile.width() * CGFloat(i+1), frame.height)
    }
    
    func tapAction()
    {
        if tapBlock != nil
        {
            tapBlock!()
        }
       
    }
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}

class ExhibitorMoreCell:UITableViewCell {
    
    let moreBt:UIButton
    var iconImage :UIImageView
    var tapBlock:((Void)->Void)?
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
    
    moreBt = UIButton(type: UIButtonType.Custom)
    moreBt.hidden = true
    moreBt.translatesAutoresizingMaskIntoConstraints = false
    moreBt.setTitleColor(Profile.rgb(153, g: 153, b: 153), forState: .Normal)
    moreBt.titleLabel?.font = Profile.font(11)
    moreBt.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
    moreBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
    moreBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90)
    
    moreBt.setTitle("查看更多", forState: .Normal)
    
   
     iconImage = UIImageView()
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     self.contentView.addSubview(iconImage)
     iconImage.translatesAutoresizingMaskIntoConstraints = false
//    self.contentView.backgroundColor = UIColor.redColor()
     self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
     self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-4)-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))

    
     let separateV = UIView()
    separateV.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(separateV)
//    self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(self.contentView))
    self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-0-[separateV]-0-|", aView: separateV, bView: nil))
     self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconImage]-10-[separateV(0.5)]", options: [], metrics: nil, views: ["iconImage":iconImage,"separateV":separateV]))
     separateV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
    
     self.selectionStyle = .None
    
      self.contentView.addSubview(moreBt)
      moreBt.addTarget(self, action: "tapAction", forControlEvents: .TouchUpInside)
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[moreBt]-15-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
//    self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(moreBt, toItem: self.contentView))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-9-[moreBt]", options: [], metrics: nil, views: ["moreBt":moreBt]))
    
    
      self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
      if #available(iOS 8.0, *) {
          self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
      } else {
          // Fallback on earlier versions
      }
    }
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    func tapAction(){
    
       if tapBlock != nil
       {
          tapBlock!()
        }
    }
    
}

class ExhibitorPerson: UITableViewCell,UIAlertViewDelegate {
    
    let nameL:UILabel
    let titleL:UILabel
    let addBt:UIButton
//    let phoneL:UILabel
    let phoneBt:UIButton
    var favouriteBlock:(Void ->Void)?
    var tapBlock:((Void)->Void)?
    var chatBlock:(Void ->Void)?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        nameL = UILabel()
        titleL = UILabel()
        phoneBt = UIButton(type: .Custom)
        addBt = UIButton(type: .Custom)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(13)
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1.0, constant: 15))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        

        
        nameL.textColor = Profile.rgb(102, g: 102, b: 102)
        nameL.font = Profile.font(14)
        self.contentView.addSubview(nameL)
        
        nameL.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "showUserInfoAction")
        nameL.addGestureRecognizer(tap)
        
        nameL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(nameL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[nameL]", options: [], metrics: nil, views: ["nameL":nameL,"titleL":titleL]))

//        addBt.backgroundColor = UIColor.greenColor()
        addBt.setTitle("收藏", forState: .Normal)
        addBt.titleLabel?.font = Profile.font(11)
        addBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        addBt.imageEdgeInsets = UIEdgeInsetsMake(-7, 8, 10, 0)
        addBt.titleEdgeInsets = UIEdgeInsetsMake(20, -15, 0, 0)
        addBt.setImage(UIImage(named: "addPhoneBt"), forState: .Normal)
        addBt.setImage(UIImage(named: "addPhoneBt_select"), forState: .Selected)
        addBt.translatesAutoresizingMaskIntoConstraints = false
        addBt.addTarget(self, action: "addContact", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(addBt)

        self.contentView.addConstraint(NSLayoutConstraint.layoutBottomEqual(addBt, toItem: nameL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[addBt(30)]-15-|", options: [], metrics: nil, views: ["addBt":addBt]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[addBt(25)]", options: [], metrics: nil, views: ["addBt":addBt]))
        
//        phoneBt.backgroundColor = UIColor.greenColor()
        phoneBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        phoneBt.titleLabel?.font = Profile.font(11)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false
        phoneBt.setTitle("发送消息", forState: .Normal)
        phoneBt.setImage(UIImage(named: "exhibitorChat"), forState: .Normal)
        phoneBt.imageEdgeInsets = UIEdgeInsetsMake(-7, 8, 11, 0)
        phoneBt.titleEdgeInsets = UIEdgeInsetsMake(20, -17, 0, 0)
        phoneBt.addTarget(self, action: "makeChat", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(phoneBt)

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[phoneBt(43)]-30-[addBt]", options: [], metrics: nil, views: ["phoneBt":phoneBt,"addBt":addBt]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[phoneBt(25)]", options: [], metrics: nil, views: ["phoneBt":phoneBt]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutBottomEqual(phoneBt, toItem: nameL))
        self.bottomSeparateView()
    }

    
    func bottomSeparateView(){
    
        let separateV = UIView()
        separateV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separateV)
        separateV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separateV(0.5)]-0-|", options: [], metrics: nil, views: ["separateV":separateV]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[separateV]-0-|", aView: separateV, bView: nil))
    }
    
    
    func showUserInfoAction(){
    
        if tapBlock != nil
        {
            tapBlock!()
        }
    }
    
    
    func makeChat()
    {
        if chatBlock != nil
        {
            chatBlock!()
        }
    }
    
    
    func addContact()
    {
       if favouriteBlock != nil
       {
         favouriteBlock!()
       }
    }
    func fillData(title:String? ,name:String?,chatID:String?,personAdd:Bool)
    {
        if UserData.shared.messID == chatID
        {
           addBt.hidden = true
           phoneBt.hidden = true
        }
        else
        {
           addBt.hidden = false
           phoneBt.hidden = false
        }
        titleL.text = title
        nameL.text =  name
        addBt.selected = personAdd
//       phoneBt.setTitle(phone, forState: UIControlState.Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExhibitorMapCell: UITableViewCell {
    
    let mapImageView:UIImageView
    var locationL:UILabel
    var block:(Void->Void)!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        mapImageView = UIImageView()
        locationL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let titleL = UILabel()
//        titleL.backgroundColor = UIColor.redColor()
        titleL.text = "展位图"
        titleL.font = Profile.font(14)
        titleL.textColor = Profile.rgb(102, g: 102, b: 102)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
//        titleL.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical)
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        
        
        let image = UIImageView()
        image.image = UIImage(named: "exhibitorLocation")
        image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(image)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-16-[image]", options: [], metrics: nil, views: ["image":image,"titleL":titleL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(image, toItem: titleL))
        
        
        locationL = UILabel()
        locationL.font = Profile.font(12)
        locationL.textColor = Profile.rgb(107, g: 206, b: 234)
        locationL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(locationL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image]-5-[locationL]", options: [], metrics: nil, views: ["image":image,"locationL":locationL]))
        
        
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.image = UIImage(named: "default")
        mapImageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        mapImageView.contentMode = .Center
        mapImageView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addSubview(mapImageView)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[mapImageView]-15-|", options: [], metrics: nil, views: ["mapImageView":mapImageView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[mapImageView]-10-|", options: [], metrics: nil, views: ["mapImageView":mapImageView,"titleL":titleL]))
    }

    func fillData(location:String?,locationUrl:String?)
    {
       locationL.text = location
        if locationUrl != nil
        {
            weak var wimage = mapImageView
            
            let tap = UITapGestureRecognizer(target: self, action: "tapMapAction")
            mapImageView.addGestureRecognizer(tap)
            mapImageView.userInteractionEnabled = true
            mapImageView.sd_setImageWithURL(NSURL(string: locationUrl!), placeholderImage: UIImage(named: "default"), completed: { (image:UIImage!,err: NSError!, type: SDImageCacheType, url:NSURL!) -> Void in
                
                if err == nil && image != nil
                {
                    wimage?.contentMode = .ScaleToFill
                }
            })
        }
       
    }
    
    func tapMapAction(){
    
        if block != nil
        {
          block()
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ExhibitorIntroduceCell: UITableViewCell {
    
    let scroll :UIScrollView
    var imageArr:[PicData]?
    var block:(Void ->Void)!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        scroll = UIScrollView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scroll.showsHorizontalScrollIndicator = true
//        scroll.pagingEnabled = true
        self.contentView.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-9-[scroll]-10-|", aView: scroll, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[scroll]-15-|", aView: scroll, bView: nil))
    }

    func setSubLayout(){
    
      
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.contentView.frame)
    }
    
    func fillImageArr(arr:[PicData]){
    
        if imageArr != nil
       {
         return
       }
       imageArr = arr
     
        let width = (Profile.width()-20)/3
       var frame = CGRectMake(0,0, width,width*0.6)
    
       var i = 0
       for (index ,imageData) in arr.enumerate(){
        
           let contentV = UIView(frame: frame)
            contentV.backgroundColor = UIColor.whiteColor()
           scroll.addSubview(contentV)
        
        
           let image = UIImageView(frame: CGRectMake(0, 0, frame.size.width - 5, frame.height))
           image.tag = index
           contentV.addSubview(image)
        
           if imageData.url != nil
           {
             image.sd_setImageWithURL(NSURL(string: imageData.url!),  placeholderImage:nil)
           }
        
           frame = CGRectMake(frame.origin.x + frame.size.width, 0, CGRectGetWidth(frame), frame.height)
            image.userInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: "imageTap")
                    image.addGestureRecognizer(tap)
           i = index
       }
    
     scroll.contentSize = CGSizeMake(frame.width * CGFloat(i+1), frame.height)
   }
    func imageTap(){
    
       if block != nil
       {
          block()
        }
    
    }
    
}
