//
//  TimeLineCommit.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/24.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
class TimeLineCommitVC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{
    var textV:UITextView!
    var addBt:UIButton!
    var scaleImage:UIImage!
    var net:NetWorkData!
    var commitFinsh:((Void)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "上传图片"
        let application = UIApplication.sharedApplication()
        application.setStatusBarStyle(.Default, animated: true)

        let backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backView)
        backView.backgroundColor = UIColor.whiteColor()
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(backView))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[backView(260)]", options: [], metrics: nil, views: ["backView":backView]))
        self.view.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        
        
        textV = UITextView()
//        textV.textColor = Profile.rgb(102, g: 102, b: 102)
        textV.font = Profile.font(14)
        textV.text = "这一刻的想法..."
        textV.textColor = Profile.rgb(210, g: 210, b: 210)
        textV.delegate = self
        textV.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(textV)
//        backView.addConstraints(NSLayoutConstraint.layoutHorizontalFull(textV))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[textV(100)]", options: [], metrics: nil, views: ["textV":textV]))
        
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[textV]-15-|", options: [], metrics: nil, views: ["textV":textV]))
        
        
        addBt = UIButton(type: .Custom)
//        addBt.backgroundColor = UIColor.redColor()
        addBt.translatesAutoresizingMaskIntoConstraints = false
        addBt.addTarget(self, action: "addImageAction", forControlEvents: .TouchUpInside)
        backView.addSubview(addBt)
        addBt.setImage(UIImage(named: "commit_bt"), forState: .Normal)
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[addBt(125)]", options: [], metrics: nil, views: ["addBt":addBt]))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[addBt(75)]-30-|", options: [], metrics: nil, views: ["addBt":addBt]))
        
        
        
        let leftBt = UIButton(type: .Custom)
        leftBt.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftBt.setTitle("取消", forState: .Normal)
        leftBt.titleLabel?.font = Profile.font(16)
        leftBt.setTitleColor(Profile.rgb(102, g: 102, b: 102), forState: .Normal)
        leftBt.addTarget(self, action: "backToRoot", forControlEvents: .TouchUpInside)
        let leftBar = UIBarButtonItem(customView: leftBt)
        self.navigationItem.leftBarButtonItem = leftBar
        
        
        
        let rightBt = UIButton(type: .Custom)
        rightBt.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightBt.setTitle("发送", forState: .Normal)
        rightBt.titleLabel?.font = Profile.font(16)
        rightBt.setTitleColor(Profile.rgb(223, g: 32, b: 82), forState: .Normal)
        rightBt.addTarget(self, action: "sendMessage", forControlEvents: .TouchUpInside)
        let rightBar = UIBarButtonItem(customView: rightBt)
        self.navigationItem.rightBarButtonItem = rightBar

        
    }
    
    func backToRoot(){
    
        let application = UIApplication.sharedApplication()
        application.setStatusBarStyle(.LightContent, animated: true)

        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "这一刻的想法..."{
           textView.text = nil
           textView.textColor = Profile.rgb(102, g: 102, b: 102)
        }
        
    }
    
    func sendMessage(){
        
        if scaleImage == nil
        {
            let warn = THActivityView(string: "请选择图片")
            warn.show()
            return
        }
        
        if textV.text == "这一刻的想法..."{
            textV.text = ""
        }
        
        let loadV = THActivityView(activityViewWithSuperView: self.view)
        
       weak var wself = self
        net = NetWorkData()
        net.loadUpImage(UIImagePNGRepresentation(scaleImage)!, comment: textV.text!, block: { (result, status) -> (Void) in
            loadV.removeFromSuperview()
           if status == .NetWorkStatusError
           {
              if let warnString = result as? String
              {
                 let warn = THActivityView(string: warnString)
                 warn.show()
              }
            
              return
            }
            
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.LightContent, animated: true)
            wself?.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            if wself?.commitFinsh != nil
            {
                wself?.commitFinsh!()
            }
        })
//        net.start()
    }
    
    

    func addImageAction(){
    
        textV.resignFirstResponder()
        let sheet = UIActionSheet(title: nil , delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle:"手机拍照")
        sheet.addButtonWithTitle("从手机中选择图片")
        sheet.showInView((self.navigationController!.view))
    
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0
        {
           self.launchPhotoCarmera()
        }
        else if actionSheet.cancelButtonIndex == buttonIndex
        {
          return
        }
        else
        {
           self.launchPhotoLibrary()
        }
    }
    
    func launchPhotoCarmera()
    {
       let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.delegate = self
        self.navigationController?.presentViewController(picker, animated: true, completion: { () -> Void in
            
        })
    
    }
    
    func launchPhotoLibrary()
    {
       let picker = UIImagePickerController()
//        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.navigationController?.presentViewController(picker, animated: true, completion: { () -> Void in
            
        })
    
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        scaleImage = image
//        print("width \(image?.size.width) height \(image?.size.height)")
//        scaleImage = image?.scaleToSize(CGSizeMake((image?.size.width)!*0.1, (image?.size.height)!*0.1))
        
        var s:CGFloat = 1.0
        if image!.size.width > 500.0
        {
            s = 500.0 / image!.size.width
        }
        scaleImage = UIImage(byScalingAndCroppingForSize: CGSizeMake((image?.size.width)! * s, (image?.size.height)! * s), and: image)
        
        
//        scaleImage = image?.imageCompressScale(0.1)
//        print("width \(scaleImage?.size.width) height \(scaleImage?.size.height)")
        
//        let s = UIImageView()
//        s.backgroundColor = UIColor.redColor()
//        s.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(s)
//        
//        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(s))
//        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(s))
//        
//        s.image = scaleImage
        addBt.setImage(scaleImage, forState: .Normal)
    }
    
    deinit{
    
//        net.cancel()
//        net = nil
    }
}