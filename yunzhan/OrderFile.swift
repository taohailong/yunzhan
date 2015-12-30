//
//  OrderFile.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/30.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class BookVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var productData:ProductData!
    var table:UITableView!
    var textV:THTextView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "确认订单"
        
        self.view.backgroundColor = UIColor.whiteColor()
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .None
        table.backgroundColor = UIColor.whiteColor()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableHeaderView = self.creatTextView()
        table.registerClass( MoreTableHeadView.self , forHeaderFooterViewReuseIdentifier: "MoreTableHeadView")
        table.registerClass(BookOneLabelCell.self, forCellReuseIdentifier: "BookOneLabelCell")
        table.registerClass(BookOneLabelSpecialCell.self , forCellReuseIdentifier: "BookOneLabelSpecialCell")
        table.registerClass(CommonTwoLabelCell.self, forCellReuseIdentifier: "CommonTwoLabelCell")
        table.registerClass(BookPicTableCell.self , forCellReuseIdentifier: "BookPicTableCell")
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-0-[table]-49-|", aView: table, bView: nil))
        
        
        let separate = UIView()
        separate.translatesAutoresizingMaskIntoConstraints = false
        separate.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.view.addSubview(separate)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separate))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[table]-1-[separate(0.5)]", options: [], metrics: nil, views: ["separate":separate,"table":table]))
        
        
        
        let bookBt = UIButton(type: .Custom)
        bookBt.addTarget(self, action: "bookAction", forControlEvents: .TouchUpInside)
        bookBt.setTitle("确认", forState: .Normal)
        bookBt.titleLabel?.font = Profile.font(15)
        bookBt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        bookBt.setBackgroundImage(UIImage(named: "login_hight"), forState: .Normal)
        bookBt.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bookBt)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[bookBt]-15-|", options: [], metrics: nil, views: ["bookBt":bookBt]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separate]-8-[bookBt]-8-|", options: [], metrics: nil, views: ["separate":separate,"bookBt":bookBt]))
    }
    
    func creatTextView()->UIView
    {
       let backView = UIView(frame: CGRectMake(0,0,Profile.width(),125))
        backView.backgroundColor = UIColor.whiteColor()
        textV = THTextView(frame: CGRectMake(15, 10, Profile.width()-30, 105), textContainer: nil)
        textV.layer.cornerRadius = 4
        textV.layer.borderColor = Profile.rgb(243, g: 243, b: 243).CGColor
        textV.layer.borderWidth = 1
        textV.placeHolder = "请输入您要预定的数量，销售人员会与您联系"
        backView.addSubview(textV)
        
       return backView
    }
    
    func bookAction()
    {
        weak var wself = self
       let net = NetWorkData()
        let load = THActivityView(activityViewWithSuperView: self.view)
        net.orderProduct(productData.exhibitorID!, productID: productData.productId!, remark: textV.text) { (result, status) -> (Void) in
            load.removeFromSuperview()
            
            if let str = result as? String
            {
                let loadStr = THActivityView(string: str)
                loadStr.show()
            }

            if status == NetStatus.NetWorkStatusError
            {
                return
            }
           
            wself?.navigationController?.popViewControllerAnimated(true)
        }
        net.start()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return   4
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MoreTableHeadView") as! MoreTableHeadView
        head.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
//        head.iconImage.image = UIImage(named: "orderTableHeadIcon")
         head.iconImage.image = UIImage(named: "exhibitorIntroduct")
        
        return head
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelSpecialCell") as! BookOneLabelSpecialCell
            cell.titleL.font = Profile.font(12)
            cell.titleL.textColor = Profile.rgb(51, g: 51, b: 51)
            if productData.createrName != nil
            {
                cell.titleL.text = "销售厂商：\(productData.createrName!)"
            }
            return cell
        }
        
        if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelCell") as! BookOneLabelCell
            cell.titleL.font = Profile.font(12)
            cell.titleL.textColor = Profile.rgb(51, g: 51, b: 51)
            if productData.name != nil
            {
              cell.titleL.text = "产品名称：\(productData.name!)"
            }
            
            return cell
        }

        if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonTwoLabelCell") as! CommonTwoLabelCell
            cell.twoL.text = productData.introduce
            cell.oneL.text = "产品介绍："
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookPicTableCell") as! BookPicTableCell
            
            let url = NSURL(string: productData.imageUrl!)
            if url != nil
            {
              cell.pImage.sd_setImageWithURL(url!)
            }
            
            cell.title.text = "产品图片"
            return cell

        }
    }
    
    
}



class BookOneLabelSpecialCell: CommonOneLabelCell {
    override func setSubViewLayout() {
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]-15-|", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[titleL]-5-|", aView: titleL, bView: nil))
    }
}


class BookOneLabelCell: CommonOneLabelCell {
    override func setSubViewLayout() {
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]-15-|", aView: titleL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-5-[titleL]-5-|", aView: titleL, bView: nil))
    }
}

class CommonTwoLabelCell: UITableViewCell {
    
    let oneL:UILabel
    let twoL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        oneL = UILabel()
        oneL.translatesAutoresizingMaskIntoConstraints = false
        
        twoL = UILabel()
        twoL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(oneL)
        self.contentView.addSubview(twoL)
        self.setSubViewLayout()
    }

    func setSubViewLayout(){
        
        twoL.font = Profile.font(12)
        twoL.textColor = Profile.rgb(51, g: 51, b: 51)
        oneL.numberOfLines = 0
        oneL.font = twoL.font
        oneL.textColor = twoL.textColor
        
        oneL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[oneL]", options: [], metrics: nil, views: ["oneL":oneL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[oneL]", options: [], metrics: nil, views: ["oneL":oneL]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[oneL]-1-[twoL]-15-|", options: [], metrics: nil, views: ["oneL":oneL,"twoL":twoL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[twoL]-5-|", options: [], metrics: nil, views: ["twoL":twoL]))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BookPicTableCell:UITableViewCell {
    let title:UILabel
    let pImage:UIImageView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        title = UILabel()
        title.font = Profile.font(12)
        title.textColor = Profile.rgb(51, g: 51, b: 51)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        pImage = UIImageView()
        pImage.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(pImage)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[title]", aView: title, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-5-[title]", aView: title, bView: nil))
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[pImage(200)]", options: [], metrics: nil, views: ["pImage":pImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-10-[pImage(125)]-0-|", options: [], metrics: nil, views: ["pImage":pImage,"title":title]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MyOrderListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var net:NetWorkData!
    var table:UITableView!
    var dataArr:[ProductData]!
    override func viewDidLoad() {
       super.viewDidLoad()
        
        self.title = "我的订单"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.registerClass(OrderListProductCell.self, forCellReuseIdentifier: "OrderListProductCell")
        table.registerClass(BookOneLabelCell.self, forCellReuseIdentifier: "BookOneLabelCell")
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.fetchNetData()
    }
    
    
    func fetchNetData(){
    
      weak var wself = self
      let load = THActivityView(activityViewWithSuperView: self.view)
      net = NetWorkData()
      net.getMyOrderList { (result, status) -> (Void) in
        load.removeFromSuperview()
        
        
        if status == NetStatus.NetWorkStatusError
        {
            if let str = result as? String
            {
                let loadStr = THActivityView(string: str)
                loadStr.show()
            }
            return
        }
        
        if let arr = result as? [ProductData]
        {
           wself?.dataArr = arr
            wself?.table.reloadData()
        }
     }
     net.start()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if dataArr == nil
        {
          return 0
        }
        
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pro = dataArr[indexPath.section]
        if indexPath.row == 1
        {
          let cell = tableView.dequeueReusableCellWithIdentifier("OrderListProductCell") as! OrderListProductCell
          cell.fillData(pro.imageUrl, title: pro.name, introduce: pro.introduce)
          return cell
        }
        else if indexPath.row == 0
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelCell") as! BookOneLabelCell
            cell.titleL.font = Profile.font(13)
            cell.titleL.textColor = Profile.rgb(51, g: 51, b: 51)
             cell.titleL.text = pro.createrName
            return cell
        }
        else
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelCell") as! BookOneLabelCell
            cell.titleL.font = Profile.font(11)
            cell.titleL.textColor = Profile.rgb(153, g: 153, b: 153)
            cell.titleL.text = pro.remark
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

class OrderListProductCell: ProductListCell {
    
   override func setSubViewLayout(){
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[imageV(125)]", options: [], metrics: nil, views: ["imageV":imageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[imageV(80)]-10-|", options: [], metrics: nil, views: ["imageV":imageV]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[imageV]-15-[titleL]", aView: imageV, bView: titleL))
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: imageV))
        //        titleL.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, forAxis: .Vertical)
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-5-[contentL]-40-|", aView: titleL, bView: contentL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[contentL]-10-|", aView: contentL, bView: nil))
    }

    override func creatBookBt() {
        
    }
}

