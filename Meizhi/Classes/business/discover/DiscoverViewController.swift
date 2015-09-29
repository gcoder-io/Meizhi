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
    private var doubleTextView:DoubleTextView!
    private var index:CGFloat = 0
    private let categoryInfoArr = [
        CategoryInfo(title: "iOS", url: Constant.URL_IOS),
        CategoryInfo(title: "Android", url: Constant.URL_ANDROID),
        CategoryInfo(title: "前端", url: Constant.URL_WEB),
        CategoryInfo(title: "阅读", url: Constant.URL_READ),
        CategoryInfo(title: "一刻", url: Constant.URL_RESET)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationHeight = navigationController?.navigationBar.frame.height
        print("DiscoverViewController=====>\(navigationHeight)")
        
        title = "发现"
        setNav()
        setScrollView()
        initChildViewController()
    }

    private func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        var titleArr = [String]()
        for info in categoryInfoArr{
            titleArr.append(info.title)
        }
        doubleTextView = DoubleTextView(textArr: titleArr)
        doubleTextView.frame = CGRectMake(0, 0, Constant.APP_WIDTH, 44)
        doubleTextView.delegate = self
        navigationItem.titleView = doubleTextView
    }
    
    private func setScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        backgroundScrollView = UIScrollView()
        // frame方式
//        backgroundScrollView = UIScrollView(frame: CGRectMake(0, 0, Constant.APP_WIDTH, Constant.APP_HEIGHT - Constant.NavigationH - 49))
        
        backgroundScrollView.contentSize = CGSizeMake(Constant.APP_WIDTH * CGFloat(categoryInfoArr.count), 0)
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.pagingEnabled = true
        backgroundScrollView.delegate = self
        backgroundScrollView.backgroundColor = UIColor.blackColor()
        view.addSubview(backgroundScrollView)
        
        // autolayout方式
        backgroundScrollView.mas_makeConstraints { (make) -> Void in
            make.width.equalTo()(self.view)
            make.top.equalTo()(self.view).offset()(Constant.NavigationH)
            make.bottom.equalTo()(self.view).offset()(-Constant.tabBarHeight!)
        }
        backgroundScrollView.layoutIfNeeded()
    }
    
    private func initChildViewController(){
        for info in categoryInfoArr{
            fillChildViewController(info)
        }
    }
    
    private func fillChildViewController(categoryInfo:CategoryInfo){
        let categoryVC = CategoryTableViewController()
        categoryVC.setCategoryInfo(categoryInfo)
        categoryVC.setViewControllerJumpDelegate(self)
        
        // frame方式
        let frame = CGRectMake(Constant.APP_WIDTH * index , 0, Constant.APP_WIDTH, backgroundScrollView.frame.height)
        categoryVC.view.frame = frame
        index += 1
            
        backgroundScrollView.addSubview(categoryVC.view)
        
        // autolayout方式
//        categoryVC.view.mas_makeConstraints { (make) -> Void in
//            make.width.equalTo()(self.backgroundScrollView)
//            make.height.equalTo()(self.backgroundScrollView).priorityLow()
//            make.top.equalTo()(self.backgroundScrollView)
//            make.bottom.equalTo()(self.backgroundScrollView).offset()(1.0)
//        }

    }
}

extension DiscoverViewController : ViewControllerJumpDelegate{
    
    func jump(vc:UIViewController){
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DoubleTextViewDelegate
extension DiscoverViewController : DoubleTextViewDelegate{
    
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int){
        backgroundScrollView.setContentOffset(CGPointMake(Constant.APP_WIDTH * CGFloat(index), 0), animated: true)
    }
}

/// MARK: - UIScrollViewDelegate
extension DiscoverViewController: UIScrollViewDelegate {
    
    // 监听scrollView的滚动事件
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView === backgroundScrollView {
            let index = Int(scrollView.contentOffset.x / Constant.APP_WIDTH)
            doubleTextView.clickBtnToIndex(index)
        }
    }
}

