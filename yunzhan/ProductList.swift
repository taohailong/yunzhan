//
//  ProductList.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/11.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class ProductListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var products: [ProductData]!
    var table:UITableView!
    override func viewDidLoad() {
        
        self.title = "产品介绍"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.tableFooterView = UIView()
        table.registerClass(ProductListCell.self , forCellReuseIdentifier: "ProductListCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products == nil
        {
          return 0
        }
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductListCell") as! ProductListCell
        let data = products[indexPath.row]
        weak var wself = self
        cell.bookBlock = { wself?.showBookVC(data) }
        cell.fillData(data.imageUrl, title: data.name, introduce: data.introduce)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let data = products[indexPath.row]
        let web = ProductInfoVC(product: data)
        web.title = "产品详情"
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    
    func showBookVC(let data:ProductData)
    {
        if UserData.shared.token == nil
        {
            self.showLoginVC()
            return
        }

       let bookVC = BookVC()
        bookVC.productData = data
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    func showLoginVC(){
        let logVC = LogViewController()
        logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
    }

}

class ProductListCell: UITableViewCell {
    let imageV:UIImageView
    let titleL:UILabel
    let contentL:UILabel
    var bookBlock:(Void -> Void)!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
//        imageV.contentMode = .Center
        imageV.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        imageV.image = UIImage(named: "default")
//        imageV.backgroundColor = UIColor.redColor()
        titleL = UILabel()
        contentL = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageV)
        
        
        titleL.translatesAutoresizingMaskIntoConstraints = false
        titleL.font = Profile.font(14)
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        
        self.contentView.addSubview(titleL)
        //        contentL.backgroundColor = UIColor.redColor()
        contentL.numberOfLines = 0
        contentL.textAlignment = .Left
        contentL.translatesAutoresizingMaskIntoConstraints = false
        contentL.font = Profile.font(11)
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
//        contentL.backgroundColor = UIColor.redColor()
        self.contentView.addSubview(contentL)
//        contentL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
//        contentL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        
        self.setSubViewLayout()
        self.creatBookBt()

    }
   
    
    func setSubViewLayout(){
    
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[imageV(125)]", options: [], metrics: nil, views: ["imageV":imageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[imageV]-10-|", options: [], metrics: nil, views: ["imageV":imageV]))
    
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[imageV]-15-[titleL]", aView: imageV, bView: titleL))
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: imageV))
        //        titleL.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, forAxis: .Vertical)
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL(<=30)]", options: [], metrics: nil, views: ["titleL":titleL,"contentL":contentL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[contentL]-10-|", aView: contentL, bView: nil))
    }
    
    func creatBookBt()
    {
        let bt = UIButton(type: .Custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
//        bt.setImage(UIImage(named: "bookBt"), forState: .Normal)
        bt.titleLabel?.font = Profile.font(12)
        bt.setBackgroundImage(Profile.NavBarColorGenuine.convertToImage(), forState: .Normal)
        bt.setBackgroundImage(Profile.rgb(219, g: 21, b: 58).convertToImage(), forState: .Highlighted)
        bt.setTitle("预约购买", forState: .Normal)
        bt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.contentView.addSubview(bt)
        bt.addTarget(self, action: "ProductListBookAction", forControlEvents: .TouchUpInside)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[bt]-15-|", options: [], metrics: nil, views: ["bt":bt]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bt]-10-|", options: [], metrics: nil, views: ["bt":bt]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[bt(65)]-15-|", options: [], metrics: nil, views: ["bt":bt]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bt(20)]-10-|", options: [], metrics: nil, views: ["bt":bt]))
    }
    
    func ProductListBookAction()
    {
       if bookBlock != nil
       {
         bookBlock()
        }
    
    }
    
    
    func fillData(imageUrl:String?,title:String?,introduce:String?){
       
        if imageUrl != nil
        {
            weak var wimage = imageV
            imageV.sd_setImageWithURL(NSURL(string: imageUrl!), placeholderImage:  UIImage(named: "default"), completed: { (image:UIImage!, err:NSError!, type:SDImageCacheType, url:NSURL!) -> Void in
                if err == nil
                {
                    wimage?.contentMode = .ScaleAspectFit
                    wimage?.backgroundColor = UIColor.whiteColor()
                }
            })
        }
        titleL.text = title
        contentL.text = introduce

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
