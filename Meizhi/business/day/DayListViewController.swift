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

class DayListViewController: UIViewController {
    private var categoryInfo:CategoryInfo?
    private static let PAGE_SIZE = "10"
    private var page = 0

    
    func setCategoryInfo(categoryInfo:CategoryInfo){
        self.categoryInfo = categoryInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(categoryInfo?.title)
        println("DayListViewController")
        
        loadData()
        
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
        
        weak var weakSelf = self
        Alamofire.request(.GET, url!)
           .response { (request, response, data, error) -> Void in
            weakSelf?.handleResponse(response, data: data)
        }
    }
    
    // 处理服务器接口响应
    private func handleResponse(response:NSHTTPURLResponse?, data:NSData?){
        if response?.statusCode == 200 && data != nil{
            if let list:[CategoryItem]? = parseJson(data!){
                
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
