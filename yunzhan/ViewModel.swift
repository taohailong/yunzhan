//
//  ViewModel.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class TableHeadView: UITableViewHeaderFooterView {
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