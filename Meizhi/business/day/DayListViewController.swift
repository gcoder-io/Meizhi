//
//  DayListViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/17.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellHandler {
    private var categoryInfo:CategoryInfo?
    private static let PAGE_SIZE = "30"
    private var page = 0
    @IBOutlet weak var tableView: UITableView!
    private var list:[DataItem]?
    private var estimatedCell:DayListCell?
    
    func setCategoryInfo(categoryInfo:CategoryInfo){
        self.categoryInfo = categoryInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(categoryInfo?.title)
        println("DayListViewController")
        
        estimatedCell = instanceEstimatedCell()
        initTableView()
        loadData()
    }
    
    private func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册xib
        let nib = UINib(nibName: "DayListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DayListCell")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell", forIndexPath: indexPath)
            as! DayListCell
        var data = list?[indexPath.row]
        cell.bindData(data, indexPath: indexPath)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = estimatedCellHeight(indexPath)
        return height
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("DayListViewController=====================viewWillTransitionToSize")
    }
    
    /**
    
    实例化用于计算的TableViewCell
    
    - returns: 自定义的TableViewCell
    */
    func instanceEstimatedCell <DayListCell> () -> DayListCell?{
        var cell:DayListCell = NSBundle.mainBundle().loadNibNamed("DayListCell", owner: nil, options: nil).last as! DayListCell
        // 不要使用以下方式，可能会造成内存泄露.
        //        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell") as! DayListCell
        return cell
    }
    
    
    /**
    
    计算cell高度
    
    - parameter indexPath:
    
    - returns:
    */
    func estimatedCellHeight(indexPath: NSIndexPath) -> CGFloat{
        var height:CGFloat?
        if let categoryItem = list?[indexPath.row]{
            height = categoryItem.cellHeight
            if height != nil{
                return height ?? 0
            }
            
            estimatedCell?.iv_image.image = UIImage(named: "avatar")
            estimatedCell?.lb_date.text = categoryItem.desc
            estimatedCell?.lb_who.text = categoryItem.who
            
            estimatedCell?.layoutIfNeeded()
            
            height = CGRectGetMaxY(estimatedCell!.lb_who.frame) + 3
            categoryItem.cellHeight = height
            println(height)
        }
        return height ?? 0
    }

    
    // MARK: - Network
    
    /**
    从网络/本地加载数据
    */
    private func loadData(){
        if categoryInfo == nil || categoryInfo?.url == nil{
            return
        }
        var requestUrl:String = categoryInfo!.url + DayListViewController.PAGE_SIZE + "/" + String(page)
        var url:String? = requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
        if url == nil{
            return
        }
        
        weak var weakSelf = self // 弱引用self指针
        Alamofire.request(.GET, url!)
           .response { (request, response, data, error) -> Void in
            weakSelf?.handleResponse(response, data: data)
        }
    }
    
    /**
    处理服务器接口响应
    
    - parameter response: NSHTTPURLResponse
    - parameter data:     源数据
    */
    private func handleResponse(response:NSHTTPURLResponse?, data:NSData?){
        if response?.statusCode == 200 && data != nil{
            if let list:[DataItem]? = parseJson(data!){
                self.list = list
                println("tableView.reloadData=====>")
                
                tableView.reloadData()
            }
        }
    }
    
    /**
    解析json数据
    
    - parameter data: 源数据
    
    - returns: [CategoryItem]
    */
    private func parseJson(data:NSData) -> [DataItem]?{
        var list:[DataItem]? = nil
        
        let json = JSON(data:data)
        let error:Bool = json["error"].boolValue
        let results = json["results"]
        if !error && results != nil && results.count > 0{
            list = [DataItem]()
            for(var i=0; i < results.count; i++){
                let dic = results[i].dictionaryObject
                if dic != nil{
                    let item = DataItem(fromDictionary: dic!)
                    list?.append(item)
                }
            }
        }
        return list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
