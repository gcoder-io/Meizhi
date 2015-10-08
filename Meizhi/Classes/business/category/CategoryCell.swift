//
//  CategoryCell.swift
//  Meizhi
//
//  Created by snowleft on 15/9/21.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    typealias Model = DataItem

    @IBOutlet weak var lb_desc: UILabel!
    @IBOutlet weak var lb_who: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lb_desc.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension CategoryCell : TableViewCellAdapter{
    
    func bindData(model:DataItem?, indexPath: NSIndexPath, isCalculateHeight: Bool){
        // fill data.
        if model != nil{
            lb_who.text = model!.who
            lb_date.text = model!.publishedAt
            lb_desc.text = model!.desc
            
            layoutIfNeeded()
        }
    }
}
