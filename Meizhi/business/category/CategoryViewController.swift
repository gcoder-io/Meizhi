//
//  CategoryViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/17.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    private var categoryInfo:CategoryInfo?
    private var page = 0
    private static let PAGE_SIZE = "30"
    private var list:[DataItem]?
    private var cellHeight:CGFloat?
    private var estimatedCell:CategoryCell?
    @IBOutlet weak var tableView: UITableView!
    private var lableArray = [String]()
    
    func setCategoryInfo(categoryInfo:CategoryInfo){
        self.categoryInfo = categoryInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(categoryInfo?.title)
        println("CategoryViewController")
        
        initTableView()
        loadData()
    }
    
    
    
    private func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册xib
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CategoryCell")
        
        // 计算cell高度
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        estimatedCell = cell
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
            as! CategoryCell
        
        if let categoryItem = list?[indexPath.row]{
            // fill data.
//            cell.lb_who.text = categoryItem.who
//            cell.lb_date.text = categoryItem.publishedAt
            cell.lb_desc.text = categoryItem.desc
            
            cell.layoutIfNeeded()
    
            var height:CGFloat? = categoryItem.cellHeight
            if height == nil{
                height = CGRectGetMaxY(cell.lb_desc.frame) + 10
                println("\(indexPath.row)===height=============>\(height)")
                
                // 计算cell的高度
                categoryItem.cellHeight = height
            }
        }
        println("\(cell.frame.width)===\(cell.frame.height)")

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
        var height:CGFloat?
        if let categoryItem = list?[indexPath.row]{
            height = categoryItem.cellHeight
        }
        
        println("\(indexPath.row)======\(height)")
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
        var requestUrl:String = categoryInfo!.url + CategoryViewController.PAGE_SIZE + "/" + String(page)
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
                    if i > 0{
                        item.desc = "\(i)===" + list![i-1].desc + item.desc

                    }else{
                        item.desc = "\(i)===" + item.desc + "这是一条测试数据内容0123456789"

                    }
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


