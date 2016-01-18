//
//  ExhibitorAdvertisement.swift
//  yunzhan
//
//  Created by 陶海龙 on 16/1/14.
//  Copyright © 2016年 miaomiao. All rights reserved.
//

import Foundation
class ExhibitorCategoryVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let net = NetWorkData()
    var collection: UICollectionView!
    var dataArr = [[String:AnyObject]]()
    override func viewDidLoad() {
      super.viewDidLoad()
        self.title = "展商须知"
        self.view.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.automaticallyAdjustsScrollViewInsets = false
        let flowLayout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: CGRectMake(0, 0, Profile.width(), Profile.height()),
            collectionViewLayout: flowLayout)
        collection.alwaysBounceVertical = true
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        collection.registerClass(ExhibitorCollectionCell.self , forCellWithReuseIdentifier: "ExhibitorCollectionCell")
        self.view.addSubview(collection)
        
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: collection, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: collection, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collection]-0-|", options: [], metrics: nil, views: ["collection" : collection]))
      
        self.fetchAdvertiseData()
    }
    
    func fetchAdvertiseData(){
    
      weak var wself = self
      let load = THActivityView(activityViewWithSuperView: self.view)
        
      net.exhibitorAdvertiseCategory { (result, status) -> (Void) in
          load.removeFromSuperview()
        if status == .NetWorkStatusError
        {
            return
        }
        
        if let data = result as? [[String:AnyObject]]
        {
            wself?.dataArr = data
            wself?.collection.reloadData()
        }
        
      }
        net.start()
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0, 0)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
        return CGSizeMake(Profile.width()/2.0, 70)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ExhibitorCollectionCell", forIndexPath: indexPath) as! ExhibitorCollectionCell
        
        cell.separateC.hidden = false
        let dic = dataArr[indexPath.row]
        if let code = dic["code"] as? String
        {
            var imageN = ""
           switch code
           {
            case "1":
            imageN = "exhibitor_ad_1"
           case "2":
            imageN = "exhibitor_ad_2"

           case "3":
            imageN = "exhibitor_ad_3"

           case "4":
            imageN = "exhibitor_ad_4"

           case "5":
            imageN = "exhibitor_ad_5"

           case "6":
            imageN = "exhibitor_ad_6"

           case "7":
            imageN = "exhibitor_ad_7"
           default:
            imageN = ""
            }
            cell.titleLabel.text = dic["title"] as? String
            cell.iconImage.image = UIImage(named: imageN)
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        // 项目编号, 1: 组委会和重要联系人, 2: 报到安排, 3: 布展须知, 5: 展馆交通线路, 6: 展品运输线路, 7: 展览馆、停车位分布图
        let dic = dataArr[indexPath.row]
        let title = dic["title"] as? String
        
        var controller:UIViewController? = nil
        if let code = dic["code"] as? String
        {
//            if code == "1"
//            {
//                controller = ExhibitorContactVC()
//            }
//            else
//            {
                controller = ExhibitorAdWebController(bodyHtml: code)
//            }
        }
        controller?.title = title
         self.navigationController?.pushViewController(controller!, animated: true)
     }
    
}

class ExhibitorCollectionCell: UICollectionViewCell {
    
    let iconImage:UIImageView
    let titleLabel:UILabel
    let separateC:UIView
    override init(frame: CGRect) {
        
        iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.font = Profile.font(13)
        titleLabel.textColor = Profile.rgb(51, g: 51, b: 51)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        separateC = UIView()
        separateC.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        separateC.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(iconImage)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(iconImage, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:|-15-[iconImage]", aView: iconImage, bView: nil))
        
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleLabel, toItem: self.contentView))
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[iconImage]-10-[titleLabel]", aView: iconImage, bView: titleLabel))
        
        
        
        self.contentView.addSubview(separateC)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[separateC]-10-|", options: [], metrics: nil, views: ["separateC":separateC]))

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[separateC(0.5)]-0-|", options: [], metrics: nil, views: ["separateC":separateC]))
        separateC.hidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}