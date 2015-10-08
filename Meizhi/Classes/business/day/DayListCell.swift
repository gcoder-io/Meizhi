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
    private var tempWidthConstraint:NSLayoutConstraint!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        lb_desc.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20

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

            if tempWidthConstraint != nil{
                iv_image.removeConstraint(tempWidthConstraint)
            }
            if model!.url == nil || model!.url.isEmpty{
//                tempWidthConstraint = NSLayoutConstraint(item: iv_image, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0.0)
//                iv_image.addConstraint(tempWidthConstraint)
//                iv_image.setNeedsUpdateConstraints()
//                iv_image.updateConstraintsIfNeeded()
//                iv_image.setNeedsLayout()
//                iv_image.layoutIfNeeded()
                iv_image.mas_remakeConstraints({ (make) -> Void in
                    make.height.equalTo()(iv_image.mas_width).multipliedBy()(0.0)
                })
        
                layoutIfNeeded()
                if !isCalculateHeight{
                    iv_image.image = nil
                }
            }else{
//                tempWidthConstraint = NSLayoutConstraint(item: iv_image, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: iv_image, attribute: NSLayoutAttribute.Width, multiplier: 9.0/16.0, constant: 0.0)
//                iv_image.addConstraint(tempWidthConstraint)
//                iv_image.setNeedsUpdateConstraints()
//                iv_image.updateConstraintsIfNeeded()
//                iv_image.setNeedsLayout()
//                iv_image.layoutIfNeeded()
                iv_image.mas_remakeConstraints({ (make) -> Void in
                    make.height.equalTo()(iv_image.mas_width).multipliedBy()(9.0/16.0)
                })
            
                layoutIfNeeded()
                if !isCalculateHeight{
                    iv_image.sd_setImageWithURL(NSURL(string: model!.url), placeholderImage: UIImage(named: "avatar"))
                }
            }
        }
    }
}


