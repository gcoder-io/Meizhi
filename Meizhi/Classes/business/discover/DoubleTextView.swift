//
//  DoubleTextView.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  探店的titleView

import UIKit

class DoubleTextView: UIView {
    
    private var buttonArr = [NoHighlightButton]()
    private let textColorFroNormal: UIColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
    private let textFont: UIFont = Constant.TITLE_FONT
    private let bottomLineView: UIView = UIView()
    private var selectedBtn: UIButton?
    weak var delegate: DoubleTextViewDelegate?

    convenience init(textArr:[String]){
        self.init()
        if textArr.count > 0{
            var i:Int = 0
            for str in textArr{
                let btn = NoHighlightButton()
                buttonArr.append(btn)
                setButton(btn, title: str, tag: 100 + i)
                i += 1
            }
        }
        // 设置底部线条View
        setBottomLineView()
        if buttonArr.count > 0{
            titleButtonClick(buttonArr[0])
        }
    }
    
    private func setBottomLineView() {
        bottomLineView.backgroundColor = UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1)
        addSubview(bottomLineView)
    }
    
    private func setButton(button: UIButton, title: String, tag: Int) {
        button.setTitleColor(UIColor.blackColor(), forState: .Selected)
        button.setTitleColor(textColorFroNormal, forState: .Normal)        
        button.titleLabel?.font = textFont
        button.tag = tag
        button.addTarget(self, action: "titleButtonClick:", forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if buttonArr.count > 0{
            let height = self.frame.size.height
            let btnW = self.frame.size.width / CGFloat(buttonArr.count)
            var i:CGFloat = 0
            for btn in buttonArr{
                btn.frame = CGRectMake(btnW * i, 0, btnW, height)
                i += 1
            }
            bottomLineView.frame = CGRectMake(0, height - 2, btnW, 2)
        }
    }
    
    func titleButtonClick(sender: UIButton) {
        selectedBtn?.selected = false
        sender.selected = true
        selectedBtn = sender
        bottomViewScrollTo(sender.tag - 100)
        delegate?.doubleTextView(self, didClickBtn: sender, forIndex: sender.tag - 100)
    }
    
    func bottomViewScrollTo(index: Int) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.bottomLineView.frame.origin.x = CGFloat(index) * self.bottomLineView.frame.width
        })
    }
    
    func clickBtnToIndex(index: Int) {
        let btn: NoHighlightButton = self.viewWithTag(index + 100) as! NoHighlightButton
        self.titleButtonClick(btn)
    }
}

/// DoubleTextViewDelegate协议
protocol DoubleTextViewDelegate: NSObjectProtocol{

    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int)
    
}

/// 没有高亮状态的按钮
class NoHighlightButton: UIButton {
    /// 重写setFrame方法
    override var highlighted: Bool {
        didSet{
            super.highlighted = false
        }
    }
}
