//
//  OrderFile.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/30.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class BookVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextViewDelegate{
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
        table.allowsSelection = false
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
        separate.backgroundColor = Profile.rgb(210, g: 210, b: 210)
        self.view.addSubview(separate)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(separate))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[table]-1-[separate(0.5)]", options: [], metrics: nil, views: ["separate":separate,"table":table]))
        
        
        
        let bookBt = UIButton(type: .Custom)
        bookBt.addTarget(self, action: "bookAction", forControlEvents: .TouchUpInside)
        bookBt.setTitle("确认", forState: .Normal)
        bookBt.layer.cornerRadius = 4
        bookBt.layer.masksToBounds = true
        bookBt.titleLabel?.font = Profile.font(16)
        bookBt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        bookBt.setBackgroundImage(Profile.NavBarColorGenuine.convertToImage(), forState: .Normal)
        bookBt.setBackgroundImage(Profile.GlobalButtonHightColor.convertToImage(), forState: .Highlighted)
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
        textV.textContainerInset = UIEdgeInsetsMake(8, 5, 5, 5)
        textV.layer.borderColor = Profile.rgb(210, g: 210, b: 210).CGColor
        textV.layer.borderWidth = 1
        textV.returnKeyType = .Done
        textV.delegate = self
        textV.placeHolder = "请输入您要预定的产品数量及其他说明"
        
        backView.addSubview(textV)
        
       return backView
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
          textView.resignFirstResponder()
        }
        return true
    }
    
    
    func bookAction()
    {
        if textV.text.isEmpty == true
        {
           let loadView = THActivityView(string: "请输入订单信息")
            loadView.show()
           return
        }
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
        
        if productData.picArr == nil
        {
           return 3
        }
        
      return   4 + (productData.picArr?.count)!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0
        {
          return 25
        }
        else if indexPath.row == 1
        {
          return 25
        }
        else if indexPath.row == 2
        {
            let heigt = productData.figureoutStringHeight(productData.introduce, font: Profile.font(13), size: CGSizeMake(Profile.width() - 70, 1000))
            if heigt > 26
            {
               return 38
            }
        
            
          return heigt + 8
        }
        else if indexPath.row == 3
        {
          return 25
        }
        else
        {
           return 155
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("MoreTableHeadView") as! MoreTableHeadView
        head.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        head.iconImage.image = UIImage(named: "orderTableHeadIcon")
        return head
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelSpecialCell") as! BookOneLabelSpecialCell
            cell.titleL.font = Profile.font(13)
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
            cell.titleL.font = Profile.font(13)
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
        else if indexPath.row == 3
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelCell") as! BookOneLabelCell
            cell.titleL.font = Profile.font(13)
            cell.titleL.textColor = Profile.rgb(51, g: 51, b: 51)
            cell.titleL.text = "产品图片:"
            return cell
        }
            
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("BookPicTableCell") as! BookPicTableCell
            let pic = productData.picArr![indexPath.row - 4].url
            
            let url = NSURL(string: pic!)
            if url != nil
            {
              cell.pImage.contentMode = .ScaleAspectFit
              cell.pImage.sd_setImageWithURL(url!, placeholderImage: UIImage(named: "default"))
            }
            return cell
        }
    }
    
     func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textV.resignFirstResponder()
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
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-4-[titleL]-4-|", aView: titleL, bView: nil))
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
        twoL.numberOfLines = 0
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(oneL)
        self.contentView.addSubview(twoL)
        self.setSubViewLayout()
    }

    func setSubViewLayout(){
        
        twoL.font = Profile.font(13)
        twoL.textColor = Profile.rgb(51, g: 51, b: 51)
        
        oneL.numberOfLines = 0
        oneL.font = twoL.font
        oneL.textColor = twoL.textColor
//        twoL.backgroundColor = UIColor.redColor()
        twoL.textAlignment = .Left
//        oneL.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
//        twoL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        oneL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[oneL]", options: [], metrics: nil, views: ["oneL":oneL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[oneL]", options: [], metrics: nil, views: ["oneL":oneL]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[oneL]-1-[twoL]-15-|", options: [], metrics: nil, views: ["oneL":oneL,"twoL":twoL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[twoL(<=32)]", options: [], metrics: nil, views: ["twoL":twoL]))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class BookPicTableCell:UITableViewCell {
    let separateView:UIView
    let pImage:UIImageView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        separateView = UIView()
        separateView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        separateView.translatesAutoresizingMaskIntoConstraints = false
        
        pImage = UIImageView()
        pImage.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(separateView)
        self.contentView.addSubview(pImage)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[separateView]-15-|", aView: separateView, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView(0.5)]-0-|", options: [], metrics: nil, views: ["separateView":separateView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[pImage(200)]", options: [], metrics: nil, views: ["pImage":pImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[pImage]-8-|", options: [], metrics: nil, views: ["pImage":pImage]))
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
        table = UITableView(frame: CGRectZero, style: .Grouped)
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.registerClass(BookOneLabelCell.self , forCellReuseIdentifier: "BookOneLabelCell")
        table.registerClass(OrderListProductCell.self, forCellReuseIdentifier: "OrderListProductCell")
        table.registerClass(OrderListFirstCell.self, forCellReuseIdentifier: "OrderListFirstCell")
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
            if arr.count == 0
            {
              _ = THActivityView(emptyDataWarnViewWithString: "您还没有订单", withImage: "noOrderListData", withSuperView: wself?.view)
                return
            }
            
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
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 30
        }
        else if indexPath.row == 1
        {
            return 100
        }
        else
        {
            let data = dataArr[indexPath.section]
            let height = data.figureoutStringHeight(data.remark, font: Profile.font(11), size: CGSizeMake(Profile.width()-30, 1000))
           return height + 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pro = dataArr[indexPath.section]
        if indexPath.row == 1
        {
          let cell = tableView.dequeueReusableCellWithIdentifier("OrderListProductCell") as! OrderListProductCell
          cell.fillData(pro.imageUrl, title: pro.name, introduce: pro.introduce)
            cell.selectionStyle = .None
          return cell
        }
        else if indexPath.row == 0
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("OrderListFirstCell") as! OrderListFirstCell
            cell.selectionStyle = .None
            cell.oneL.font = Profile.font(14)
            cell.oneL.textColor = Profile.rgb(51, g: 51, b: 51)
             cell.oneL.text = pro.createrName
            cell.twoL.font = Profile.font(11)
            cell.twoL.textColor = Profile.rgb(153, g: 153, b: 153)
            cell.twoL.text = pro.time
            return cell
        }
        else
        {
           let cell = tableView.dequeueReusableCellWithIdentifier("BookOneLabelCell") as! BookOneLabelCell
            cell.titleL.font = Profile.font(11)
            cell.selectionStyle = .None
            cell.titleL.textColor = Profile.rgb(153, g: 153, b: 153)
            cell.titleL.text = pro.remark
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


class OrderListFirstCell:CommonTwoLabelCell {
    override func setSubViewLayout() {
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[oneL]", aView: oneL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(oneL, toItem: self.contentView))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[twoL]-15-|", options: [], metrics: nil, views: ["oneL":oneL,"twoL":twoL]))
         self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(twoL, toItem: self.contentView))
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
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL(<=30)]", options: [], metrics: nil, views: ["titleL":titleL,"contentL":contentL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[contentL]-10-|", aView: contentL, bView: nil))
    }

    override func creatBookBt() {
        
    }
}

