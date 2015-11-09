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
        label.contentMode = .ScaleAspectFit
        
        
        super.init(frame: frame)
        self.contentView.addSubview(label)
        
        
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]-0-|", options: [], metrics: nil , views: ["label":label])
        
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[label]-5-|", options: [], metrics: nil, views: ["label":label])
        
        self.contentView.addConstraints(h)
        self.contentView.addConstraints(v)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageUrl(url:String){
        let req = NSURL(string: url)

      label.sd_setImageWithURL(req!, placeholderImage: nil)
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
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[topView]-0.5-|", options: [], metrics: nil , views: ["topView":topView]))
        
        
        let label = UIButton(type: .Custom)
        label.setImage(UIImage(named: "narrowLeft"), forState: .Normal)
        label.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        label.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -90)
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
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[iconImage]", options: [], metrics: nil, views: ["iconImage":iconImage]))
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
//        titleL.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        titleL.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        
        contentL.textColor = Profile.rgb(153, g: 153, b: 153)
        contentL.font = Profile.font(12)
        contentL.numberOfLines = 0
        self.contentView.addSubview(contentL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(contentL, toItem: titleL))
//        self.contentView.addConstraint(NSLayoutConstraint(item: contentL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleL]-5-[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL,"titleL":titleL]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("V:[titleL]-5-[contentL]-5-|", aView: titleL, bView: contentL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentL]-5-|", options: [], metrics: nil, views: ["contentL":contentL]))
        
        
        
        timeL.textColor = Profile.rgb(191, g: 191, b: 191)
        timeL.font = Profile.font(11)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: timeL))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-(>=1)-[timeL]-15-|", options: [], metrics: nil, views: ["titleL":titleL,"timeL":timeL]))
//        timeL.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
    }
    
    func fillData(data:NewsData)
    {
        contentImage.sd_setImageWithURL(NSURL(string: data.imageUrl!), placeholderImage: nil)
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
    
    var imageArr:[PicData]?
    var scroll: UIScrollView!
    
    func loadData(imageData:[PicData]?,tapBlock:Blok?){
        
        if scroll != nil{ return}
        
        if tapBlock != nil && imageData != nil
        {
            self.tapBlock = tapBlock!
            self.imageArr = imageData
        }
            
        else
        {
            return
        }
        scroll = UIScrollView(frame: CGRectMake(0,0,CGRectGetWidth(frame),CGRectGetHeight(frame)))
        
        scroll.pagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        self.addSubview(scroll)
        self.creatImageView()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    
    func creatImageView(){
        
        var frame = CGRectMake(0,0,CGRectGetWidth(scroll.bounds),CGRectGetHeight(scroll.bounds))
        
        var i = 0
        for (index ,imageData) in imageArr!.enumerate(){
            
            let image = UIImageView(frame: frame)
            image.tag = index
            scroll.addSubview(image)
            
            image.sd_setImageWithURL(NSURL(string: imageData.url),  placeholderImage:UIImage(named: "AdRootDeault") )
            frame = CGRectMake(frame.origin.x + frame.size.width, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))
            image.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: "imageTap:")
            image.addGestureRecognizer(tap)
            i = index
        }
        
        scroll.contentSize = CGSizeMake(scroll.bounds.size.width * CGFloat(i+1), scroll.bounds.height)
    }
    
    func imageTap(let tap:UITapGestureRecognizer){
        
        let tag = tap.view?.tag
        let imageData = imageArr![tag!]
        tapBlock(link: imageData.url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class CollectionActView: UICollectionViewCell {
    
    let timeL:UILabel
    let dateL:UILabel
    
    let titleL:UILabel
    let introduce:UILabel
    let address:UILabel
    
    override init(frame: CGRect) {
        
      
        timeL = UILabel()
        timeL.font = Profile.font(10)
        timeL.translatesAutoresizingMaskIntoConstraints = false
        
        dateL = UILabel()
        dateL.font = Profile.font(10)
        dateL.translatesAutoresizingMaskIntoConstraints = false
        
        titleL = UILabel()
        titleL.font = Profile.font(10)
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        introduce = UILabel()
        introduce.font = Profile.font(10)
        introduce.translatesAutoresizingMaskIntoConstraints = false
        
        address = UILabel()
        address.font = Profile.font(10)
        address.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        
        
        timeL.textColor = Profile.rgb(51, g: 51, b: 51)
        timeL.font = Profile.font(15)
        self.contentView.addSubview(timeL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
//         self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[timeL]", options: [], metrics: nil, views: ["timeL":timeL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: timeL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -15))
        
        
        
        
        let spot = UIView()
        spot.layer.masksToBounds = true
        spot.layer.cornerRadius = 4.0
        
        spot.backgroundColor = Profile.rgb(254, g: 167, b: 84)
        spot.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(spot)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(spot, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-15-[spot(8)]", options: [], metrics: nil, views: ["spot":spot,"timeL":timeL]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spot(8)]", options: [], metrics: nil, views: ["spot":spot]))
        
        
        dateL.textColor = Profile.rgb(153, g: 153, b: 153)
        dateL.font = Profile.font(13)

        self.contentView.addSubview(dateL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-17-[dateL]", options: [], metrics: nil, views: ["dateL":dateL]))
        self.contentView.addConstraint(NSLayoutConstraint(item: dateL, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 10))
        
        
        introduce.textColor = Profile.rgb(102, g: 102, b: 102)
        introduce.font = Profile.font(13)
        self.contentView.addSubview(introduce)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeL]-35-[introduce]-(>=2)-|", options: [], metrics: nil, views: ["introduce":introduce,"timeL":timeL]))
        
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(introduce, toItem: self.contentView))
        introduce.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        titleL.textColor = Profile.rgb(51, g: 51, b: 51)
        titleL.font = Profile.font(15)
        self.contentView.addSubview(titleL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(titleL, toItem: introduce))
        self.contentView.addConstraint(NSLayoutConstraint(item: titleL, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -5))
        
        address.textColor = Profile.rgb(153, g: 153, b: 153)
        address.font = Profile.font(13)
        self.contentView.addSubview(address)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(address, toItem: introduce))
        self.contentView.addConstraint(NSLayoutConstraint(item: address, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: introduce, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5))
    }
    
    
    func fullDataToCell(data:SchedulerData){
        print(data.time)
        timeL.text = data.time
        dateL.text = data.date
        titleL.text = data.title
        introduce.text = data.introduce
        address.text = data.address
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

