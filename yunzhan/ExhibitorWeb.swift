//
//  ExhibitorWeb.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/15.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class ExhibitorAdWebController:UIViewController,UIWebViewDelegate {
    var readLocal:Bool = false
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
        
    }
    
    
    func getNetData(code:String){
    
        weak var wself = self
        net.exhibitor7 { (result, status) -> (Void) in
        
         if status == .NetWorkStatusError{
            return
         }
         if let html = result as? String
         {
            wself?.writeBodyToWeb(html)
         }
        }
       net.start()
    }
    
    
    func loadLocalHtml(){
       
        let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
    
    
        let html = try! NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        //        html = html.stringByReplacingOccurrencesOfString("tao", withString: original as String)
        //
        web.loadHTMLString(html as String, baseURL: nil)
        //web.loadRequest(NSURLRequest(URL: url))
     }
    
    
    func writeBodyToWeb(html:String){

        var original = NSString(string: html)
        original = original.stringByReplacingOccurrencesOfString("\r\n", withString: "</br>")
        let path = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        var body = try! NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        body = body.stringByReplacingOccurrencesOfString("\" \"", withString: original as String)
        web.loadHTMLString(body as String, baseURL: nil)
//        let s = "document.write('\(original)');"
//
//       print(html)
      // web.stringByEvaluatingJavaScriptFromString(s)
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadV.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadV.removeFromSuperview()
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
