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
        
        let leftBar = UIBarButtonItem(image: UIImage(named: "favorite"), style: .Done, target: self, action: "favorite")
        self.navigationItem.rightBarButtonItem = leftBar

        
        let web = UIWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        web.delegate = self
        self.view.addSubview(web)
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(web))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(web))
        

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
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadV.removeFromSuperview()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadV.removeFromSuperview()
    }
    
    func favorite()
    {
    
    
    }
}