//
//  ScoreVC.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/2/24.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import UIKit

class ScoreVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [PersonData]()
    var net:NetWorkData!
    var refreshHeadV:THLRefreshView!
    var table:UITableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "我的积分"
        self.automaticallyAdjustsScrollViewInsets = false
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.dataSource = self
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.registerClass(ScoreHeadCell.self, forCellReuseIdentifier: "ScoreHeadCell")
        table.registerClass(ScoreVCCell.self, forCellReuseIdentifier: "ScoreVCCell")
        table.separatorColor = UIColor.rgb(243, g: 243, b: 243)
        self.view.addSubview(table)
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraint(NSLayoutConstraint(item: table, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: table, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0))

        
        self.fetchScoreList()
        self.setupRefresh()
        // Do any additional setup after loading the view.
    }

    
    func setupRefresh(){
        
        weak var wself = self
        refreshHeadV = THLRefreshView(frame: CGRectMake(0,0,Profile.width(),65))
        refreshHeadV.isManuallyRefreshing = true
        refreshHeadV.addToScrollView(table)
        refreshHeadV.setBeginRefreshBlock { () -> Void in
            wself?.fetchScoreList()
        }
    }

    
    
    func fetchScoreList(){
    
//      let loadV = THActivityView(activityViewWithSuperView: self.view)
      weak var wself = self
      net = NetWorkData()
      net.scoreList { (result, status) -> (Void) in
//        loadV.removeFromSuperview()
         wself?.refreshHeadV.endRefreshing()
        if let arr = result as? [PersonData]
        {
          wself?.dataSource = arr
          wself?.table.reloadData()
        }
        
      }
        net.start()
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if dataSource.count == 0
        {
          return 0
        }
        return 2
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
          return 1
        }
        return dataSource.count + 1
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        if indexPath.section == 0
        {
            return 85
        }
        
        if indexPath.row == 0
        {
          return 30
        }
        return 55

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScoreHeadCell") as! ScoreHeadCell
            let user = UserData.shared
            cell.fillData(nil, name: user.name, phone: user.phone, title: user.title, company: user.company, score: user.score)
            return cell
        }
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
            cell?.textLabel?.text = "积分排行榜"
            cell?.textLabel?.font = Profile.font(12)
            cell?.textLabel?.textColor = UIColor.rgb(102, g: 102, b: 102)
            return cell!
        }
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreVCCell") as! ScoreVCCell
        cell.hatImageV.hidden = true
        
        let data = dataSource[indexPath.row - 1]
        
        var scale:CGFloat = 1.0
        let previousData = dataSource[0]
        let previousScale = Float(previousData.score!)!
        if previousScale == 0
        {
            scale = 0
        }
        else
        {
            scale = CGFloat( Float(data.score!)! /  previousScale)
        }
        
        if indexPath.row > 3
        {
            cell.numberL.font = Profile.font(15)
            cell.numberL.textColor = UIColor.rgb(102, g: 102, b: 102)
            cell.scoreV.backgroundColor = UIColor.rgb(221, g: 221, b: 221)
        }
        else
        {
            cell.numberL.textColor = Profile.ScoreListOneColor
            cell.numberL.font = UIFont.boldSystemFontOfSize(16)
            if indexPath.row == 1
            {
                cell.hatImageV.hidden = false
                cell.scoreV.backgroundColor = Profile.ScoreListOneColor
            }
            else if indexPath.row == 2
            {
                cell.scoreV.backgroundColor = Profile.ScoreListTwoColor
            }
            else
            {
                cell.scoreV.backgroundColor = Profile.ScoreListThreeColor
            }
            
        }
        
        let number = "\(String(indexPath.row))"
        cell.fillScoreInfo(number, url: nil, infoStr: data.name, score: data.score,phone:data.phone , scoreScale: scale)
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class ScoreHeadCell:UITableViewCell {
    let userImage:UIImageView
    let titleL:UILabel
    let phoneL:UILabel
    
    let scoreL:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.image = UIImage(named: "settingUser")
        userImage.contentMode = .ScaleAspectFit
        
        titleL = UILabel()
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(20)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        phoneL = UILabel()
        phoneL.textColor = Profile.rgb(51, g: 51, b: 51)
        phoneL.font = Profile.font(15)
        phoneL.translatesAutoresizingMaskIntoConstraints = false
        
        
        let scoreTitleL = UILabel()
        scoreTitleL.text = "我的积分"
        scoreTitleL.translatesAutoresizingMaskIntoConstraints = false
        scoreTitleL.font = Profile.font(11)
        scoreTitleL.textColor = UIColor.rgb(153, g: 153, b: 153)

        
        scoreL = UILabel()
        scoreL.translatesAutoresizingMaskIntoConstraints = false
        scoreL.font = Profile.font(40)
        scoreL.textColor = Profile.ScoreTitleColor
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(userImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userImage]-10-|", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraint(NSLayoutConstraint(item: userImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        
        
        self.contentView.addSubview(scoreTitleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreTitleL]-15-|", aView: scoreTitleL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint(item: scoreTitleL, attribute: .Top, relatedBy: .Equal, toItem: userImage, attribute: .Top, multiplier: 1.0, constant: 0))

        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[titleL]-(>=10)-[scoreTitleL]", options: [], metrics: nil, views: ["titleL":titleL,"userImage":userImage,"scoreTitleL":scoreTitleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        
        self.contentView.addSubview(phoneL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneL, toItem: titleL))
        self.contentView.addConstraint(NSLayoutConstraint(item: phoneL, attribute: .Top, relatedBy: .Equal, toItem: titleL, attribute: .Bottom, multiplier: 1.0, constant: 5))
        
        
        
        
        
        
        self.contentView.addSubview(scoreL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreL]-15-|", aView: scoreL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[scoreTitleL]-5-[scoreL]", aView: scoreTitleL, bView: scoreL))

      }

    
    func fillData(userUrl:String? ,name:String? ,phone:String?,title:String?,company:String?,score:String?)
    {
        if userUrl != nil
        {
            userImage.sd_setImageWithURL(NSURL(string: userUrl!), placeholderImage: UIImage(named: "settingUser"))
        }
        
//        var constraint : NSLayoutConstraint? = nil
//        for temp in  self.contentView.constraints
//        {
//            if let f = temp.firstItem as? UIView
//            {
//                if f == phoneL&&temp.secondAttribute == .Bottom&&temp.firstAttribute == .Top
//                {
//                    constraint = temp
//                    break
//                }
//            }
//        }
//        
//        if name == nil
//        {
//            constraint?.constant = 14
//        }
//        else
//        {
//            constraint?.constant = 5
//        }
        
        if name != nil
        {
            let att = NSMutableAttributedString(string: name!, attributes: [NSFontAttributeName:Profile.font(17),NSForegroundColorAttributeName:Profile.rgb(51, g: 51, b: 51)])
            
            if title != nil
            {
                att.appendAttributedString(NSAttributedString(string: "  \(title!)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }
            
            if company != nil && company?.isEmpty != true
            {
                att.appendAttributedString(NSAttributedString(string: "-\(company!)", attributes: [NSFontAttributeName:Profile.font(11),NSForegroundColorAttributeName:Profile.rgb(153, g: 153, b: 153)]))
            }
            
            titleL.attributedText = att
        }
        phoneL.text = phone
        scoreL.text = score
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class ScoreVCCell:UITableViewCell {
    
    let numberL:UILabel
    let userImageV:UIImageView
    let infoL:UILabel
    let phoneL:UILabel
    let scoreL:UILabel
    let hatImageV:UIImageView
//    let scoreLayer:CAShapeLayer
    var scoreConstrant:NSLayoutConstraint!
    let scoreV:UIView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        numberL = UILabel()
        numberL.textColor = Profile.rgb(51, g: 51, b: 51)
        numberL.font = Profile.font(15)
        numberL.translatesAutoresizingMaskIntoConstraints = false
       
        userImageV = UIImageView()
        userImageV.image = UIImage(named: "settingUser")
        userImageV.translatesAutoresizingMaskIntoConstraints = false
      
        infoL = UILabel()
        infoL.textColor = Profile.rgb(51, g: 51, b: 51)
        infoL.font = Profile.font(11)
        infoL.translatesAutoresizingMaskIntoConstraints = false
        
        phoneL = UILabel()
        phoneL.textColor = infoL.textColor
        phoneL.font = infoL.font
        phoneL.translatesAutoresizingMaskIntoConstraints = false
        
        
        scoreL = UILabel()
        scoreL.textColor = Profile.rgb(51, g: 51, b: 51)
        scoreL.font = Profile.font(15)
        scoreL.translatesAutoresizingMaskIntoConstraints = false
 
        
        hatImageV = UIImageView()
        hatImageV.image = UIImage(named: "scoreHat")
        hatImageV.translatesAutoresizingMaskIntoConstraints = false
    
        
        
        scoreV = UIView()
        scoreV.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        
        
        self.contentView.addSubview(numberL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[numberL]", aView: numberL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(numberL, toItem: self.contentView))
        
        
        
        let blackView = UIView()
//        blackView.layer.masksToBounds = true
        blackView.layer.cornerRadius = 10
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.backgroundColor = UIColor.rgb(243, g: 243, b: 243)
        self.contentView.addSubview(blackView)
        
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-50-[blackView]-50-|", aView: blackView, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-23-[blackView(20)]", options: [], metrics: nil, views: ["blackView":blackView]))
        
    
        
        scoreV.layer.cornerRadius = 10

        self.contentView.addSubview(scoreV)
        self.contentView.addConstraint(NSLayoutConstraint(item: scoreV, attribute: .Left, relatedBy: .Equal, toItem: blackView, attribute: .Left, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: scoreV, attribute: .Top, relatedBy: .Equal, toItem: blackView, attribute: .Top, multiplier: 1.0, constant: 0))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: scoreV, attribute: .Height, relatedBy: .Equal, toItem: blackView, attribute: .Height, multiplier: 1.0, constant: 0))
        scoreConstrant = NSLayoutConstraint(item: scoreV, attribute: .Width, relatedBy: .Equal, toItem: blackView, attribute: .Width, multiplier: 0.0, constant: 0)
        self.contentView.addConstraint(scoreConstrant)
        
        
        
        self.contentView.addSubview(userImageV)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-38-[userImageV(35)]", options: [], metrics: nil, views: ["userImageV":userImageV]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[userImageV(35)]", options: [], metrics: nil, views: ["userImageV":userImageV]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(userImageV, toItem: self.contentView))
        
        
        
        self.contentView.addSubview(scoreL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(scoreL, toItem: blackView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreL]-15-|", aView: scoreL, bView: nil))

        
        
        self.contentView.addSubview(hatImageV)
        self.contentView.addConstraint(NSLayoutConstraint(item: hatImageV, attribute: .Left, relatedBy: .Equal, toItem: userImageV, attribute: .Left, multiplier: 1.0, constant: -3))
        self.contentView.addConstraint(NSLayoutConstraint(item: hatImageV, attribute: .Top, relatedBy: .Equal, toItem: userImageV, attribute: .Top, multiplier: 1.0, constant: -8))
        
        
        self.contentView.addSubview(infoL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImageV]-15-[infoL(80)]", options: [], metrics: nil, views: ["userImageV":userImageV,"infoL":infoL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-7-[infoL]", aView: infoL, bView: nil))
        
        
        
        self.contentView.addSubview(phoneL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[infoL]-5-[phoneL]", options: [], metrics: nil, views: ["phoneL":phoneL,"infoL":infoL]))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-7-[phoneL]", aView: phoneL, bView: nil))
        
    }

    func fillScoreInfo(number:String,url:String?,infoStr:String?,score:String?,phone:String?,scoreScale:CGFloat)
    {
        phoneL.text = phone
        numberL.text = number
        infoL.text = infoStr
        scoreL.text = score
        scoreConstrant.constant = (Profile.width()-100)*scoreScale
//       imageView?.sd_setImageWithURL(<#T##url: NSURL!##NSURL!#>, placeholderImage: <#T##UIImage!#>)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
