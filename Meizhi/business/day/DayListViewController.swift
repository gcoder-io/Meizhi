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
    private var list:[CategoryItem]?
    
    func setCategoryInfo(categoryInfo:CategoryInfo){
        self.categoryInfo = categoryInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(categoryInfo?.title)
        println("DayListViewController")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadData()
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // cell复用处理
        var cacheCell:AnyObject? = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cacheCell == nil{
            cacheCell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        let cell:UITableViewCell = cacheCell as! UITableViewCell
        
        // fill data.
        let categoryItem = list?[indexPath.row]
        cell.textLabel?.text = categoryItem?.desc
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
    
    // 处理服务器接口响应
    private func handleResponse(response:NSHTTPURLResponse?, data:NSData?){
        if response?.statusCode == 200 && data != nil{
            if let list:[CategoryItem]? = parseJson(data!){
                self.list = list
                tableView.reloadData()
            }
        }
    }
    
    // 解析json数据
    private func parseJson(data:NSData) -> [CategoryItem]?{
        var list:[CategoryItem]? = nil
        
        let json = JSON(data:data)
        let error:Bool = json["error"].boolValue
        let results = json["results"]
        if !error && results != nil && results.count > 0{
            list = [CategoryItem]()
            for(var i=0; i < results.count; i++){
                let dic = results[i].dictionaryObject
                if dic != nil{
                    let item = CategoryItem(fromDictionary: dic!)
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
