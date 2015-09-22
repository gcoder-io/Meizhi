//
//  DayListCell.swift
//  Meizhi
//
//  Created by snowleft on 15/9/18.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import SnapKit

class DayListCell: UITableViewCell {
    @IBOutlet weak var iv_image: UIImageView!
    @IBOutlet weak var lb_who: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var iv_image_constraint_height: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iv_image.removeConstraint(iv_image_constraint_height)
        iv_image.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(iv_image.snp_width)
        }
        iv_image.layoutIfNeeded()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
