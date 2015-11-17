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
}

class ProductListCell: UITableViewCell {
    let imageV:UIImageView
    let titleL:UILabel
    let contentL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        titleL = UILabel()
        contentL = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(imageV)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[imageV(125)]", options: [], metrics: nil, views: ["imageV":imageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[imageV]-15-|", options: [], metrics: nil, views: ["imageV":imageV]))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[imageV]", aView: imageV, bView: nil))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[imageV]-10-|", aView: imageV, bView: nil))

//        self.contentView.addConstraint(NSLayoutConstraint(item: imageV, attribute: .Width, relatedBy: .Equal, toItem: imageV, attribute: .Height, multiplier: 1.0, constant: 0))
        
        titleL.translatesAutoresizingMaskIntoConstraints = false
        titleL.font = Profile.font(15)
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[imageV]-15-[titleL]", aView: imageV, bView: titleL))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-15-[titleL]", aView: titleL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: imageV))
//        titleL.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, forAxis: .Vertical)
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
//        contentL.backgroundColor = UIColor.redColor()
        contentL.numberOfLines = 0
        contentL.textAlignment = .Justified
        contentL.translatesAutoresizingMaskIntoConstraints = false
        contentL.font = Profile.font(11)
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        self.contentView.addSubview(contentL)
//        contentL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Vertical)
//        contentL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-7-[contentL]-15-|", aView: titleL, bView: contentL))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[contentL]-10-|", aView: contentL, bView: nil))

    }
   
    func fillData(imageUrl:String?,title:String?,introduce:String?){
       
        imageV.sd_setImageWithURL(NSURL(string: imageUrl!), placeholderImage: nil)
        titleL.text = title
        contentL.text = introduce
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
