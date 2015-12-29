//
//  RootCollectionCells.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/4.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation

class CommonCell: UICollectionViewCell {
    
    let label:UIImageView
    var exhibitorID:String!
    override init(frame: CGRect) {
        
        label = UIImageView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .Center
        label.image = UIImage(named: "default")
        label.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        super.init(frame: frame)
        self.contentView.addSubview(label)
//        self.backgroundColor = UIColor.whiteColor()
        self.contentView.backgroundColor = UIColor.whiteColor()
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label]-10-|", options: [], metrics: nil , views: ["label":label])
        
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-|", options: [], metrics: nil, views: ["label":label])
        
        self.contentView.addConstraints(h)
        self.contentView.addConstraints(v)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageUrl(url:String?){
        
        if let furl = url
        {
            label.backgroundColor = Profile.rgb(243, g: 243, b: 243)
//            weak var wself = self
            weak var wiamge = label
           let req = NSURL(string: furl)
//            let req = NSURL(string: "http:www.baidu.com")
            label.sd_setImageWithURL(req!, placeholderImage: UIImage(named: "default"), completed: { (image: UIImage!, err: NSError!, type:SDImageCacheType, url:NSURL!) -> Void in
                if err == nil {
                  wiamge?.contentMode = .ScaleAspectFill
                 
                }
                 wiamge?.backgroundColor = UIColor.whiteColor()
            })
        }
    }
    
    func changeColor(){
        
        label.backgroundColor = UIColor.blueColor()
    }
}


class CommonHeadView: UICollectionReusableView {
    
    typealias Block = ()->Void
    
    var  tap: Block?
    var iconImage:UIImageView!
    func attirbute(titleImage:UIImage,tap:Block){
        
        self.tap = tap
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        self.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        let topView = UIView()
        topView.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[topView]|", options: [], metrics: nil, views: ["topView":topView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[topView]-0.5-|", options: [], metrics: nil , views: ["topView":topView]))
        
        
        let label = UIButton(type: .Custom)
        label.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
        label.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        label.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -92)
        label.setTitleColor(Profile.rgb(153, g: 153, b: 153), forState: .Normal)
        label.titleLabel?.font = Profile.font(11)
        label.setTitle("查看更多", forState: .Normal)
        label.addTarget(self, action: "searchMore", forControlEvents: .TouchUpInside)
        label.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(label)
        
        topView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[label]-15-|", options: [], metrics: nil , views: ["label":label]))
        topView.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        
        iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImage)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
    }
    
    func iconImage(name:String?){
    
       iconImage.image = UIImage(named: name!)
    }
    
    func searchMore(){
        tap!()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CollectionNewCell: UICollectionViewCell {
    let contentImage:UIImageView
    let titleL:UILabel
    let contentL:UILabel
    let timeL:UILabel
    
    override init(frame: CGRect) {
        
        contentImage = UIImageView()
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        contentImage.image = UIImage(named: "default")
        contentImage.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        contentL = UILabel()
        contentL.translatesAutoresizingMaskIntoConstraints = false
        
        
        timeL = UILabel()
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        self.contentView.addSubview(contentImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[contentImage]", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[contentImage]-10-|", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: contentImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentImage, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        
        
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentImage]-20-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"contentImage":contentImage]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: contentImage))
        titleL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
        self.contentView.addSubview(contentL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
//        self.contentView.addConstraint(NSLayoutConstraint(item: contentL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL,"titleL":titleL]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-7-[contentL]-5-|", aView: titleL, bView: contentL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentL]-15-|", options: [], metrics: nil, views: ["contentL":contentL]))
        
        
        
        timeL.textColor = Profile.rgb(191, g: 191, b: 191)
        timeL.font = Profile.font(12)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-(>=3)-[timeL]-15-|", options: [], metrics: nil, views: ["titleL":titleL,"timeL":timeL]))
//        timeL.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
    }
    
    func fillData(data:NewsData)
    {
//        weak var wimage = contentImage
//        contentImage.sd_setImageWithURL(NSURL(string: data.imageUrl!)!, placeholderImage: UIImage(named: "default"), completed: { (let image:UIImage!,err:NSError!, type:SDImageCacheType, url:NSURL!) -> Void in
//            if err == nil
//            {
//                wimage?.contentMode = .ScaleToFill
//            }
//        })

        contentImage.sd_setImageWithURL(NSURL(string: data.imageUrl!), placeholderImage: UIImage(named: "default"))
        titleL.text = data.title
        contentL.text = data.content
        timeL.text = data.time
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class AdRootCollectionView: UICollectionReusableView {
    
    typealias Blok = (link:String) ->Void
    var tapBlock:Blok!
    let scrollV:RepeatScrollView
    var imageArr:[PicData]?
    func loadData(imageData:[PicData]?,tapBlock:Blok?){
        
        
        if tapBlock != nil && imageData != nil
        {
            self.tapBlock = tapBlock!
            self.imageArr = imageData
            scrollV.setDataSource(self.imageArr)
        }
    }
    
    override init(frame: CGRect) {
        
        
        scrollV = RepeatScrollView(frame: CGRectMake(0,0,frame.width,frame.height))
    
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(scrollV);
        scrollV.setAutoRepeat()
        weak var wself = self
        scrollV.setTapCallBack { (index:Int,data:RepeatScrollProtocol!) -> Void in
            
            if let imageData = data as? PicData
            {
              if wself!.tapBlock != nil
              {
                    wself!.tapBlock(link: imageData.id!)
                }
             
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class CollectionActView: UICollectionViewCell {
    
//    let timeL:UILabel
//    let dateL:UILabel
    
    let titleL:UILabel
    let introduce:UILabel
//    let address:UILabel
//    let spot : UIView
    override init(frame: CGRect) {
        
      
//        timeL = UILabel()
//        timeL.font = Profile.font(11)
//        timeL.translatesAutoresizingMaskIntoConstraints = false
//        
//        dateL = UILabel()
//        dateL.font = Profile.font(10)
//        dateL.translatesAutoresizingMaskIntoConstraints = false
        
        titleL = UILabel()
        titleL.font = Profile.font(13)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        introduce = UILabel()
        introduce.font = Profile.font(15)
        introduce.translatesAutoresizingMaskIntoConstraints = false
        
//        address = UILabel()
//        address.font = Profile.font(10)
//        address.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        spot = UIView()
        super.init(frame: frame)
        
        self.contentView.addSubview(titleL)
        self.contentView.addSubview(introduce)
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        titleL.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(introduce, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-30-[introduce]-15-|", options: [], metrics: nil, views: ["introduce":introduce,"titleL":titleL]))
        self.backgroundColor = UIColor.whiteColor()

        
        
        
        
//        timeL.textColor = Profile.rgb(51, g: 51, b: 51)
//        timeL.font = Profile.font(15)
//        self.contentView.addSubview(timeL)
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
//        self.contentView.addConstraint(NSLayoutConstraint(item: timeL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -15))
        
        
//        let upView = UIView()
//        upView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(upView)
//        upView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:|-0-[upView]-0-|", aView: upView, bView: nil))
//         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-74-[upView(0.5)]", options: [], metrics: nil, views: ["upView":upView,"timeL":timeL]))
//
//        
//        spot.layer.masksToBounds = true
//        spot.layer.cornerRadius = 4.0
//        
//        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
//        spot.translatesAutoresizingMaskIntoConstraints = false
//        self.contentView.addSubview(spot)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-70-[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
//        
//        
//        dateL.textColor = Profile.rgb(153, g: 153, b: 153)
//        dateL.font = Profile.font(13)
//
//        self.contentView.addSubview(dateL)
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-17-[dateL]", options: [], metrics: nil, views: ["dateL":dateL]))
//        self.contentView.addConstraint(NSLayoutConstraint(item: dateL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 10))
        
//        
//        introduce.textColor = Profile.rgb(102, g: 102, b: 102)
//        introduce.font = Profile.font(13)
//        self.contentView.addSubview(introduce)
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-40-[introduce]-(>=2)-|", options: [], metrics: nil, views: ["introduce":introduce,"timeL":timeL]))
//        
//        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(introduce, toItem: self.contentView))
//        introduce.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
//        
//        
//        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
//        titleL.font = Profile.font(15)
//        self.contentView.addSubview(titleL)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(titleL, toItem: introduce))
//        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -7))
//        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[titleL]-(>=15)-|", aView: titleL, bView: nil))
//         titleL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
//        
//        
//        
//        address.textColor = Profile.rgb(153, g: 153, b: 153)
//        address.font = Profile.font(13)
//        self.contentView.addSubview(address)
//        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(address, toItem: introduce))
//        self.contentView.addConstraint(NSLayoutConstraint(item: address, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
        
        
        
        
    }
    
    
    func fullDataToCell(data:SchedulerData){
        
//        if data.type == .PublicMeeting || data.type == .UnPublicMeeting
//        {
//            spot.backgroundColor = Profile.rgb(110, g: 233, b: 194)
//        }
//        else if data.type == .UnPublicDiscuss || data.type == .PublicDiscuss
//        {
//            spot.backgroundColor = Profile.rgb(193, g: 129, b: 220)
//        }
//        else
//        {
//            spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
//        }
//
//        
//        timeL.text = data.time
//        dateL.text = data.date
        titleL.text = "\(data.date) \(data.time)"
        introduce.text = data.title
//        address.text = data.address
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ActiCollectionCell_One: UICollectionViewCell {
    let titleL:UILabel
    let detailL:UILabel
    let iconView:UIImageView
    override init(frame: CGRect) {
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        detailL = UILabel()
        detailL.translatesAutoresizingMaskIntoConstraints = false
        detailL.font = Profile.font(11)
        detailL.textColor = Profile.rgb(102, g: 102, b: 102)
        iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        self.contentView.addSubview(titleL)
        self.contentView.addSubview(detailL)
        self.contentView.addSubview(iconView)
        self.setSubViewLayout()
        self.contentView.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViewLayout(){
    
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconView(44)]-15-|", options: [], metrics: nil, views: ["iconView":iconView]))
       self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
       self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(iconView, toItem: self.contentView))
        
        
        titleL.font = Profile.font(13)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: -1))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        
    
        self.contentView.addConstraint(NSLayoutConstraint(item: detailL, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 1))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(detailL, toItem: titleL))
    }
    
    
    func setActivityData(acti:ActivityData){
    
       titleL.textColor = acti.color
       titleL.text = acti.name
        if acti.iconUrl != nil
        {
          iconView.sd_setImageWithURL(NSURL(string: acti.iconUrl!), placeholderImage: nil)
        }
       detailL.text = acti.detail
    }
    
}

class ActiCollectionCell_Two: ActiCollectionCell_One
{
    
    override func setSubViewLayout(){
//    self.backgroundColor = UIColor.redColor()
        titleL.font = Profile.font(13)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconView(44)]-15-|", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(iconView, toItem: self.contentView))

        
        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: -1))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[titleL]", aView: titleL, bView: nil))
        
        
        self.contentView.addConstraint(NSLayoutConstraint(item: detailL, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1, constant: 1))
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(detailL, toItem: titleL))
 
    }
}


class ActiCollectionCell_Three: ActiCollectionCell_One
{
    override func setSubViewLayout(){
        
        titleL.font = Profile.font(12)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(iconView, toItem: self.contentView))

        
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(titleL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[iconView]-8-[titleL]", aView: iconView, bView: titleL))
        
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(detailL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-1-[detailL]", aView: titleL, bView: detailL))

        
    }
}



class ActiCollectionCell_Fourth: ActiCollectionCell_One
{
    override func setSubViewLayout(){
        
        titleL.font = Profile.font(12)
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-9-[iconView(44)]", options: [], metrics: nil, views: ["iconView":iconView]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(iconView, toItem: self.contentView))
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutHorizontalCenter(titleL, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[iconView]-8-[titleL]", aView: iconView, bView: titleL))
        
         detailL.removeFromSuperview()
        
        
    }
    
    override func setActivityData(acti: ActivityData) {
       
            titleL.text = acti.name
            if acti.iconUrl != nil
            {
                iconView.sd_setImageWithURL(NSURL(string: acti.iconUrl!), placeholderImage: nil)
            }
            detailL.text = acti.detail
        }
}

