//
//  DiscoverViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/24.
//  Copyright © 2015年 ancode. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    private var backgroundScrollView:UIScrollView!
    private var contentView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationHeight = navigationController?.navigationBar.frame.height
        print("DiscoverViewController=====>\(navigationHeight)")
        
        title = "发现"
        setScrollView()
        initChildViewController()
    }

    private func setScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        backgroundScrollView = UIScrollView()
        backgroundScrollView.backgroundColor = Constant.BACKGROUND_COLOR
        backgroundScrollView.contentSize = CGSizeMake(Constant.AppWidth, 0)
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.pagingEnabled = true
        backgroundScrollView.delegate = self
        backgroundScrollView.backgroundColor = UIColor.blackColor()
        view.addSubview(backgroundScrollView)
        
        backgroundScrollView.mas_makeConstraints { (make) -> Void in
            make.width.equalTo()(self.view)
            make.top.equalTo()(self.view).offset()(Constant.NavigationH)
            make.bottom.equalTo()(self.view).offset()(-Constant.tabBarHeight!)
        }
    }
    
    private func initChildViewController(){
        let categoryVC = CategoryTableViewController()
        categoryVC.setCategoryInfo(CategoryInfo(title: "iOS", url: Constant.URL_IOS))
        let contentInset = UIEdgeInsetsMake(0, 0, Constant.tabBarHeight! , 0)
        categoryVC.setUIEdgeInsets(contentInset)
        backgroundScrollView.addSubview(categoryVC.view)
        
        categoryVC.view.mas_makeConstraints { (make) -> Void in
            make.width.equalTo()(self.backgroundScrollView)
            make.height.equalTo()(self.backgroundScrollView).priorityLow()
            make.top.equalTo()(self.backgroundScrollView)
            make.bottom.equalTo()(self.backgroundScrollView).offset()(1.0)
        }
    }
}

/// MARK: - UIScrollViewDelegate
extension DiscoverViewController: UIScrollViewDelegate {
    
    // 监听scrollView的滚动事件
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView === backgroundScrollView {
            print("scrollViewDidEndDecelerating=====>")
        }
    }
}

