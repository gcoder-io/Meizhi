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
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
