//
//  WebHtml.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/11.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class ProductInfoVC: UIViewController,UIWebViewDelegate {
    
    var product:ProductData?
    var loadV:THActivityView!
    init(product:ProductData?)
    {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let leftBar = UIBarButtonItem(image: UIImage(named: "favorite"), style: .Done, target: self, action: "favorite")
//        self.navigationItem.rightBarButtonItem = leftBar

        self.view.backgroundColor = UIColor.whiteColor()
        let web = UIWebView()
        web.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        web.translatesAutoresizingMaskIntoConstraints = false
        web.delegate = self
        self.view.addSubview(web)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(web))
//        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(web))
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-10-[web]-45-|", aView: web, bView: nil))
        
        self.creatBookBt()
        
        
        

        //        var html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"10\" color=\"red\">爱玛电动车</font></p>  <img src=\"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg\" style=\"max-width:100%\"/> </body></html>"
        
        
        
        //        var html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"10\" color=\"red\">爱玛电动车</font></p> <img style=\"max-width:100%\" src=\"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg\"> <img src=\"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg\" style=\"max-width:100%\"/> </body></html>"
        
        var picHtml = ""
        let width = Int(Profile.width()) - 16
        for p in product!.picArr!
        {
            if p.url != nil
            {
                
//              picHtml = picHtml+"<img src=\"\(p.url!)\" style=\"max-width:100%; margin-bottom:8px\"/>"
                
                let s = "<img onload =  \"{if(this.width>\(width)){ this.height= \(width)/ this.width*this.height} else{ this.width = \(width)} }\" src=\"\(p.url!)\" style=\"margin-bottom:8px\"/>"
               picHtml = picHtml + s
            }
        }
        
        if product?.name != nil
        {
            let html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"3px\" color=\"black\">\(product!.name!)</font></p>\(picHtml)</body></html>"
//            print(html)
            web.loadHTMLString(html, baseURL: nil)
        }
        else
        {
            let html = "<html> <body> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> <p> <font size=\"3px\" color=\"black\"> </font></p>\(picHtml)</body></html>"
            
            web.loadHTMLString(html, baseURL: nil)
        }
        
        loadV = THActivityView(activityViewWithSuperView: self.view)
        
    }
    
    func creatBookBt()
    {
        let bt = UIButton(type: .Custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.titleLabel?.font = Profile.font(16)
        bt.setBackgroundImage(Profile.rgb(223, g: 32, b: 82).convertToImage(), forState: .Normal)
        bt.setBackgroundImage(Profile.rgb(219, g: 21, b: 58).convertToImage(), forState: .Highlighted)
        bt.setTitle("预约购买", forState: .Normal)
        bt.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(bt)
        bt.addTarget(self, action: "ProductInfoBookAction", forControlEvents: .TouchUpInside)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bt]-0-|", options: [], metrics: nil, views: ["bt":bt]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bt(45)]-0-|", options: [], metrics: nil, views: ["bt":bt]))
    }

    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadV.removeFromSuperview()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadV.removeFromSuperview()
    }
    
    func favorite()
    {
    
    
    }
    
    func ProductInfoBookAction(){
    
        if UserData.shared.token == nil
        {
            self.showLoginVC()
            return
        }
        
        let bookVC = BookVC()
        bookVC.productData = product
        self.navigationController?.pushViewController(bookVC, animated: true)

    }
    
    func showLoginVC(){
        let logVC = LogViewController()
//        logVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logVC, animated: true)
    }

    
}