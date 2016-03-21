//
//  PopView.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/3/8.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
@objc protocol PopViewProtocol {

    func popViewDidSelect(index:Int)->Void
    optional func popViewDismissed()
}
class PopView:UIView,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    var dataArr : [(image:String?,title:String)]!
    var cellTextAlignment = NSTextAlignment.Left
    var selectIndex:NSInteger = 0
    var selectCellColor = UIColor.rgb(51, g: 51, b: 51)
    
    var delegate:PopViewProtocol? {
        didSet{
           
            if let nav = delegate as? UINavigationController
            {
               nav.interactivePopGestureRecognizer?.enabled = false
            }
        
        }
    }
    var table:UITableView!
    init(contents: [(image:String?,title:String)],showViewFrame:CGRect,trangleX:CGFloat) {
        
        super.init(frame: CGRectMake(0, 0, Profile.width(), Profile.height()))
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToView")
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "tapToView")
        swipeGesture.delegate = self
        self.addGestureRecognizer(swipeGesture)
        
        
        
        
        let contentLayer = self.creatSubLayer(showViewFrame, corner: 3, trangleX: trangleX , trangleLength: 5)
        self.layer.addSublayer(contentLayer)
        
        
        
        dataArr = contents
        table = UITableView(frame: CGRectMake(CGRectGetMinX(showViewFrame), CGRectGetMinY(showViewFrame), CGRectGetWidth(showViewFrame), CGRectGetHeight(showViewFrame)), style: .Plain)
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 3
        table.tableFooterView = UIView(frame: CGRectMake(0,0,1,1))
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        table.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        table.registerClass(UITableViewCell.self , forCellReuseIdentifier: "UITableViewCell")
        self.addSubview(table)
        
    }

    
    func popSelect(index:Int)
    {
       if delegate != nil
       {
          if let _ =  delegate?.popViewDidSelect(index)
          {
//              delegate?.popViewDidSelect(index)
          }
        
       }
       self.disMissPopView()
    }
    
    
    func tapToView()
    {
       self.disMissPopView()
    }
    
    
    
    func disMissPopView(){
    
        if  let _ =  delegate?.popViewDismissed?()
        {
            delegate!.popViewDismissed!()
            
            if let nav = delegate as? UINavigationController
            {
                nav.interactivePopGestureRecognizer?.enabled = false
            }
 
        }

       self.removeFromSuperview()
    }
    
    
    
    
    
    func creatSubLayer(rect:CGRect,corner:CGFloat,trangleX:CGFloat,trangleLength:CGFloat)->CALayer
    {
    
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.whiteColor().CGColor;
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetMinX(rect)+corner, CGRectGetMinY(rect)))
        
        
        // 2,4 调整三角形状
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect), CGRectGetMinY(rect)))
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect) + trangleLength/2 + 2 , CGRectGetMinY(rect)-trangleLength))
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect) + trangleLength + 4, CGRectGetMinY(rect)))
        
        
        
        //    rightTop
        path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect)-corner, CGRectGetMinY(rect)))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + trangleLength), controlPoint: CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)))
        
        
        
        //    rightBottom
        
        path.addLineToPoint(CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)-corner))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMaxX(rect)-corner, CGRectGetMaxY(rect)), controlPoint: CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)))
        
        
        
        //    leftBottom
        
        path.addLineToPoint(CGPointMake(CGRectGetMinX(rect)+corner, CGRectGetMaxY(rect)))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)-corner), controlPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)))
        
        
        

        //    leftTop
        
        path.addLineToPoint(CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)+corner))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMinX(rect)+corner, CGRectGetMinY(rect)), controlPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)))
        
        
        layer.path = path.CGPath;
       return layer
    
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        
        let element = dataArr[indexPath.row]
        if element.image != nil
        {
           cell?.imageView?.image = UIImage(named: element.image!)
        }
        cell?.textLabel?.textAlignment = cellTextAlignment
        cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell?.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        cell?.textLabel?.font = Profile.font(13)
        cell?.textLabel?.textColor = UIColor.rgb(51, g: 51, b: 51)
//        cell?.textLabel?.highlightedTextColor = selectCellColor
        
        if selectIndex == indexPath.row
        {
           cell?.textLabel?.textColor = selectCellColor
//           cell?.selected = true
        }
        else
        {
           cell?.textLabel?.textColor = UIColor.rgb(51, g: 51, b: 51)
//           cell?.selected = false
        }
        
        cell?.textLabel?.text = element.title
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.popSelect(indexPath.row)
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        let point = touch.locationInView(self)
        
        if table.frame.contains(point)
        {
          return false
        }

        return true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}