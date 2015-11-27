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
    var news:[NewsData]!,exhibitor:[ExhibitorData]!,scheduler:[SchedulerData]!
    
    var collection:UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
    func setNavgationBarAttribute(change:Bool)
    {
        if change == true
        {
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.LightContent, animated: true)
        }
        else
        {
            if self.navigationController?.viewControllers.count == 1
            {
                return
            }
            self.navigationController?.navigationBar.tintColor = Profile.rgb(102, g: 102, b: 102)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:Profile.font(18)]
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
            let application = UIApplication.sharedApplication()
            application.setStatusBarStyle(.Default, animated: true)
        }
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
            
         self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-1")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.image = UIImage(named: "root-1_selected")
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
            
        

        self.view.backgroundColor = Profile.rgb(240, g: 0, b: 0)
        
        let flowLayout = UICollectionViewFlowLayout()
        collection = UICollectionView(frame: CGRectMake(0, 0, Profile.width(), Profile.height()),
         collectionViewLayout: flowLayout)
        collection.alwaysBounceVertical = true
        collection.registerClass(CommonHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CommonHeadView")
        
        collection.registerClass(AdRootCollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AdRootCollectionView")
        
        
        collection.registerClass(CommonCell.self, forCellWithReuseIdentifier: "CommonCell")
        
        collection.registerClass(CollectionActView.self, forCellWithReuseIdentifier: "CollectionActView")
        
        collection.registerClass(CollectionNewCell.self, forCellWithReuseIdentifier: "CollectionNewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        self.view.addSubview(collection)
            
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(collection))
            self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(collection))
            
            
            
//         self.addRefreshTableHead()
            self.addHead()
            
         self.fetchUserData()
//         self.fetchData()
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
            wself?.collection.headerEndRefreshing()
//            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                 if result == nil
                 {
                    let errView = THActivityView(netErrorWithSuperView: wself!.view)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchData()
                        werr?.removeFromSuperview()
                    })
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
            
            guard let data = result as? (pics:[PicData], news:[NewsData],exhibitor:[ExhibitorData],scheduler:[SchedulerData])
                
                else{
                    return
                }
            
            wself?.pics = data.pics
            wself?.news = data.news
            wself?.exhibitor = data.exhibitor
            wself?.scheduler = data.scheduler
            
            wself?.collection.reloadData()
            //            print(result)
        }
        net.start()
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
          return 0
        }
        if section == 1
        {
            if exhibitor == nil
            {
                return 0
            }
          return exhibitor.count
        }
        else if section == 2
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
            let lenth = (Profile.width()-2)/5
           return CGSizeMake(lenth, lenth)
        }
        else if indexPath.section == 2
        {
//            活动
           return CGSizeMake(Profile.width(), 90)
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
        return 0.5
    }
     
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
    
        if indexPath.section == 1
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CommonCell", forIndexPath: indexPath) as! CommonCell
            
            let data = exhibitor[indexPath.row]
            cell.exhibitorID = data.id
            cell.setImageUrl(data.iconUrl)
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }
        else if indexPath.section == 2
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
        if section == 0{
        
          return CGSizeMake(Profile.width(),Profile.width()*0.4)
        }
        
        if section == 1
        {
            if exhibitor == nil || exhibitor.count==0
            {
                return CGSizeZero
            }
//            return exhibitor.count
        }
        else if section == 2
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
        else if indexPath.section == 1{
        
            weak var wself = self
            let head = collection.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader , withReuseIdentifier: "CommonHeadView", forIndexPath: indexPath) as! CommonHeadView
            head.tap = {()->Void in
                wself?.tabBarController?.selectedIndex = 1
            }
            head.iconImage("rootExhibitorHead")
            return head

        
        }
        else if indexPath.section == 2{
            
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
            let data = exhibitor[indexPath.row]
            let exView = ExhibitorController()
            exView.title = data.name
            exView.id = data.id
            exView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(exView, animated: true)
        }
        else if indexPath.section == 2
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
        print(link)
        
        let comment = CommonWebController(url:link)
        comment.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    func addHead(){
    
        weak var wself = self
        collection.addHeaderWithCallback { () -> Void in
            wself?.fetchData()
        }
        collection.headerBeginRefreshing()
    
    }
    
    
    
//    func addRefreshTableHead()
//    {
//    // 加入refreshView;
//      let refreshRect = CGRectMake(0,
//       0 - collection.bounds.size.height,
//       collection.bounds.size.width,
//       collection.bounds.size.height);
//    
//       refreshView = EGORefreshTableHeaderView(frame: refreshRect)
//       refreshView.delegate = self;
//        refreshView.scrollEdge = collection.contentInset
//       collection.addSubview(refreshView)
//    /* 刷新一次数据 */
////       refreshView.refreshLastUpdatedDate()
//    
//    }
//    
//    func egoRefreshTableHeaderDidTriggerRefresh(view: EGORefreshTableHeaderView!) {
//        
//    //    if (isLoading) {
//    //        return;
//    //    }
//    /* 开始更新代码放在这里 */
//      self.fetchData()
//    
//    /* 实现更新代码 */
//    
//    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//       refreshView.egoRefreshScrollViewDidEndDragging(scrollView)
//    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//       refreshView.egoRefreshScrollViewDidScroll(scrollView)
//    }
    

    
    
    deinit{
      net = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



class CommonWebController:UIViewController {
    var webHtml:String?
    var webLink:String?
    init(url:String?){
       webLink = url
       super.init(nibName: nil, bundle: nil)
    }
    
    init(html:String?)
    {
       webHtml = html
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        let web = UIWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(web)
        
        if webLink != nil
        {
          web.loadRequest( NSURLRequest(URL: NSURL(string: webLink!)!))
        }
        if webHtml != nil
        {
          web.loadHTMLString(webHtml!, baseURL: nil)
        }
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(web))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(web))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

