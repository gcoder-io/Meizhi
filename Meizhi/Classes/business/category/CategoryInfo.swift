//
//  CategoryInfo.swift
//  Meizhi
//
//  Created by snowleft on 15/9/17.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import Foundation

public class CategoryInfo{
    public var title:String
    public var url:String
    public var isAdd:Bool = false
    
    init(title:String, url:String){
        self.title = title
        self.url = url
    }
}