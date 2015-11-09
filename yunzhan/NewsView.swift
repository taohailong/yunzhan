//
//  NewsView.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/5.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var net:NetWorkData!
    var dataArr:[NewsData]!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        
         super.viewDidLoad()
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-4_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        self.title = "新闻"
        table.registerClass(NewCell.self , forCellReuseIdentifier: "NewCell")
        self.fetchData()
    }
    
    func fetchData(){
    
        weak var wself = self
        net = NetWorkData()
        net.getNewsList { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
                return
            }
            
            guard let arr = result as? [NewsData] else { return }
            
            wself?.dataArr = arr
            wself?.table.reloadData()
        }
        net.start()

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArr == nil
        {
            return 0
        }
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewCell") as! NewCell
        let new = dataArr[indexPath.row]
        cell.fillData(new)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let new = dataArr[indexPath.row]
        let web = CommonWebController(url: new.link)
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
    
}


class NewCell: UITableViewCell {
    
    let contentImage:UIImageView
    let titleL:UILabel
    let contentL:UILabel
    let timeL:UILabel
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        contentImage = UIImageView()
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(contentImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[contentImage]", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[contentImage]-10-|", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: contentImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentImage, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        
        
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentImage]-20-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"contentImage":contentImage]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: contentImage))
        //        titleL.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        titleL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
        self.contentView.addSubview(contentL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        //        self.contentView.addConstraint(NSLayoutConstraint(item: contentL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL,"titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL]))
        

        
        
        
        
        timeL.textColor = Profile.rgb(191, g: 191, b: 191)
        timeL.font = Profile.font(11)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-(>=1)-[timeL]-15-|", options: [], metrics: nil, views: ["titleL":titleL,"timeL":timeL]))

    }

    func fillData(newsData:NewsData)
    {
        contentImage.sd_setImageWithURL(NSURL(string: newsData.imageUrl!), placeholderImage: nil)
        timeL.text = newsData.time
        titleL.text = newsData.title
        contentL.text = newsData.content
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class NewsCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var content: UILabel!
    
    func fillData(newsData:NewsData)
    {
        newsImage.sd_setImageWithURL(NSURL(string: newsData.imageUrl!), placeholderImage: nil)
        time.text = newsData.time
        title.text = newsData.title
        content.text = newsData.content
    }
}
