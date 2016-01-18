//
//  ViewController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/10/28.
//  Copyright © 2015年 miaomiao. All rights reserved.
//ok

import UIKit
class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    var userNet:NetWorkData!
    var net:NetWorkData!
    var pics:[PicData]!
    var news:[NewsData]!,exhibitor:[ExhibitorData]!,scheduler:[SchedulerData]!,activityArr:[ActivityData]!
    var refreshHeadView:THLRefreshView!
    var collection:UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
        
    func creatRightBar(){
        
        let rightBar = UIBarButtonItem(image: UIImage(named: "global_search"), style: .Plain, target: self, action: "showGlobalSearchVC")
        self.navigationItem.rightBarButtonItem = rightBar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
    }
    
    func showGlobalSearchVC(){
        
        let search = GlobalSearchVC()
        
        let nav = UINavigationController(rootViewController: search)
        
        self.presentViewController(nav, animated: true) { () -> Void in
            
        }
    }

    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        
        
        let flowLayout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: CGRectMake(0, 0, Profile.width(), Profile.height()),
        collectionViewLayout: flowLayout)
        collection.alwaysBounceVertical = true
        collection.registerClass(CommonHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CommonHeadView")
        collection.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        collection.registerClass(AdRootCollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AdRootCollectionView")
        
        
        collection.registerClass(CommonCell.self, forCellWithReuseIdentifier: "CommonCell")
        
        collection.registerClass(CollectionActView.self, forCellWithReuseIdentifier: "CollectionActView")
        collection.registerClass(ActiCollectionCell_One.self, forCellWithReuseIdentifier: "ActiCollectionCell_One")
        collection.registerClass(ActiCollectionCell_Two.self, forCellWithReuseIdentifier: "ActiCollectionCell_Two")
        collection.registerClass(ActiCollectionCell_Three.self, forCellWithReuseIdentifier: "ActiCollectionCell_Three")
         collection.registerClass(ActiCollectionCell_Fourth.self, forCellWithReuseIdentifier: "ActiCollectionCell_Fourth")
        collection.registerClass(CollectionNewCell.self, forCellWithReuseIdentifier: "CollectionNewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.view.addSubview(collection)
            
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: collection, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: collection, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0))
            
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collection]-0-|", options: [], metrics: nil, views: ["collection" : collection]))
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collection]-0-|", options: [], metrics: nil, views: ["collection" : collection]))
            
            
         self.creatRightBar()
         self.addHead()
            
         self.fetchUserData()

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func fetchUserData(){
    
        let user = UserData.shared
        if user.token != nil
        {
            userNet = NetWorkData()
            userNet.getUserInfo(user.token!) { (result, status) -> (Void) in
                
            }
            userNet.start()
        }
     }
    
    func fetchData(){
    
//        let loadView = THActivityView(activityViewWithSuperView: self.view)
        
        weak var wself = self
        net = NetWorkData()
        net.getRootData { (result, status) -> (Void) in
//            wself?.collection.headerEndRefreshing()
            wself?.refreshHeadView.endRefreshing()
//            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                 if result == nil
                 {
                    let warnV = THActivityView(string: "网络错误")
                    warnV.show()
                }
                else
                {
                      if let warnStr = result as? String
                      {
                        let warnView = THActivityView(string: warnStr)
                        warnView.show()
                      }
                }
                 return
            }
            
            guard let data = result as? (pics:[PicData], news:[NewsData],exhibitor:[ExhibitorData],scheduler:[SchedulerData],activityArr:[ActivityData])
                
                else{
                    return
                }
            
            wself?.pics = data.pics
            wself?.news = data.news
            wself?.exhibitor = data.exhibitor
            wself?.scheduler = data.scheduler
            wself?.activityArr = data.activityArr
            wself?.collection.reloadData()
            //            print(result)
        }
        net.start()
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
          return 0
        }
        if section == 1
        {
            if activityArr == nil
            {
                return 0
            }
            return activityArr.count
        }
        if section == 2
        {
            if exhibitor == nil
            {
                return 0
            }
          return exhibitor.count
        }
        else if section == 3
        {
            if scheduler == nil
            {
                return 0
            }
           return scheduler.count
        }
        else
        {
            if news == nil{ return 0}
                return news.count
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if indexPath.section == 1
        {
            switch  activityArr.count
            {
                case 1:
                return  CGSizeMake(Profile.width(), 60)
                
               case 2:
                return  CGSizeMake(Profile.width()/2-0.25, 60)
                
               case 3:
                return  CGSizeMake(Profile.width()/3 - 0.34, 100)
              default:
                
                
                let width = Profile.width()/4
                let f = width - floor(width)
                if indexPath.row/2 == 0
                {
                  return CGSizeMake(width - f , 83)
                }
                else
                {
                  return CGSizeMake(width + f , 83)
                }
            }
        }
        else if indexPath.section == 2
        {
//            展商
            let lenth = (Profile.width()-2)/5
           return CGSizeMake(lenth, lenth)
        }
        else if indexPath.section == 3
        {
//            活动
           return CGSizeMake(Profile.width(), 40)
        }
        else
        {
//            新闻
             return CGSizeMake(Profile.width(), 75)
        }
    }
    

//    垂直间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if section == 1 || section == 3
        {
          return 0.5
        }
        return 0
    }
    
//    水平间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        if section == 1 && activityArr != nil
        {
         if activityArr.count == 4
         {
             return 0.0
         }
         
        }
        return 0.5
    }
 //    内部间距
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//     
//        if section == 1
//        {
//            return UIEdgeInsetsZero
//          return UIEdgeInsetsMake(0, 10, 0, 0)
//        }
//        return UIEdgeInsetsZero
//    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    
        
        if indexPath.section == 1
        {
            let element =  activityArr[indexPath.row]
            if activityArr.count == 1
            {
               let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActiCollectionCell_One", forIndexPath: indexPath) as! ActiCollectionCell_One
                cell.setActivityData(element)
                return cell
            }
            else if activityArr.count == 2
            {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActiCollectionCell_Two", forIndexPath: indexPath) as! ActiCollectionCell_Two
                cell.setActivityData(element)
                return cell
            }
            else if activityArr.count == 3
            {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActiCollectionCell_Three", forIndexPath: indexPath) as! ActiCollectionCell_Three
                cell.setActivityData(element)
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActiCollectionCell_Fourth", forIndexPath: indexPath) as! ActiCollectionCell_Fourth
                cell.setActivityData(element)
                return cell
            }
            
        }
            

        else if indexPath.section == 2
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CommonCell", forIndexPath: indexPath) as! CommonCell
            
            let data = exhibitor[indexPath.row]
            cell.exhibitorID = data.id
            cell.setImageUrl(data.iconUrl)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
        else if indexPath.section == 3
        {
            let cell:CollectionActView = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionActView", forIndexPath: indexPath) as! CollectionActView
             cell.backgroundColor = UIColor.whiteColor()
                let data = scheduler[indexPath.row]
                cell.fullDataToCell(data)
                return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionNewCell", forIndexPath: indexPath) as! CollectionNewCell
            
            let new = news[indexPath.row]
            cell.fillData(new)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
}
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0
        {
          return CGSizeMake(Profile.width(),Profile.width()*0.4)
        }
        
         if section == 1
         {
            if activityArr == nil || activityArr.count==0
            {
                return CGSizeZero
            }

           return CGSizeMake(Profile.width(), 10)
         }
        else if section == 2
        {
            if exhibitor == nil || exhibitor.count==0
            {
                return CGSizeZero
            }
//            return exhibitor.count
        }
        else if section == 3
        {
            if scheduler == nil || scheduler.count==0
            {
                return CGSizeZero
            }
//            return scheduler.count
        }
        else
        {
            if news == nil || news.count==0{
                
                return CGSizeZero
            }
//            return news.count
        }

        
        return CGSizeMake(Profile.width(), 47)
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
        if indexPath.section == 0
        {
            let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "AdRootCollectionView", forIndexPath: indexPath) as! AdRootCollectionView

            weak var wself = self
            
            head.loadData(pics, tapBlock: { (link) -> Void  in
    
               wself?.collectionView(link, didSelectHeadView: indexPath)
            })
            return head
        }
            
        else if indexPath.section == 1
        {
           let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", forIndexPath: indexPath) 
           return head
        }
            
        else if indexPath.section == 2{
        
            weak var wself = self
            let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: "CommonHeadView", forIndexPath: indexPath) as! CommonHeadView
            head.tap = {()->Void in
                wself?.tabBarController?.selectedIndex = 1
            }
            head.iconImage("rootExhibitorHead")
            return head

        
        }
        else if indexPath.section == 3{
            
           weak var wself = self
           let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: "CommonHeadView", forIndexPath: indexPath) as! CommonHeadView
            head.tap = {()->Void in
              wself?.tabBarController?.selectedIndex = 2
            }
            head.iconImage("rootActivityHead")
           return head
        }
        else
        {
            weak var wself = self
            let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: "CommonHeadView", forIndexPath: indexPath) as! CommonHeadView
            head.tap = {()->Void in
                wself?.tabBarController?.selectedIndex = 3
            }
            head.iconImage("rootNewsHead")
            return head

        }
      
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1
        {
            let act = activityArr[indexPath.row]
            if act.name == "展位图"
            {
               let mapVC = ExhibitorMapVC()
                mapVC.hidesBottomBarWhenPushed = true
               self.navigationController?.pushViewController(mapVC, animated: true)
            }
            else if act.name == "精彩瞬间"
            {
                self.tabBarController?.selectedIndex = 3
            }
            else if act.name == "我的关注"
            {
                self.tabBarController?.selectedIndex = 4
            }
            else
            {
               let category = ExhibitorCategoryVC()
                category.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(category, animated: true)
            }
        }
        
       else if indexPath.section == 2
        {
            let data = exhibitor[indexPath.row]
            let exView = ExhibitorController()
            exView.title = data.name
            exView.id = data.id
            exView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(exView, animated: true)
        }
        else if indexPath.section == 3
        {
            let data = scheduler[indexPath.row]
            let schedulerInfo = SchedulerInfoVC()
            schedulerInfo.schedulerID = data.id
            schedulerInfo.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(schedulerInfo, animated: true)
        }
        else
        {
            let link = news[indexPath.row]
            let comment = CommonWebController(url:link.link)
            comment.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(comment, animated: true)
           
        }
    }
    
    func collectionView(link: String, didSelectHeadView indexPath: NSIndexPath) {
//        print(link)
        
        let comment = CommonWebController(url:link)
        comment.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    func addHead(){
    
        weak var wself = self
        
        refreshHeadView = THLRefreshView()
        refreshHeadView.isManuallyRefreshing = true
        refreshHeadView.addToScrollView(collection);
       
        refreshHeadView.setBeginRefreshBlock { () -> Void in
            wself?.fetchData()
        }
        
    }
    

    deinit{
      net = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



class CommonWebController:UIViewController,UIWebViewDelegate {
    var readLocal:Bool = false
    var loadV:THActivityView!
    var webHtml:String?
    var webLink:String?
    init(url:String?){
       webLink = url
       super.init(nibName: nil, bundle: nil)
    }
    
    
    init(bodyHtml:String){
      webHtml = bodyHtml
      super.init(nibName: nil, bundle: nil)
        
    }
    init(html:String?)
    {
        webHtml = html
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        let web = UIWebView()
        web.delegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(web)
        loadV = THActivityView(activityViewWithSuperView: self.view)
        if webLink != nil
        {
          if let url = NSURL(string: webLink!)
          {
            web.loadRequest( NSURLRequest(URL: url))
          }
          
        }
        if webHtml != nil
        {
          web.loadHTMLString(webHtml!, baseURL: nil)
        }
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(web))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(web))
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

