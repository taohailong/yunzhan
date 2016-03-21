//
//  ExhibitorController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/3.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
//typealias ExhibitorData = (urlIcon:String,idNu:String,name:String,address:String)

class Exhibitor: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,PopViewProtocol {
    
    var net:NetWorkData!
    var table:UITableView!
    var refreshHeadV:THLRefreshView!
    var dataArr: [[ExhibitorData]]!
    var searchArr:[ExhibitorData]?
    var searchCV:UISearchDisplayController!
    var prefixArr:[String]?
    var typeArr:[(typeID:String,typeName:String)] = [("0","全部")]
    var selectType:Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavgationBarAttribute(true)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavgationBarAttribute(false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       返回按钮去掉文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: nil, action: "")
        self.title = "展商"

        self.creatTable()
        self.setupRefresh()
        self.creatRightNavBar()
        self.creatLeftNavBar(false)
    }
    
    func creatRightNavBar(){
        
        let rightBar = UIBarButtonItem(image: UIImage(named: "global_search"), style: .Plain, target: self, action: "showGlobalSearchVC")
        self.navigationItem.rightBarButtonItem = rightBar
    }

    
    func creatLeftNavBar(needRotate:Bool){
    
        let leftBt = UIButton(type: .Custom)
        leftBt.titleLabel?.font = Profile.font(15)
        leftBt.setTitle(self.typeArr[selectType].typeName, forState: .Normal)
        
        let title:NSString = leftBt.currentTitle!
        let sizeTitle = title.sizeWithAttributes([NSFontAttributeName:(leftBt.titleLabel?.font)!])
        var narrow = UIImage(named: "narrow_white")
        if needRotate
        {
            narrow =  narrow?.rotationImage(.Left)
        }
        else
        {
            
        }
        leftBt.setImage(narrow, forState: .Normal)
        leftBt.addTarget(self, action: "changeDataType", forControlEvents: .TouchUpInside)

    
        let sizeImage = leftBt.currentImage!.size
    
        leftBt.imageEdgeInsets = UIEdgeInsetsMake(0, sizeTitle.width+5, 0, 0)
        leftBt.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, sizeImage.width)
        leftBt.frame = CGRectMake(0, 0,15 + sizeTitle.width  , 35)
        
        let leftBar = UIBarButtonItem(customView:  leftBt)
        self.navigationItem.leftBarButtonItem = leftBar
    
        if needRotate
        {
            self.navigationItem.leftBarButtonItem!.tag = 1
        }
        else
        {
            self.navigationItem.leftBarButtonItem!.tag = 0
        }
        
    }
    
    
      //    MARK:PopViewDelegate
    
    func changeDataType(){
        
        self.creatLeftNavBar(true)
        
        let contentArr = typeArr.flatMap { (let element:(typeID: String, typeName: String)) -> (image: String?, title: String)? in
           return (nil,element.typeName)
        }
        
        let popV = PopView(contents: contentArr, showViewFrame: CGRectMake(20, 64, 120, 150), trangleX:20)
        popV.selectCellColor = Profile.NavBarColorGenuine
        popV.cellTextAlignment = .Center
        popV.selectIndex = selectType
        popV.delegate = self
        self.tabBarController?.view.addSubview(popV)
    }
    
    
  
    func popViewDidSelect(index: Int) {
        
         selectType = index
         self.fetchExhibitorData(self.typeArr[self.selectType].typeID)
    }
    
    
    func popViewDismissed() {
        
        self.creatLeftNavBar(false)
    }
    
    
    
    
    func showGlobalSearchVC(){
    
       let search = GlobalSearchVC()
        let nav = UINavigationController(rootViewController: search)
        self.presentViewController(nav, animated: true) { () -> Void in
            
        }
    }
    
    func creatTable(){
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = Profile.rgb(243, g: 243, b: 243)
        table.sectionIndexBackgroundColor = UIColor.clearColor()
        
        self.view.addSubview(table)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[table]-0-|", options: [], metrics: nil, views: ["table":table]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[tableView]-49-|", options: [], metrics: nil, views: ["tableView":table]))
        
        
        
        table.registerClass(TableNoSeparateHeadView.self, forHeaderFooterViewReuseIdentifier: "TableNoSeparateHeadView")
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
       
    }
    
    
    func setupRefresh(){
        
         weak var wself = self
        refreshHeadV = THLRefreshView(frame: CGRectMake(0,0,Profile.width(),65))
        refreshHeadV.isManuallyRefreshing = true
        refreshHeadV.addToScrollView(table)
        refreshHeadV.setBeginRefreshBlock { () -> Void in
           wself?.fetchExhibitorData(wself!.typeArr[wself!.selectType].typeID)
        }
    }
    
    
    func fetchExhibitorData(typeID:String){

        weak var wself = self
        net = NetWorkData()
        net.getExhibitorList(typeID) { (result, status) -> (Void) in
         
            wself?.refreshHeadV.endRefreshing()
            
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
            
            guard let list = result as? (prefixArr:[String],list:[[ExhibitorData]],typeArr:[(typeID:String,typeName:String)])
                else{
                    return
            }
            wself?.dataArr = list.list
            wself?.typeArr = list.typeArr
            wself?.prefixArr = list.prefixArr
            wself?.typeArr.insert(("0","全部"), atIndex: 0)
            wself?.table.reloadData()
            
        }

        net.start()
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if table != tableView
        {
          return 1
        }
        if dataArr == nil
        {
          return 0
        }
        return (prefixArr?.count)!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
        if tableView != table
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView != table
        {
            return 0.0
        }
        if  dataArr[section].count == 0
        {
            return 0.0
        }
        return 25

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView != table
        {
            return nil
        }
        if  dataArr[section].count == 0
        {
            return nil
        }
        
        let head = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableNoSeparateHeadView") as! TableNoSeparateHeadView
        head.contentView.backgroundColor = Profile.rgb(243, g: 243, b: 243)
        head.contentL.text = prefixArr![section]
        
        return head

    }
    
    
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =  table.dequeueReusableCellWithIdentifier("ExhibitorCell") as! ExhibitorCell
        
        var cellData:ExhibitorData!
        if tableView !=  self.table
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
//    print(NSStringFromUIEdgeInsets(self.tableView.contentInset))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cellData:ExhibitorData!
        if tableView !=  self.table
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
    
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return prefixArr
    }// return list of section titles to display in section index view (e.g. "ABCD...Z#")
   
    
    
     func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
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
        titleL.font = Profile.font(16)
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
        addressL.text = data.location
//        name.text = data.remark
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


