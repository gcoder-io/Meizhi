//
//  TableViewCellHandler.swift
//  Meizhi
//
//  Created by snowleft on 15/9/22.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

/**
*  TableViewCellHandler
*/
protocol TableViewCellHandler{
    
    /**
    
    实例化用于计算的TableViewCell
    
    - returns: 自定义的TableViewCell
    */
    func instanceEstimatedCell <CustomCell:UITableViewCell> () -> CustomCell?
    
 
    /**
    
    计算cell高度
    
    - parameter indexPath:
    
    - returns:
    */
    func estimatedCellHeight(indexPath: NSIndexPath) -> CGFloat
}