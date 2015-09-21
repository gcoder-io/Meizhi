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

class DayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var categoryInfo:CategoryInfo?
    private static let PAGE_SIZE = "30"
    private var page = 0
    @IBOutlet weak var tableView: UITableView!
    private var list:[DayListItem]?
    private var cellHeight:CGFloat?
    
    func setCategoryInfo(categoryInfo:CategoryInfo){
        self.categoryInfo = categoryInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(categoryInfo?.title)
        println("DayListViewController")
        
        initTableView()
        loadData()
    }
    
    private func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册xib
        let nib = UINib(nibName: "DayListCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DayListCell")
        
        // 计算cell高度
        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell") as! DayListCell
        cellHeight = cell.iv_image.frame.height + cell.lb_date.frame.height
        tableView.estimatedRowHeight = cellHeight!
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        let cell = tableView.dequeueReusableCellWithIdentifier("DayListCell", forIndexPath: indexPath)
            as! DayListCell

        if let categoryItem = list?[indexPath.row]{
            // fill data.
            cell.lb_date.text = categoryItem.desc
            cell.iv_image.sd_setImageWithURL(NSURL(string: categoryItem.url), placeholderImage: UIImage(named: "avatar"))
            
            // 计算cell的高度
            if categoryItem.cellHeight == nil{
                categoryItem.cellHeight = self.cellHeight
            }
        }

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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = list?[indexPath.row].cellHeight
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
            if let list:[DayListItem]? = parseJson(data!){
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
    private func parseJson(data:NSData) -> [DayListItem]?{
        var list:[DayListItem]? = nil
        
        let json = JSON(data:data)
        let error:Bool = json["error"].boolValue
        let results = json["results"]
        if !error && results != nil && results.count > 0{
            list = [DayListItem]()
            for(var i=0; i < results.count; i++){
                let dic = results[i].dictionaryObject
                if dic != nil{
                    let item = DayListItem(fromDictionary: dic!)
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
