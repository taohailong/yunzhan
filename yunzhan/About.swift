//
//  About.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class AboutVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "关于"
        let aboutImage = UIImageView()
        aboutImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(aboutImage)
        aboutImage.image = UIImage(named: "aboutImage")
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-180-[aboutImage]", aView: aboutImage, bView: nil))
        self.view.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(aboutImage, toItem: self.view))
        
        
        
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(name)
        name.textColor = Profile.rgb(223, g: 32, b: 82)
        name.font = Profile.font(15)
        name.text = "中国电动车展"
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[aboutImage]-10-[name]", aView: aboutImage, bView: name))
        self.view.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(name, toItem: self.view))
        
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(title)
        title.textColor = Profile.rgb(102, g: 102, b: 102)
        title.font = Profile.font(12)
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        title.text = "版本V\(version!)"
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[name]-10-[title]", aView: name, bView: title))
        self.view.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(title, toItem: self.view))

        
        
        let code = UILabel()
        code.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(code)
        code.textColor = Profile.rgb(153, g: 153, b: 153)
        code.font = Profile.font(11)
        code.text = "Copyright  2014-2015 Wuxi Chestnut Co., Ltd."
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[code]-35-|", aView: code, bView: nil))
        self.view.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(code, toItem: self.view))

        
        
        let company = UILabel()
        company.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(company)
        company.textColor = Profile.rgb(153, g: 153, b: 153)
        company.font = Profile.font(11)
        company.text = "无锡栗子网络科技有限公司"
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[company]-5-[code]", aView: company, bView: code))
        self.view.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(company, toItem: self.view))
        
    }
}