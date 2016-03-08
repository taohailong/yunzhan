//
//  PopView.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/3/8.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
protocol PopViewProtocol {

    func popViewDidSelect(index:Int)->Void

}
class PopView:UIView {
    
    var delegate:PopViewProtocol?
    init(contents: [(image:String?,title:String)],showViewFrame:CGRect) {
        
        super.init(frame: CGRectMake(0, 0, Profile.width(), Profile.height()))
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToView")
        self.addGestureRecognizer(tapGesture)
        
        let contentLayer = self.creatSubLayer(showViewFrame, corner: 3, trangleX: CGRectGetWidth(showViewFrame) - 20 , trangleLength: 5)
//        contentLayer.backgroundColor = UIColor.rgb(243, g: 243, b: 243).CGColor
        self.layer.addSublayer(contentLayer)
        
        let button = UIButton(type: .Custom)
        button.titleLabel?.font = Profile.font(17)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.tag = 0
        button.frame = CGRectMake(CGRectGetMinX(showViewFrame) + 5, CGRectGetMinY(showViewFrame), CGRectGetWidth(showViewFrame)-5, CGRectGetHeight(showViewFrame))
        button.setTitle(contents[0].title, forState: .Normal)
        
        if let imageName = contents[0].image
        {
             button.setImage(UIImage(named:imageName ), forState: .Normal)
        }
        
        self.addSubview(button)
        button.addTarget(self, action: "popSelect:", forControlEvents: .TouchUpInside)
    }

    
    func popSelect(sender:UIButton)
    {
       if delegate != nil
       {
          delegate?.popViewDidSelect(sender.tag)
        }
       self.disMissPopView()
    }
    
    
    func tapToView()
    {
      self.disMissPopView()
    }
    
    
    
    func disMissPopView(){
    
       self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatSubLayer(rect:CGRect,corner:CGFloat,trangleX:CGFloat,trangleLength:CGFloat)->CALayer
    {
    
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.whiteColor().CGColor;
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetMinX(rect)+corner, CGRectGetMinY(rect)))
        
        
        //
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect), CGRectGetMinY(rect)))
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect) + trangleLength/2, CGRectGetMinY(rect)-trangleLength))
        path.addLineToPoint(CGPointMake(trangleX + CGRectGetMinX(rect) + trangleLength, CGRectGetMinY(rect)))
        
        
        
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
    
}