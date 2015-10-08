//
//  DayListTableViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/24.
//  Copyright © 2015年 ancode. All rights reserved.
//

import UIKit

class DayListTableViewController: UITableViewController {
    private var categoryInfo:CategoryInfo = CategoryInfo(title: "每日一弹", url: Constant.URL_DAY_LIST)
    private static let PAGE_SIZE = "20"
    private var page = 0
    private var list:[DataItem]?
    private var estimatedCell:DayListCell?
    private var refreshType:RefreshType = RefreshType.PULL_DOWN
    private var contentInset:UIEdgeInsets?
    
    func setUIEdgeInsets(contentInset:UIEdgeInsets?){
        self.contentInset = contentInset
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryInfo.title
        print("DayListTableViewController=====>\(title)")
        
        estimatedCell = instanceEstimatedCell()
        initTableView()
        initMJRefresh()
    }

    private func initTableView(){
        // 去除cell分割线
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tableView.dataSource = self
        tableView.delegate = self
        
        // 设置tableView显示区域
        if contentInset != nil{
            tableView.contentInset = contentInset!
        }else{
            tableView.contentInset = UIEdgeInsetsMake(0, 0, Constant.FOOTER_HEIGHT, 0)
        }
        
        // 隐藏多余的分割线
        tableView.tableFooterView = UIView()
        
        // 注册xib
        let nib = UINib(nibName: "DayListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DayListCell")
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    // cell绑定数据
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell", forIndexPath: indexPath)
            as! DayListCell
        configureCell(cell, indexPath: indexPath, isCalculateHeight: false)
        return cell
    }
    
    private func configureCell(cell:DayListCell,indexPath:NSIndexPath, isCalculateHeight:Bool){
        if (indexPath.row % 2 == 0) {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }
        let data = list?[indexPath.row]
        cell.bindData(data, indexPath: indexPath, isCalculateHeight: false)
    }
    
    // 计算cell高度dde
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 自动计算方式
        let height = tableView.fd_heightForCellWithIdentifier("DayListCell", cacheByIndexPath: indexPath) { (cell) -> Void in
            self.configureCell(cell as! DayListCell, indexPath: indexPath, isCalculateHeight: false)
        }
        
        print("height=============\(height)")
        return height

        
        // 手动计算方式
//        let height = estimatedCellHeight(indexPath)
//        return height
    }
    
    // 估算cell高度
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 317.5
    }
    
    // 处理cell line左边界不全问题
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // ios7.0+处理方式
        cell.separatorInset = UIEdgeInsetsZero
        // ios8.0+需附加配置
        if #available(iOS 8.0, *) {
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - TableViewCell处理器
extension DayListTableViewController:TableViewCellHandler{
    
    // 实例化用于计算的TableViewCell
    func instanceEstimatedCell<DayListCell>() -> DayListCell?{
        let cell:DayListCell = NSBundle.mainBundle().loadNibNamed("DayListCell", owner: nil, options: nil).last as! DayListCell
        // 不要使用以下方式，可能会造成内存泄露.
        //        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell") as! DayListCell
        return cell
    }
    
    
    // 计算cell高度
    func estimatedCellHeight(indexPath: NSIndexPath) -> CGFloat{
        var height:CGFloat?
        if let categoryItem = list?[indexPath.row]{
            height = categoryItem.cellHeight
            if height != nil{
                return height ?? 0
            }
            estimatedCell?.bindData(categoryItem, indexPath: indexPath, isCalculateHeight: true)
            height = estimatedCell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height

//            height = CGRectGetMaxY(estimatedCell!.lb_who.frame) + 1
            categoryItem.cellHeight = height
            
            print(height)
        }
        return height ?? 0
    }
}

// MARK: - 下拉刷新
extension DayListTableViewController{
    
    private func initMJRefresh(){
        weak var weakSelf:DayListTableViewController? = self
        tableView.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            weakSelf?.refreshType = RefreshType.PULL_DOWN
            weakSelf?.page = 1
            weakSelf?.loadData()
        })
        let footer:MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            weakSelf?.refreshType = RefreshType.LOAD_MORE
            weakSelf?.loadData()
        })
        footer.automaticallyRefresh = true
        tableView.footer = footer
        
        tableView.header.beginRefreshing()
    }
    
    // 停止刷新
    private func endRefreshing(){
        if refreshType == RefreshType.PULL_DOWN{
            tableView.header.endRefreshing()
        }else{
            tableView.footer.endRefreshing()
        }
    }
}

// MARK: - 数据处理
extension DayListTableViewController{
    
    // 从网络/本地加载数据
    private func loadData(){
        let requestUrl:String = categoryInfo.url + DayListTableViewController.PAGE_SIZE + "/" + String(page)
        let url:String? = requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
        print(url)
        
        if url == nil{
            endRefreshing()
            return
        }
        
        // 网络监测
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            print("network status=====>\(status)")
        }
        
        // 网络请求
        weak var weakSelf = self // 弱引用self指针
        let manager = AFHTTPRequestOperationManager()
        //使用这个将得到的是NSData
        manager.responseSerializer = AFHTTPResponseSerializer()
        //使用这个将得到的是JSON
//        manager.responseSerializer = AFJSONResponseSerializer()
        manager.GET(url, parameters: nil, success: { (operation:AFHTTPRequestOperation?, responseObject:AnyObject?) -> Void in
            
            print("responseObject type=====>\(responseObject?.classForCoder)")
            if responseObject != nil && responseObject is NSData{
                weakSelf?.handleResponse(operation?.response, data: responseObject as? NSData)
            }else{
                weakSelf?.endRefreshing()
            }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
               weakSelf?.endRefreshing()
        }
    }
    
    /**
    处理服务器接口响应
    
    - parameter response: NSHTTPURLResponse
    - parameter data:     源数据
    */
    private func handleResponse(response:NSHTTPURLResponse?, data:NSData?){
        if response?.statusCode == 200 && data != nil{
            if let list:[DataItem] = parseJson(data!){
                if refreshType == RefreshType.PULL_DOWN{
                    self.list = list
                }else{
                    if self.list == nil{
                        self.list = [DataItem]()
                    }
                    self.list? += list
                }
                
                print("tableView.reloadData=====>\(list.count)")
                tableView.reloadData()
                page += 1
            }else{
                // no data.
                if refreshType == RefreshType.LOAD_MORE{
                    tableView.footer.noticeNoMoreData()
                }
            }
        }
        endRefreshing()
    }
    
    /**
    解析json数据
    
    - parameter data: 源数据
    
    - returns: [CategoryItem]
    */
    private func parseJson(data:NSData) -> [DataItem]?{
        var list:[DataItem]? = nil
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let error = json["error"] as? Bool
            if error != nil && error == false{
                if let results = json["results"] as? Array<AnyObject>{
                    list = [DataItem]()
                    for(var i=0; i < results.count; i++){
                        if let dic = results[i] as? NSDictionary{
                            let item = DataItem(fromDictionary: dic)
                            // test
                            item.desc = "这是一条测试描述"
                            if i > 0{
                                item.desc! += list![i - 1].desc
                                item.desc! += "abcdefghijklmnopqrstuvwxyz"
                            }
                            if i % 2 == 0{
                                item.url = nil
                            }

                            list?.append(item)
                        }
                    }
                }
            }
        } catch {
            print("parse json error!")
        }
        return list
    }
}
