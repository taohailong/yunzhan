//
//  ZoomView.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/30.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class ZoomVC: UIViewController,UIScrollViewDelegate {
    var imageV:UIImageView!
    var  scroll:UIScrollView!
    var  url:String!
    var targetImageV:UIImageView!
    var centerPoint:CGPoint!
    var targetLayer:CALayer!
    var zoomScaleX:CGFloat = 0.0
    var zoomScaleY:CGFloat = 0.0
    
    
    func targetLayerZoomBig(){
    
        targetLayer = CALayer()
        targetLayer.bounds = targetImageV.bounds
        targetLayer.contents = targetImageV.layer.contents
        targetLayer.position = centerPoint
        self.view.layer.addSublayer(targetLayer)
        
        let scale = Profile.width() / Profile.height()
        let originalWidth = (targetImageV.image?.size.width)!
        let originalHeight = (targetImageV.image?.size.height)!
        
        if originalWidth / originalHeight > scale
        {
            zoomScaleX = Profile.width() / targetImageV.bounds.size.width
            
            let trueHeight = originalHeight * (Profile.width()/originalWidth)
            if trueHeight > targetImageV.bounds.size.height
            {
                zoomScaleY = trueHeight / targetImageV.bounds.size.height
            }
            else
            {
                zoomScaleY = targetImageV.bounds.size.height / trueHeight
            }
            
        }
        else
        {
            zoomScaleY = Profile.height() / targetImageV.bounds.size.height
            
            let trueWidth = originalWidth * (Profile.height()/originalHeight)
            if trueWidth > targetImageV.bounds.size.width
            {
                zoomScaleX = trueWidth / targetImageV.bounds.size.width
            }
            else
            {
                zoomScaleX = targetImageV.bounds.size.width / trueWidth
            }
            
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = "position"
        animation.fromValue = NSValue(CGPoint: self.targetLayer.position)
        animation.toValue = NSValue(CGPoint: self.view.center)
        
        
        let sizeAnimationX = CABasicAnimation()
        sizeAnimationX.keyPath = "transform.scale.x"
        sizeAnimationX.fromValue = NSNumber(double: 1.0)
        sizeAnimationX.toValue = NSNumber(double: Double(self.zoomScaleX))
        
        
        
        let sizeAnimationY = CABasicAnimation()
        sizeAnimationY.keyPath = "transform.scale.y"
        sizeAnimationY.fromValue = NSNumber(double: 1.0)
        sizeAnimationY.toValue = NSNumber(double: Double(self.zoomScaleY))
        
        
        
        let group = CAAnimationGroup()
        group.setValue("big", forKey: "key")
        group.animations = [animation,sizeAnimationX,sizeAnimationY]
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        group.delegate = self
        //        group.autoreverses = true
        targetLayer.addAnimation(group, forKey: nil)
    
    }
    
    
    func targetLayerZoomSmall()
    {
       
//        self.view.layer.addSublayer(targetLayer)
        let animation = CABasicAnimation()
        animation.keyPath = "position"
        animation.fromValue = NSValue(CGPoint: self.view.center)
        animation.toValue = NSValue(CGPoint: centerPoint)
        
        
        let sizeAnimationX = CABasicAnimation()
        sizeAnimationX.keyPath = "transform.scale.x"
        sizeAnimationX.fromValue = NSNumber(double: Double(zoomScaleX))
        sizeAnimationX.toValue = NSNumber(double: 1.0)
        
        
        
        let sizeAnimationY = CABasicAnimation()
        sizeAnimationY.keyPath = "transform.scale.y"
        sizeAnimationY.fromValue = NSNumber(double: Double(zoomScaleY))
        sizeAnimationY.toValue = NSNumber(double: 1.0)
        
        
        
        let group = CAAnimationGroup()
        group.setValue("small", forKey: "key")
        group.animations = [animation,sizeAnimationX,sizeAnimationY]
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        group.delegate = self
        group.duration = 0.26
        targetLayer.addAnimation(group, forKey: nil)

    }
    
    
    override func animationDidStop( anim: CAAnimation, finished flag: Bool) {
        
        if let name = anim.valueForKey("key") as? String
        {
           if name == "big"
           {
              self.setZoomUrl(url)
            }
            else
           {}
            targetLayer.removeAllAnimations()
            targetLayer.removeFromSuperlayer()
        }
      
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.targetImageV != nil
        {
          self.targetLayerZoomBig()
        }
        else
        {
           self.setZoomUrl(url)
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        scroll = UIScrollView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.delegate = self
        self.view.addSubview(scroll)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scroll]-0-|", options: [], metrics: nil, views: ["scroll":scroll]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scroll]-0-|", options: [], metrics: nil, views: ["scroll":scroll]))
        scroll.contentSize = CGSizeMake(Profile.width(), Profile.height())
        
        
        imageV = UIImageView(frame: CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height))
        imageV.contentMode = .Center
        scroll.addSubview(imageV)
        
        scroll.maximumZoomScale = 3.0;
        //设置最小伸缩比例
        scroll.minimumZoomScale = 0.2;
        let tap = UITapGestureRecognizer(target: self, action: "tapGestureToDismiss")
        self.view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    
    func tapGestureToDismiss(){
      
        if self.targetImageV != nil
        {
            UIApplication.sharedApplication().keyWindow?.layer.addSublayer(targetLayer)
            scroll.hidden = true
            self.targetLayerZoomSmall()
        }
        
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
//        
//        weak var wself = self
//        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
//            
            self.dismissViewControllerAnimated(false) { () -> Void in
            }
    }
    
    func setZoomUrl(url:String!)
    {
       if  let imageUrl = NSURL(string: url)
       {
          weak var wself = self
         imageV.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "default_big"), completed: { (let image:UIImage!, let err:NSError!, let type: SDImageCacheType, let url: NSURL!) -> Void in
            
            if err == nil
            {
                wself?.imageV.contentMode = .ScaleAspectFit
            }
        })
       }
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        
        imageV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
        scrollView.contentSize.height * 0.5 + offsetY);
    }
    
    
    func orientationChanged(){
    
//        print("frame \(scroll.contentSize)")
//        
//        let orientation = UIDevice.currentDevice().orientation
//        
//        switch orientation {
//        
//        case .LandscapeRight:
//            print("键靠右")
//            
//         
//            
//        case .LandscapeLeft:
//            print("home键靠左")
//        case .Portrait:
//            
//            scroll.contentSize = CGSizeMake(Profile.width(), Profile.height())
//            print("正常")
//        case .PortraitUpsideDown:
//            print("向下")
//            
//        case .FaceUp:
//            print("face 向下")
//        default:
//            print("face 正常")
//            
//        }
        scroll.contentSize = CGSizeMake(Profile.width(), Profile.height())
        imageV.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height)
//        let orientation = UIApplication.sharedApplication().statusBarOrientation
//        
//        switch orientation {
//        
//        case .LandscapeRight:
//            print("home键靠右").
//            
//        case .LandscapeLeft:
//           print("home键靠左")
//        default:
//           print("home键靠左")
//        }
    
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .AllButUpsideDown
    }
    
    deinit
    {
       print("zoom over")
    }
 }