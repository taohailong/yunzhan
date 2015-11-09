//
//  ContactsController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/9.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class ContactsListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var prefixArr:[String]!
    var table :UITableView!
    var dataArr:[[PersonData]]!
    override func viewDidLoad() {
        
        table = UITableView(frame: CGRectZero, style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(table)
        table.registerClass(ContactsPersonCell.self, forCellReuseIdentifier: "ContactsPersonCell")
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if prefixArr == nil
        {
           return 0
        }
        
        return prefixArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arr = dataArr[section]
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonCell") as! ContactsPersonCell
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return prefixArr[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    
        return prefixArr
    }// return list of section titles to display in section index view (e.g. "ABCD...Z#")
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        let s = prefixArr!.indexOf(title)
        return s!
    }
    
}




class ContactsPersonCell: UITableViewCell {
    let nameL:UILabel
    let titleL:UILabel
    var phoneBt:UIButton

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        nameL = UILabel()
        titleL = UILabel()
        phoneBt = UIButton(type: .Custom)

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleL.textColor = Profile.rgb(153, g: 153, b: 153)
        titleL.font = Profile.font(12)
        self.contentView.addSubview(titleL)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleL]", options: [], metrics: nil, views: ["titleL":titleL]))
        
        
        
        nameL.textColor = Profile.rgb(102, g: 102, b: 102)
        nameL.font = Profile.font(12)
        self.contentView.addSubview(nameL)
        nameL.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[nameL]", options: [], metrics: nil, views: ["nameL":nameL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-10-[nameL]", options: [], metrics: nil, views: ["nameL":nameL,"titleL":titleL]))
        
        
        
        phoneBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        phoneBt.titleLabel?.font = Profile.font(14)
        phoneBt.translatesAutoresizingMaskIntoConstraints = false
        phoneBt.setImage(UIImage(named: "exhibitorPhone"), forState: .Normal)
        phoneBt.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        self.contentView.addSubview(phoneBt)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[nameL]-15-[phoneBt]", options: [], metrics: nil, views: ["phoneBt":phoneBt,"nameL":nameL]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(phoneBt, toItem: nameL))
    }

    func fillData(title:String?,name:String?,phone:String?)
    {
        titleL.text = title
        nameL.text =  name
        phoneBt.setTitle(phone, forState: UIControlState.Normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

