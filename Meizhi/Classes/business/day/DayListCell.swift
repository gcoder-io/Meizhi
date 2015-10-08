//
//  DayListCell.swift
//  Meizhi
//
//  Created by snowleft on 15/9/18.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

class DayListCell: UITableViewCell{
    typealias Model = DataItem

    @IBOutlet weak var iv_image: UIImageView!
    @IBOutlet weak var lb_who: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_desc: UILabel!

    @IBOutlet weak var iv_image_height: NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iv_image.removeConstraint(iv_image_height)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DayListCell : TableViewCellAdapter{
    
    func bindData(model:DataItem?, indexPath: NSIndexPath, isCalculateHeight:Bool){
        // fill data.
        if model != nil{
            lb_who.text = model!.who
            lb_date.text = model!.publishedAt
            lb_desc.text = model!.desc

            if model!.url == nil || model!.url.isEmpty{
                iv_image.mas_remakeConstraints({ (make) -> Void in
                    make.height.equalTo()(0.0)
                })
                if !isCalculateHeight{
                    iv_image.image = nil
                }
            }else{
                iv_image.mas_remakeConstraints({ (make) -> Void in
                    make.height.equalTo()(iv_image.mas_width).multipliedBy()(9.0/16.0)
                })
                if !isCalculateHeight{
                    iv_image.sd_setImageWithURL(NSURL(string: model!.url), placeholderImage: UIImage(named: "avatar"))
                }
            }
        
            layoutIfNeeded()
        }
    }
}


