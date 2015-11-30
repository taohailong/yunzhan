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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setZoomUrl(url)
    }
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        scroll = UIScrollView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height-64))
        scroll.delegate = self
        self.view.addSubview(scroll)
        scroll.contentSize = CGSizeMake(scroll.frame.width, scroll.frame.height-64)
        
        
        imageV = UIImageView(frame: scroll.bounds)
        scroll.addSubview(imageV)
        imageV.contentMode = .ScaleAspectFit
        scroll.maximumZoomScale = 3.0;
        //设置最小伸缩比例
        scroll.minimumZoomScale = 0.2;

        
    }
    func setZoomUrl(url:String!)
    {
       if url != nil
       {
          imageV.sd_setImageWithURL(NSURL(string: url!)!, placeholderImage: UIImage(named: "default"))
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
 }