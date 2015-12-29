//
//  ExhibitorMap.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/12/29.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class ExhibitorMapVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var net:NetWorkData!
    var table:UITableView!
    var dataArr:[TimeMessage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "展位分布图"
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
//        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
//        table.separatorColor = UIColor.redColor()
        table.separatorStyle = .None
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.registerClass(ExhibitorMapHeadView.self , forHeaderFooterViewReuseIdentifier: "ExhibitorMapHeadView")
        table.registerClass(ExibitorMapPicCell.self, forCellReuseIdentifier: "ExibitorMapPicCell")
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        
//        let headView = UILabel(frame: CGRectMake(0,0,Profile.width(),30))
//        headView.text = "平面图"
//        table.tableHeaderView = headView
        self.fetchExhibitorMap()
    }
    
    func fetchExhibitorMap(){
       
        weak var wself = self
        let load = THActivityView(activityViewWithSuperView: self.view)
       net = NetWorkData()
        net.getExhibitorMap { (result, status) -> (Void) in
            
            load.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if let warnStr = result as? String
                {
                    let warnView = THActivityView(string: warnStr)
                    warnView.show()
                }
                return
            }
            
            if let arr = result as? [TimeMessage]
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 36
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("ExhibitorMapHeadView") as! ExhibitorMapHeadView
        let pic = dataArr[section]
        head.titleL.text = pic.personTitle
        return head
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let pic = dataArr[indexPath.section]
        
        return CGFloat(pic.picHeight)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ExibitorMapPicCell") as! ExibitorMapPicCell
        let pic = dataArr[indexPath.section]
        cell.loadPicUrl(pic.picThumbUrl, height: pic.picHeight)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let pic = dataArr[indexPath.section]
        self.showZoomMap(pic.picThumbUrl, imageView: nil)
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
    }
}


class ExibitorMapPicCell: TimeLinePicCell {
    
    override func setSubViewLayout(){
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[picImageV]-15-|", options: [], metrics: nil, views: ["picImageV":picImageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[picImageV]-15-|", options: [], metrics: nil, views: ["picImageV":picImageV]))
 
        
        let shaw = UIView()
        shaw.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(shaw)
        shaw.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[shaw(0.5)]-0-|", options: [], metrics: nil, views: ["shaw":shaw]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[shaw]-0-|", options: [], metrics: nil, views: ["shaw":shaw]))

//        self.selectionStyle = .None
        //        self.separatorInset = UIEdgeInsetsMake(0, Profile.width(), 0, 0)
//        self.separatorInset = UIEdgeInsetsMake(15, 0, 0, 0)
//        if #available(iOS 8.0, *) {
//            self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
//        } else {
//            // Fallback on earlier versions
//        }
    }

}


class ExhibitorMapHeadView: UITableViewHeaderFooterView {
    
    let titleL:UILabel
    override init(reuseIdentifier: String?) {
        
        titleL = UILabel()
        titleL.font = Profile.font(12)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        let spot = UIView(frame: CGRectMake(15,11,8,8))
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 4.0
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: self.contentView))
         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[spot]-10-[titleL]", options: [], metrics: nil, views: ["spot":spot,"titleL":titleL]))
//        titleL.frame = CGRectMake(15,11,8,8)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}