//
//  ExhibitorController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/3.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
//typealias ExhibitorData = (urlIcon:String,idNu:String,name:String,address:String)
class Exhibitor: UITableViewController,UISearchDisplayDelegate {
    
    var net:NetWorkData!
//    var table:UITableView!
    var dataArr: [[ExhibitorData]]!
    var searchArr:[ExhibitorData]?
    var searchCV:UISearchDisplayController!
    var prefixArr:[String]?
    
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
        
        
        self.title = "展商"
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-2_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        
        
//        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
//        table.delegate = self
//        table.dataSource = self
        self.tableView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
//        table.translatesAutoresizingMaskIntoConstraints = false
         self.tableView.separatorColor = Profile.rgb(243, g: 243, b: 243)
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
//        self.tableView.sectionIndexColor = Profile.NavBarColor()
        let searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width(),45))
        self.tableView.tableHeaderView = searchBar
        self.tableView.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
//        self.view.addSubview(table)
//        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
//        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refreshBegin", forControlEvents: .ValueChanged)
        
        searchCV = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchCV.searchResultsDelegate = self
        searchCV.searchResultsDataSource = self
        searchCV.delegate = self
//        searchCV.searchResultsTitle = "dd"
        self.fetchExhibitorData()
    }
    
    func refreshBegin(){
        
        self.fetchExhibitorData()
    }

    
    
    func fetchExhibitorData(){

//        self.refreshControl?.beginRefreshing()
        let loadView = THActivityView(activityViewWithSuperView: self.tableView.superview)
        weak var wself = self
        net = NetWorkData()
        net.getExhibitorList { (result, status) -> (Void) in
            
            wself?.refreshControl?.endRefreshing()
            loadView.removeFromSuperview()
            if status == .NetWorkStatusError
            {
                if result == nil
                {
                    let errView = THActivityView(netErrorWithSuperView: wself!.tableView.superview)
                    weak var werr = errView
                    errView.setErrorBk({ () -> Void in
                        wself?.fetchExhibitorData()
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
            
            guard let list = result as? (prefixArr:[String],list:[[ExhibitorData]])
                else{
              return
            }
            wself?.dataArr = list.list
//            print(list.list)
            wself?.prefixArr = list.prefixArr
            wself?.tableView.reloadData()
        }
        net.start()
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if  self.tableView != tableView
        {
          return 1
        }
        if dataArr == nil
        {
          return 0
        }
        return (prefixArr?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        if tableView !=  self.tableView
        {
            if searchArr == nil
            {
               return 0
            }
            return (searchArr?.count)!
        }
        let subArr = dataArr[section] 
        return subArr.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView != self.tableView
        {
          return nil
        }
        
        return prefixArr![section]
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  self.tableView.dequeueReusableCellWithIdentifier("ExhibitorCell") as! ExhibitorCell
        
        var cellData:ExhibitorData!
        if tableView !=  self.tableView
        {
            cellData = searchArr![indexPath.row]
        }
        else
        {
            let subArr = dataArr[indexPath.section]
            cellData = subArr[indexPath.row]
        }
        
        cell.fillData(cellData)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cellData:ExhibitorData!
        if tableView !=  self.tableView
        {
            cellData = searchArr![indexPath.row]
        }
        else
        {
            let subArr = dataArr[indexPath.section]
            cellData = subArr[indexPath.row]
        }

        let exhibitorCV = ExhibitorController()
        exhibitorCV.title = cellData.name
        exhibitorCV.id = cellData.id
        exhibitorCV.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(exhibitorCV, animated: true)
    }
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return prefixArr
    }// return list of section titles to display in section index view (e.g. "ABCD...Z#")
   
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        let s = prefixArr!.indexOf(title)
       return s!
    
    }// tell table which section corresponds to section title/index (e.g. "B",1)
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
        if let s = searchString where s.isEmpty == false
        {
           self.fetchSearchArr(s)
        }
       
        if searchArr == nil
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func fetchSearchArr(searchStr:String){
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            var allData = [ExhibitorData]()
            for subArr in self.dataArr
            {
                for temp in subArr
                {
                    allData.append(temp)
                }
            }
            let predicate = NSPredicate(format: "self contains %@",searchStr)
            
            let search = allData.filter({ (t) -> Bool in
                predicate.evaluateWithObject(t.name)
            })
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.searchArr = search
                self.searchCV.searchResultsTableView.reloadData()
            })
        }
    }
    
    deinit{
        net = nil
    }

    
}

class ExhibitorCell: UITableViewCell {
    
    let contentImage:UIImageView
    let titleL:UILabel
    let addressL:UILabel
    let name:UILabel
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        contentImage = UIImageView()
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        contentImage.image = UIImage(named: "default")
        contentImage.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        
        titleL = UILabel()
        titleL.translatesAutoresizingMaskIntoConstraints = false
        
        addressL = UILabel()
        addressL.font = Profile.font(11)
        addressL.translatesAutoresizingMaskIntoConstraints = false
        addressL.textColor = Profile.rgb(153, g: 153, b: 153)
        
        
        name = UILabel()
//        name.backgroundColor = UIColor.redColor()
        name.textColor = Profile.rgb(153, g: 153, b: 153)
        name.font = Profile.font(11)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(contentImage)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[contentImage]", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[contentImage]-10-|", options: [], metrics: nil, views: ["contentImage":contentImage]))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: contentImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentImage, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        
        
        
        
        self.contentView.addSubview(titleL)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[contentImage]-17-[titleL]", options: [], metrics: nil, views: ["titleL":titleL,"contentImage":contentImage]))
        self.contentView.addConstraint(NSLayoutConstraint.layoutTopEqual(titleL, toItem: contentImage))
        
        
        let locationV = UIImageView()
        locationV.image = UIImage(named: "exhibitorLocation")
        locationV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(locationV)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(locationV, toItem: titleL))
         self.contentView.addConstraint(NSLayoutConstraint(item: locationV, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        
        self.contentView.addSubview(addressL)
        self.contentView.addConstraints(NSLayoutConstraint.constrainWithFormat("H:[locationV]-10-[addressL]", aView: locationV, bView: addressL))
        self.contentView.addConstraint(NSLayoutConstraint(item: addressL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        
        
        self.contentView.addSubview(name)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: name))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-10-[name]-(>=1)-|", options: [], metrics: nil, views: ["name":name,"titleL":titleL]))
        

    }

    func fillData(data:ExhibitorData)
    {
        if data.iconUrl != nil
        {
            contentImage.sd_setImageWithURL(NSURL(string: data.iconUrl!)!, placeholderImage: UIImage(named: "default"))
        }
        titleL.text = data.name
        addressL.text = data.address
        name.text = data.remark
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


