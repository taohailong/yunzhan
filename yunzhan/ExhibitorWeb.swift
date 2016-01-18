//
//  ExhibitorWeb.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/15.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class ExhibitorAdWebController:UIViewController,UIWebViewDelegate {
    var webIsLoad:Bool = false
    var loadV:THActivityView!
    var webHtml:String?
    let web :UIWebView
    let net = NetWorkData()
    init(bodyHtml:String){
        web = UIWebView()
        webHtml = bodyHtml
        super.init(nibName: nil, bundle: nil)
        
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        web.delegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(web)
        
        self.loadLocalHtml()
        loadV = THActivityView(activityViewWithSuperView: self.view)
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(web))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(web))
        self.getNetData(webHtml!)
        webHtml = nil
        
    }
    
    
    func getNetData(code:String){
    
        weak var wself = self
        
        if code == "1"
        {
          net.exhibitor1({ (result, status) -> (Void) in
            wself?.parseData(result, status: status)
          })
        }
        if code == "2"
        {
           net.exhibitor2({ (result, status) -> (Void) in
            wself?.parseData(result, status: status)
           })
        }
        
        if code == "3"
        {
            net.exhibitor3({ (result, status) -> (Void) in
                wself?.parseData(result, status: status)
            })
        }

        if code == "5"
        {
            net.exhibitor5({ (result, status) -> (Void) in
                wself?.parseData(result, status: status)
            })
        }

        if code == "6"
        {
            net.exhibitor6({ (result, status) -> (Void) in
                wself?.parseData(result, status: status)
            })
        }
        
        if code == "7"
        {
            net.exhibitor7 { (result, status) -> (Void) in
                wself?.parseData(result, status: status)
            }
        }
        
       net.start()
    }
    
    
    func parseData(data:Any?,status:NetStatus)
    {
        if status == .NetWorkStatusError{
            return
        }
        if let html = data as? String
        {
            self.writeBodyToWeb(html)
        }
        
    }
    
    
    func loadLocalHtml(){
       
        let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        web.loadRequest(NSURLRequest(URL: url))
     }
    
    
    func writeBodyToWeb(html:String){

        var original = NSString(string: html)
        original = original.stringByReplacingOccurrencesOfString("\r\n", withString: "</br>")
        
        webHtml = original as String
        self.loadWebJs()
    }
    
    
    func loadWebJs(){
    
       if webIsLoad == true && webHtml != nil
       {
          let s = "addBodyHtml('\(webHtml!)')"
          web.stringByEvaluatingJavaScriptFromString(s)
       }
        
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadV.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadV.removeFromSuperview()
        webIsLoad = true
        
        if webIsLoad == true
        {
           self.loadWebJs()
        }

    }
    
    
    
    
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.URL?.absoluteString
        {
            if url.verifyIsImageURL()
            {
              self.showZoomMap(url)
              return false
            }
            if url.verifyIsMobilePhoneNu()
            {

               return false
            }
            return true
        }
        return true
        
    }
    
    
    
    
    func showZoomMap(url:String?){
        
        let zoom = ZoomVC()
        zoom.url = url
        self.presentViewController(zoom, animated: false) { () -> Void in
            
        }
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
