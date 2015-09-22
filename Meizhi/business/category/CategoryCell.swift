//
//  CategoryCell.swift
//  Meizhi
//
//  Created by snowleft on 15/9/21.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import SnapKit

class CategoryCell: UITableViewCell {

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
