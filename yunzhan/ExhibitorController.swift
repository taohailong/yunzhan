//
//  ExhibitorController.swift
//  yunzhan
//
//  Created by 陶海龙 on 15/11/3.
//  Copyright © 2015年 miaomiao. All rights reserved.
//

import Foundation
//typealias ExhibitorData = (urlIcon:String,idNu:String,name:String,address:String)
class Exhibitor: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate {
    
    var net:NetWorkData!
    var table:UITableView!
    var dataArr: [[ExhibitorData]]!
    var searchArr:[ExhibitorData]?
    var searchCV:UISearchDisplayController!
    var prefixArr:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Profile.NavTitleColor()]
        self.navigationController?.navigationBar.barTintColor = Profile.NavBarColor()
        
        self.title = "展商"
        
        self.navigationController?.tabBarItem.selectedImage = UIImage(named: "root-2_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationController?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Profile.NavBarColor()], forState: UIControlState.Selected)
        
        
        table = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let searchBar = UISearchBar(frame: CGRectMake(0,0,Profile.width(),45))
        table.tableHeaderView = searchBar
        table.registerClass(ExhibitorCell.self , forCellReuseIdentifier: "ExhibitorCell")
        self.view.addSubview(table)
        
        self.view.addConstraints(NSLayoutConstraint.layoutHorizontalFull(table))
        self.view.addConstraints(NSLayoutConstraint.layoutVerticalFull(table))
        
        
        searchCV = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchCV.searchResultsDelegate = self
        searchCV.searchResultsDataSource = self
        searchCV.delegate = self
//        searchCV.searchResultsTitle = "dd"
        self.fetchExhibitorData()
    }
    
    func fetchExhibitorData(){
    
//        let a0:ExhibitorData = ExhibitorData(address: "address", id: "123", name: "aima", iconUrl: "http://h.hiphotos.baidu.com/image/h%3D200/sign=db9f2e15edf81a4c3932ebc9e72b6029/b8389b504fc2d56252994c8ce11190ef76c66c3a.jpg", addressMap: "ddd", webLink: "dddd")
//        
//        let a2 = ExhibitorData(address: "address", id: "123", name: "aima", iconUrl: "http://h.hiphotos.baidu.com/image/h%3D200/sign=db9f2e15edf81a4c3932ebc9e72b6029/b8389b504fc2d56252994c8ce11190ef76c66c3a.jpg", addressMap: "ddd", webLink: "dddd")
//
//        dataArr = [[a0],[a0,a2],[a0],[a2],[a2],[a2,a0],[a2],[a2,a0]]
        weak var wself = self
        net = NetWorkData()
        net.getExhibitorList { (result, status) -> (Void) in
            
            if status == NetStatus.NetWorkStatusError
            {
            
            }
            
            guard let list = result as? (prefixArr:[String],list:[[ExhibitorData]])
                else{
              return
            }
            wself?.dataArr = list.list
            print(list.list)
            wself?.prefixArr = list.prefixArr
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
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView != table
        {
          return nil
        }
        
        return prefixArr![section]
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        let cell = table.dequeueReusableCellWithIdentifier("ExhibitorCell") as! ExhibitorCell
        
        var cellData:ExhibitorData!
        if tableView != table
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
        
        var cellData:ExhibitorData!
        if tableView != table
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
//        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
//     return ["\u{1F50D}","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    }// return list of section titles to display in section index view (e.g. "ABCD...Z#")
   
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
//        let arr = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
        let s = prefixArr!.indexOf(title)
       return s!
    
    }// tell table which section corresponds to section title/index (e.g. "B",1)
    
    
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//          }
    
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
    
    
}

class ExhibitorCell: UITableViewCell {
    
    let contentImage:UIImageView
    let titleL:UILabel
    let addressL:UILabel
    let name:UILabel
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        contentImage = UIImageView()
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        
        self.contentView.addSubview(addressL)
        self.contentView.addConstraint(NSLayoutConstraint.layoutLeftEqual(addressL, toItem: titleL))
        self.contentView.addConstraint(NSLayoutConstraint(item: addressL, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleL, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
        
        
        self.contentView.addSubview(name)
        self.contentView.addConstraint(NSLayoutConstraint.layoutVerticalCenter(titleL, toItem: name))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleL]-10-[name]-(>=1)-|", options: [], metrics: nil, views: ["name":name,"titleL":titleL]))
        

    }

    func fillData(data:ExhibitorData)
    {
        contentImage.sd_setImageWithURL(NSURL(string: data.iconUrl!)!, placeholderImage: nil)
        titleL.text = data.name
        addressL.text = data.address
        name.text = data.address
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


