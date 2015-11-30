//
//  Suggestion.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/12.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class SuggestionVC: UIViewController,UITextViewDelegate {
    var textView:UITextView!
    var lenth:Int!
    var indicateL:UILabel!
    var net:NetWorkData!
    override func viewDidLoad() {
        self.title = "建议意见"
        self.automaticallyAdjustsScrollViewInsets = false
        lenth = 0
        let leftBar = UIBarButtonItem(title: "提交", style:UIBarButtonItemStyle.Plain, target: self, action: "commitSuggestion")
        self.navigationItem.rightBarButtonItem = leftBar
        self.view.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        
        textView = UITextView(frame: CGRectZero)
        textView.layer.masksToBounds = true;
        textView.becomeFirstResponder()
        textView.layer.cornerRadius = 4;
        textView.textColor = Profile.rgb(102, g: 102, b: 102)
        textView.font = Profile.font(14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textView.delegate = self
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[textView]-15-|", aView: textView, bView: nil))

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[textView(150)]", options: [], metrics: nil, views: ["textView":textView]))
        indicateL = UILabel()
        indicateL.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicateL)
        indicateL.textColor = Profile.rgb(221, g: 221, b: 221)
        indicateL.font = Profile.font(12)
        indicateL.text = "还能输入140个字"
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[indicateL]-30-|", aView: indicateL, bView: nil))
        self.view.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-200-[indicateL]", aView: indicateL, bView: nil))
        
    }
    
    func commitSuggestion(){
       
        weak var wself = self
        net = NetWorkData()
         let loadV = THActivityView(activityViewWithSuperView: self.view)
        net.sendSuggestion(textView.text) { (result, status) -> (Void) in
            
            loadV.removeFromSuperview()
            
            if let warnStr = result as? String
            {
                let showV = THActivityView(string: warnStr)
                showV.show()
                wself?.navigationController?.popViewControllerAnimated(true)
            }
        }
        net.start()
    }
    
    
    func textViewDidChange(textView: UITextView) {
//        print(textView.text)
//        textView.text = "1"
        lenth = textView.text.characters.count
        let l =  140-lenth>0 ? 140-lenth:0
        indicateL.text = "还能输入\(l)个字"
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
 
//         print(text)
        if lenth > 139
        {
            return false
        }
        return true
    }
    
}