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
        backgroundScrollView.contentSize = CGSizeMake(Constant.AppWidth * 2.0, 0)
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
        backgroundScrollView.layoutIfNeeded()
    }
    
    private func initChildViewController(){
        let categoryInfos = [
//            CategoryInfo(title: "iOS", url: Constant.URL_IOS),
            CategoryInfo(title: "Android", url: Constant.URL_ANDROID)
        ]
        for categoryInfo in categoryInfos{
            fillChildViewController(categoryInfo)
        }
    }
    
    private func fillChildViewController(categoryInfo:CategoryInfo){
        let categoryVC = CategoryTableViewController()
        categoryVC.setCategoryInfo(categoryInfo)
        let contentInset = UIEdgeInsetsMake(-35, 0, 35 , 0)
        categoryVC.setUIEdgeInsets(contentInset)
        backgroundScrollView.addSubview(categoryVC.view)
        let frame = CGRectMake(0, 0, Constant.AppWidth, backgroundScrollView.frame.height)
        categoryVC.view.frame = frame
        
//        categoryVC.view.mas_makeConstraints { (make) -> Void in
//            make.width.equalTo()(self.backgroundScrollView)
//            make.height.equalTo()(self.backgroundScrollView).priorityLow()
//            make.top.equalTo()(self.backgroundScrollView)
//            make.bottom.equalTo()(self.backgroundScrollView).offset()(1.0)
//        }

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

