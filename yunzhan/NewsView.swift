//
//  NewsView.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/5.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
enum NewsVCSelectType:Int {
   case News = 1
   case TimeLine = 0
}

class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var selectType = NewsVCSelectType.TimeLine
    var net:NetWorkData!
    var dataArr:[NewsData]!
    var segmentV:TSegmentedControl!
    @IBOutlet weak var table: UITableView!
    var newList:NewsListVC!
    var timeLineV:TimeLineVC!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
        
        
        if segmentV.selectedIndex != selectType.rawValue
        {
            segmentV.selectedIndex = selectType.rawValue
            self.segmentChange()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
    

    override func viewDidLoad() {
        
         super.viewDidLoad()
         self.title = "发现"
        //       返回按钮去掉文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
        
        
        segmentV = TSegmentedControl(sectionTitles: ["展圈","资讯"])
        segmentV.addTarget(self, action: "segmentChange", forControlEvents: .ValueChanged)
        segmentV.frame = CGRectMake(0, 64, Profile.width(), 40)
        segmentV.selectionIndicatorColor = Profile.NavBarColorGenuine
        segmentV.textColor = Profile.rgb(102, g: 102, b: 102)
        segmentV.selectionIndicatorHeight = 1
        segmentV.font = Profile.font(15.0)
        segmentV.selectionIndicatorColor = Profile.NavBarColorGenuine
        segmentV.selectTitleColor = Profile.NavBarColorGenuine
        segmentV.selectionIndicatorMode = HMSelectionIndicatorFillsTop
//        segmentV.backgroundColor = UIColor.blueColor()
        self.view.addSubview(segmentV)
        
        
        
        timeLineV = TimeLineVC()
        timeLineV.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timeLineV.view)
        var  tempView = timeLineV.view
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-104-[tempView]-49-|", options: [], metrics: nil, views: ["tempView":tempView]))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(timeLineV.view))
        self.addChildViewController(timeLineV)

        
        
         newList = NewsListVC()
         newList.view.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(newList.view)
         tempView = newList.view
         self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-104-[tempView]-49-|", options: [], metrics: nil, views: ["tempView":tempView]))
         self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(newList.view))
         self.addChildViewController(newList)
        
         tempView.hidden = true
        self.creatRightBar()
    }
    
    func creatRightBar(){
    
        let rightBar = UIBarButtonItem(image: UIImage(named: "timeLineUpLoad"), style: .Plain, target: self, action: "showSendVC")
        self.navigationItem.rightBarButtonItem = rightBar

    }
    
    func showSendVC(){
        
        let user = UserData.shared
        if user.token == nil
        {
            self.newsShowLoginVC()
            return
        }
        
        let writeVC = TimeLineCommitVC()
        writeVC.hidesBottomBarWhenPushed = true
        weak var wself = self
        writeVC.commitFinsh = {
          wself?.timeLineV.fetchTimeLineList()
        }
        
        let nav = UINavigationController(rootViewController: writeVC)
        
        self.presentViewController(nav, animated: true) { () -> Void in
            
        }
    }


    func segmentChange()
    {
        if segmentV.selectedIndex == 0
        {
            newList.view.hidden = true
            timeLineV.view.hidden = false
            self.creatRightBar()
            selectType = .TimeLine
        }
        else
        {
            newList.view.hidden = false
            timeLineV.view.hidden = true
            self.navigationItem.rightBarButtonItem = nil
            selectType = .News
        }
    }
    
    func fetchData(){
    
         let loadView = THActivityView(activityViewWithSuperView: self.view)
        weak var wself = self
        net = NetWorkData()
        net.getNewsList { (result, status) -> (Void) in
            
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
            
            guard let arr = result as? [NewsData] else { return }
            
            wself?.dataArr = arr
//            wself?.table.reloadData()
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
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let new = dataArr[indexPath.row]
        let web = CommonWebController(url: new.link)
        web.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    func newsShowLoginVC(){
        
        let logVC = LogViewController()
        logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
        
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
        contentImage.image = UIImage(named: "default")
        contentImage.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        
        
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
        titleL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        titleL.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
        
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
        self.contentView.addSubview(contentL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
        //        self.contentView.addConstraint(NSLayoutConstraint(item: contentL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
        
        //        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL,"titleL":titleL]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-7-[contentL]-5-|", aView: titleL, bView: contentL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentL]-15-|", options: [], metrics: nil, views: ["contentL":contentL]))
        
        
        
        timeL.textColor = Profile.rgb(191, g: 191, b: 191)
        timeL.font = Profile.font(12)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-(>=3)-[timeL]-15-|", options: [], metrics: nil, views: ["titleL":titleL,"timeL":timeL]))
    }

    func fillData(newsData:NewsData)
    {
        contentImage.sd_setImageWithURL(NSURL(string: newsData.imageUrl!), placeholderImage: UIImage(named: "default"))
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
