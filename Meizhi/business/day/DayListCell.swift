//
//  DayListCell.swift
//  Meizhi
//
//  Created by snowleft on 15/9/18.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import SnapKit

class DayListCell: UITableViewCell,TableViewCellAdapter{
    typealias Model = DataItem

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
    
    func bindData(model:DataItem?, indexPath: NSIndexPath){
        // fill data.
        if model != nil{
            lb_who.text = model!.who
            lb_date.text = model!.desc
            iv_image.sd_setImageWithURL(NSURL(string: model!.url), placeholderImage: UIImage(named: "avatar"))
            
            layoutIfNeeded()
        }
    }
}
