//
//  ViewController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/10/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//ok

import UIKit
//#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//typealias SCREENHEIGHT 
class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    var collection:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if false
            print("ok le")
        #else
            print("haole ")
        #endif
        let a = 10
        print(a)
//        NSLog("tao\(a)")
        self.view.backgroundColor = Profile.rgb(240, g: 0, b: 0)
        
        let flowLayout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: CGRectMake(0, 20, Profile.width(), Profile.height()),
         collectionViewLayout: flowLayout)
        collection.alwaysBounceVertical = true
        collection.registerClass(CommonHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CommonHeadView")
        collection.registerClass(commonCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.greenColor()
        self.view.addSubview(collection)
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(Profile.width()/2-1, 20);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
     
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(Profile.width(), 10)
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: "CommonHeadView", forIndexPath: indexPath)
        return head
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


class commonCell: UICollectionViewCell {
    
    let label:UILabel
    
    override init(frame: CGRect) {
        
        
        label = UILabel(frame: CGRectMake(0,0,frame.size.width,frame.size.height))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.blueColor()
        
        
        super.init(frame: frame)
        self.contentView.addSubview(label)
        
        
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]-0-|", options: [], metrics: nil , views: ["label":label])
        
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]|", options: [], metrics: nil, views: ["label":label])

        self.contentView.addConstraints(h)
        self.contentView.addConstraints(v)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeColor(){
    
      label.backgroundColor = UIColor.blueColor()
    }
    
}

class CommonHeadView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let topView = UIView()
        topView.backgroundColor = UIColor.brownColor()
        self.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[topView]|", options: [], metrics: nil, views: ["topView":topView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topView]|", options: [], metrics: nil , views: ["topView":topView]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
