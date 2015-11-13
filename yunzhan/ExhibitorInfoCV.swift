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
    var id:String?
    var productArr:[ProductData]!
    var personArr:[PersonData]!
    var elementData:ExhibitorData!
    var introductArr:[PicData]!
    
    
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
        table.translatesAutoresizingMaskIntoConstraints = false
        table.registerClass(ExhibitorInfoHeadCell.self, forCellReuseIdentifier: "ExhibitorInfoHeadCell")
        table.registerClass(ExhibitorMoreCell.self, forCellReuseIdentifier: "ExhibitorMoreCell")
        table.registerClass(ExhibitorProductCell.self, forCellReuseIdentifier: "ExhibitorProductCell")
        table.registerClass(ExhibitorPerson.self , forCellReuseIdentifier: "ExhibitorPerson")
        table.registerClass(ExhibitorMapCell.self , forCellReuseIdentifier: "ExhibitorMapCell")
        table.registerClass(ExhibitorIntroduceCell.self, forCellReuseIdentifier: "ExhibitorIntroduceCell")
        
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.fetchData()
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
            wself?.personArr = tuple.personArr
            wself?.productArr = tuple.producArr
            wself?.introductArr = tuple.introduce
            wself?.table.reloadData()
        }
       net.start()
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        if section == 0 || section == 1
        {
            if elementData == nil
            {
              return 0
            }
          return 1
        }
        
        if section == 3
        {
            if introductArr == nil
            {
                return 0
            }
           return 2
        }
        
        if personArr == nil
        {
            return 0
        }

        return personArr.count + 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0
        {
           return 170
        }
        else if indexPath.section == 1
        {
           return 180
        }
            
        else if indexPath.section == 3
        {
            if indexPath.row == 0
            {
              return 40
            }
            else
            {
              return 85
            }
        }
        else
        {
            if indexPath.row == 0
            {
              return 40
            }
            else if indexPath.row == (personArr.count + 1)
            {
              return 150
            }
            else
            {
              return 60
            }
        
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorInfoHeadCell") as!ExhibitorInfoHeadCell
            print(elementData)
            cell.fillData(elementData.iconUrl!, name: elementData.name, company: elementData.remark, addre: elementData.address, location: elementData.location, content: elementData.introduct)
            return cell
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
            else if indexPath.row == personArr.count+1
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorMapCell") as! ExhibitorMapCell
                
                cell.fillData(elementData.location!, locationUrl: elementData.addressMap!)
                return cell
            }
            else
            {
                let person = personArr[indexPath.row-1]
                let cell = tableView.dequeueReusableCellWithIdentifier("ExhibitorPerson") as! ExhibitorPerson
                cell.fillData(person.title  , name:person.name, phone: person.phone)
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
        tempNet.addContact(id!, personID: person.id!) { (result, status) -> (Void) in
            loadV.removeFromSuperview()
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
            }
        }
        tempNet.start()
    }
    
    
    func showProductInfoController(){
        
       let productVC = ProductListVC()
        productVC.products = productArr
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    
    func showExhibitorImage()
    {
    
        var picHtml = ""
        
        for p in introductArr
        {
            picHtml = picHtml+"<img src=\"\(p.url)\" style=\"max-width:100%; margin-bottom:8px\"/><br>"
        }
        
        let html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"3px\" color=\"black\">展会风采</font></p>\(picHtml)</body></html>"
        
        let web = CommonWebController(html: html)
        web.title = "展会形象"
        self.navigationController?.pushViewController(web, animated: true)

    }
    
    deinit{
        net = nil
    }

}

class ExhibitorInfoHeadCell: UITableViewCell {
    
    let iconImage:UIImageView
    
    let titleL:UILabel
    let companyNameL:UILabel
    let addressL:UILabel
    let contentL:UILabel
    let locationL:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        iconImage = UIImageView()
        
        titleL = UILabel()
        titleL.textColor = Profile.rgb(102, g: 102, b: 102)
        titleL.font = Profile.font(15)
        
        companyNameL = UILabel()
        companyNameL.textColor = Profile.rgb(153, g: 153, b: 153)
        companyNameL.font = Profile.font(11)
        
        
        addressL = UILabel()
        addressL.textColor = Profile.rgb(102, g: 102, b: 102)
        addressL.font = Profile.font(11)
        
        contentL = UILabel()
        contentL.numberOfLines = 0
        contentL.textColor = Profile.rgb(102, g: 102, b: 102)
        contentL.font = Profile.font(11)
        
        locationL = UILabel()
        locationL.textColor = Profile.rgb(107, g: 206, b: 234)
        locationL.font = Profile.font(11)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconImage.contentMode = .ScaleAspectFit
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iconImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage(30)]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[iconImage(30)]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        
       
        
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconImage]-25-[titleL]", options: [], metrics: nil, views: ["iconImage":iconImage,"titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        self.contentView.addSubview(companyNameL)
        companyNameL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-15-[companyNameL]", options: [], metrics: nil, views: ["companyNameL":companyNameL,"titleL":titleL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(companyNameL, toItem: titleL))
        
    
        self.contentView.addSubview(addressL)
        addressL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[addressL]", options: [], metrics: nil, views: ["titleL":titleL,"addressL":addressL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL , toItem: titleL))
        
        
        
        let locationView = UIImageView()
        locationView.image = UIImage(named: "exhibitorLocation")
        locationView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationView)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(locationView, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[addressL]-10-[locationView]", options: [], metrics: nil, views: ["locationView":locationView,"addressL":addressL]))
        
        
        locationL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(locationView, toItem: locationL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[locationView]-10-[locationL]", options: [], metrics: nil, views: ["locationView":locationView,"locationL":locationL]))

        
        let separateView = UIView()
        separateView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        separateView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separateView)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(separateView, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[locationView]-10-[separateView(0.5)]", options: [], metrics: nil, views: ["locationView":locationView,"separateView":separateView]))
         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[separateView]-0-|", options: [], metrics: nil, views: ["separateView":separateView]))
        
        
        
        contentL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(contentL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[contentL]-15-|", options: [], metrics: nil, views: ["contentL":contentL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView]-10-[contentL]-30-|", options: [], metrics: nil, views: ["contentL":contentL,"separateView":separateView]))
        
        
        let moreBt = UIButton(type: .Custom)
        moreBt.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(moreBt)
        moreBt.titleLabel?.font = Profile.font(11)
        moreBt.setTitle("查看更多", forState: .Normal)
        moreBt.setTitleColor(Profile.rgb(153, g: 153, b: 153), forState: .Normal)
        moreBt.titleLabel?.font = Profile.font(11)
        moreBt.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
        moreBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        moreBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90)

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[moreBt]-5-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[moreBt]-15-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
    }

    
    
    func fillData(iconUrl:String,name:String?,company:String?,addre:String?,location:String?,content:String?)
    {
       iconImage.sd_setImageWithURL(NSURL(string: iconUrl), placeholderImage: nil)
       titleL.text = name
        companyNameL.text = company
        addressL.text = addre
        locationL.text = location
        contentL.text = content
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


       self.contentView.addSubview(iconImage)
       iconImage.translatesAutoresizingMaskIntoConstraints = false
       iconImage.image = UIImage(named: "productCellHead")
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        
        
        let moreBt = UIButton(type: UIButtonType.Custom)
        moreBt.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(moreBt)
        moreBt.setTitleColor(Profile.rgb(153, g: 153, b: 153), forState: .Normal)
        moreBt.titleLabel?.font = Profile.font(11)
        moreBt.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
        moreBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        moreBt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90)
        moreBt.addTarget(self, action: "tapAction", forControlEvents: .TouchUpInside)
        moreBt.setTitle("查看更多", forState: .Normal)
      
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[moreBt]-15-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[moreBt]", options: [], metrics: nil, views: ["moreBt":moreBt]))
        
        
        let separate = UIView()
        separate.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separate)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[moreBt]-10-[separate(0.5)]", options: [], metrics: nil, views: ["separate":separate,"moreBt":moreBt]))
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separate))
        
        
        scroll.pagingEnabled = true
        self.contentView.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(scroll))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separate]-10-[scroll]-1-|", options: [], metrics: nil, views: ["separate":separate,"scroll":scroll]))
    }

    func fillImageArr(arr:[ProductData]){
    
        if imageArr != nil
        {
            return
        }
        imageArr = arr
        
        var frame = CGRectMake(0,0,Profile.width() ,138)
        
        var i = 0
        for (index ,imageData) in arr.enumerate(){
            
            let image = UIImageView(frame: frame)
//            image.backgroundColor = UIColor.redColor()
            image.tag = index
            scroll.addSubview(image)
            print(imageData.imageUrl!)
            image.sd_setImageWithURL(NSURL(string: imageData.imageUrl!),  placeholderImage:nil)
            frame = CGRectMake(frame.origin.x + frame.size.width, 0, CGRectGetWidth(frame), frame.height)
//            image.userInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: "imageTap:")
//            image.addGestureRecognizer(tap)
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
    
     self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
     self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))

    
    
      self.contentView.addSubview(moreBt)
      moreBt.addTarget(self, action: "tapAction", forControlEvents: .TouchUpInside)
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[moreBt]-15-|", options: [], metrics: nil, views: ["moreBt":moreBt]))
      self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[moreBt]", options: [], metrics: nil, views: ["moreBt":moreBt]))
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
//    let phoneL:UILabel
    var phoneBt:UIButton
    var tapBlock:((Void)->Void)?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        nameL = UILabel()
        titleL = UILabel()
        phoneBt = UIButton(type: .Custom)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(12)
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1.0, constant: 15))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        

        
        nameL.textColor = Profile.rgb(102, g: 102, b: 102)
        nameL.font = Profile.font(12)
        self.contentView.addSubview(nameL)
        nameL.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[nameL]", options: [], metrics: nil, views: ["nameL":nameL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(nameL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[nameL]", options: [], metrics: nil, views: ["nameL":nameL,"titleL":titleL]))

    
        
       phoneBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        phoneBt.titleLabel?.font = Profile.font(14)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false
        phoneBt.setImage(UIImage(named: "exhibitorPhone"), forState: .Normal)
        phoneBt.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        phoneBt.addTarget(self, action: "makeACall", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(phoneBt)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[nameL]-15-[phoneBt]", options: [], metrics: nil, views: ["phoneBt":phoneBt,"nameL":nameL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(phoneBt, toItem: nameL))
        
        
        let addBt = UIButton(type: .Custom)
        addBt.setImage(UIImage(named: "addPhoneBt"), forState: .Normal)
        addBt.translatesAutoresizingMaskIntoConstraints = false
        addBt.addTarget(self, action: "addContact", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(addBt)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(addBt , toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[addBt]-15-|", options: [], metrics: nil, views: ["addBt":addBt]))
    }

    func makeACall()
    {
       let alert = UIAlertView(title: "提示", message: "是否拨打电话", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
    
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.cancelButtonIndex == buttonIndex
        {
           return
        }
        if let nu = phoneBt.currentTitle
        {
            let url = NSURL(string: "tel://\(nu)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    
    func addContact()
    {
       if tapBlock != nil
       {
         tapBlock!()
       }
    }
    func fillData(title:String? ,name:String?,phone:String?)
    {
       titleL.text = title
        nameL.text =  name
       phoneBt.setTitle(phone, forState: UIControlState.Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ExhibitorMapCell: UITableViewCell {
    let mapImageView:UIImageView
    var locationL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mapImageView = UIImageView()
        locationL = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let titleL = UILabel()
        titleL.text = "展位图"
        titleL.font = Profile.font(14)
        titleL.textColor = Profile.rgb(102, g: 102, b: 102)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        let image = UIImageView()
        image.image = UIImage(named: "exhibitorLocation")
        image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(image)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-25-[image]", options: [], metrics: nil, views: ["image":image,"titleL":titleL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(image, toItem: titleL))
        
        
        locationL = UILabel()
        locationL.font = Profile.font(12)
        locationL.textColor = Profile.rgb(107, g: 206, b: 234)
        locationL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(locationL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image]-5-[locationL]", options: [], metrics: nil, views: ["image":image,"locationL":locationL]))
        
        
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mapImageView)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[mapImageView]-15-|", options: [], metrics: nil, views: ["mapImageView":mapImageView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[mapImageView]-10-|", options: [], metrics: nil, views: ["mapImageView":mapImageView,"titleL":titleL]))
    }

    func fillData(location:String,locationUrl:String)
    {
       locationL.text = location
       mapImageView.sd_setImageWithURL(NSURL(string: locationUrl), placeholderImage: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ExhibitorIntroduceCell: UITableViewCell {
    
    let scroll :UIScrollView
    var imageArr:[PicData]?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        scroll = UIScrollView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scroll.showsHorizontalScrollIndicator = true
//        scroll.pagingEnabled = true
        self.contentView.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[scroll]-10-|", aView: scroll, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[scroll]-15-|", aView: scroll, bView: nil))
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
    
       var frame = CGRectMake(0,0,110 ,64)
    
       var i = 0
       for (index ,imageData) in arr.enumerate(){
        
           let contentV = UIView(frame: frame)
            contentV.backgroundColor = UIColor.whiteColor()
           scroll.addSubview(contentV)
        
        
           let image = UIImageView(frame: CGRectMake(0, 0, frame.size.width - 5, frame.height))
           image.tag = index
           contentV.addSubview(image)
        
           image.sd_setImageWithURL(NSURL(string: imageData.url),  placeholderImage:nil)
           frame = CGRectMake(frame.origin.x + frame.size.width, 0, CGRectGetWidth(frame), frame.height)
        //            image.userInteractionEnabled = true
        //            let tap = UITapGestureRecognizer(target: self, action: "imageTap:")
        //            image.addGestureRecognizer(tap)
           i = index
       }
    
     scroll.contentSize = CGSizeMake(frame.width * CGFloat(i+1), frame.height)
   }

}
