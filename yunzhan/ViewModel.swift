//
//  ViewModel.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation


class TableNoSeparateHeadView: UITableViewHeaderFooterView {
    
    let contentL:UILabel
    
    override init(reuseIdentifier: String?) {
        contentL = UILabel()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contentL)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[contentL]", aView: contentL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(contentL, toItem: self.contentView))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TableHeadView: UITableViewHeaderFooterView {
    let contentL:UILabel
    override init(reuseIdentifier: String?) {
        contentL = UILabel()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(contentL)
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[contentL]", aView: contentL, bView: nil))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(contentL, toItem: self.contentView))
        
        let separateView = UIView(frame: CGRectMake(15,self.contentView.frame.size.height-1,0.5,self.contentView.frame.width - 15))
        separateView.translatesAutoresizingMaskIntoConstraints = false
        separateView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.contentView.addSubview(separateView)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[separateView]-0-|", options: [], metrics: nil, views: ["separateView":separateView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separateView(0.5)]-1-|", options: [], metrics: nil, views: ["separateView":separateView]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MoreTableFootView: UIView {
    override init(frame: CGRect) {
      super.init(frame: frame)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activity.center = CGPointMake(self.center.x - 30, self.center.y)
        self.addSubview(activity)
        activity.startAnimating()
        
        let label = UILabel(frame: CGRectMake(0, 0, 80, 18))
        label.textColor = UIColor(red: 102.0/255.0, green: 108.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        label.text = "加载更多..."
        label.center = CGPointMake(CGRectGetWidth(self.frame)/2.0+25, self.frame.size.height/2)
        label.font = UIFont.systemFontOfSize(15.0)
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
 
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


