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
    var table:UITableView = UITableView(frame: CGRectZero, style: .Plain)
    override func viewDidLoad() {
        super.viewDidLoad()
     
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        // Do any additional setup after loading the view.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
          return 1
        }
        return dataSource.count
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        if indexPath.section == 0
        {
            return 100
        }
        
        if indexPath.row == 0
        {
          return 30
        }
        return 55

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        return cell!
        
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
    let scoreTitleL:UILabel
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
        
        
        
        
        scoreTitleL = UILabel()
        scoreTitleL.translatesAutoresizingMaskIntoConstraints = false
        scoreTitleL.font = Profile.font(11)
        scoreTitleL.textColor = UIColor.rgb(153, g: 153, b: 153)

        
        scoreL = UILabel()
        scoreL.translatesAutoresizingMaskIntoConstraints = false
        scoreL.font = Profile.font(40)
        scoreL.textColor = UIColor.rgb(250, g: 84, b: 123)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(userImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[userImage]", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[userImage]-10-|", options: [], metrics: nil, views: ["userImage":userImage]))
        self.contentView.addConstraint(NSLayoutConstraint(item: userImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[userImage]-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"userImage":userImage]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        self.contentView.addSubview(phoneL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(phoneL, toItem: titleL))
        self.contentView.addConstraint(NSLayoutConstraint(item: phoneL, attribute: .Top, relatedBy: .Equal, toItem: titleL, attribute: .Bottom, multiplier: 1.0, constant: 5))
        
        
        
        self.contentView.addSubview(scoreTitleL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreTitleL]-15-|", aView: scoreTitleL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint(item: scoreTitleL, attribute: .Top, relatedBy: .Equal, toItem: userImage, attribute: .Top, multiplier: 1.0, constant: 0))
        
        
        
        self.contentView.addSubview(scoreL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[scoreL]-15-|", aView: scoreL, bView: nil))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[scoreTitleL]-10-[scoreL]", aView: scoreTitleL, bView: scoreL))

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
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

