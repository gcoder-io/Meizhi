//
//  TableViewCellAdapter.swift
//  Meizhi
//
//  Created by snowleft on 15/9/22.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import Foundation

protocol TableViewCellAdapter{
    
    typealias Model
    
    /**
    Model和View数据绑定
    
    - parameter model:
    - parameter indexPath:
    */
    func bindData(model:Model?, indexPath: NSIndexPath, isCalculateHeight:Bool)
}