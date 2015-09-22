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
    override func awakeFromNib() {
        super.awakeFromNib()
        lb_desc.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        
        // Initialization code
//        lb_desc.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        lb_desc.numberOfLines = 0
//        lb_desc.adjustsFontSizeToFitWidth = false
//        lb_desc.snp_makeConstraints { (make) -> Void in
//            make.width.equalTo(UIScreen.mainScreen().bounds.size.width - 20)
//        }
//        lb_desc.layoutIfNeeded()

//        println("contentView.frame.width ===\(UIScreen.mainScreen().bounds.size.width - 20)")
//       lb_desc.contentCompressionResistancePriorityForAxis(UILayoutConstraintAxis.Horizontal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
