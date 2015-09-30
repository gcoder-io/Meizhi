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
    private var lastIndex = 0
    private let categoryInfoArr = [
        CategoryInfo(title: "iOS", url: Constant.URL_IOS),
        CategoryInfo(title: "Android", url: Constant.URL_ANDROID),
        CategoryInfo(title: "前端", url: Constant.URL_WEB),
        CategoryInfo(title: "阅读", url: Constant.URL_READ),
        CategoryInfo(title: "一刻", url: Constant.URL_RESET)
    ]
    private var vcArr = [CategoryTableViewController]()
    private lazy var contentViewForSV:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationHeight = navigationController?.navigationBar.frame.height
        print("DiscoverViewController=====>\(navigationHeight)")
        
        title = "发现"
        setNav()
        setScrollView()
        initContentViewForSV()
//        fillChildren()
        initChildViewController()
    }

    private func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        var titleArr = [String]()
        for info in categoryInfoArr{
            titleArr.append(info.title)
        }
        doubleTextView = DoubleTextView(textArr: titleArr)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        doubleTextView.frame = CGRectMake(0, 0, screenWidth, 44)
        doubleTextView.delegate = self
        navigationItem.titleView = doubleTextView
//        doubleTextView.mas_makeConstraints { (make) -> Void in
//            make.edges.equalTo()(self.navigationItem)
//        }
    }
    
    private func setScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        backgroundScrollView = UIScrollView()
        // frame方式
//        backgroundScrollView = UIScrollView(frame: CGRectMake(0, 0, Constant.APP_WIDTH, Constant.APP_HEIGHT - Constant.NavigationH - 49))
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        backgroundScrollView.contentSize = CGSizeMake(screenWidth * CGFloat(categoryInfoArr.count), 0)
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.pagingEnabled = true
        backgroundScrollView.delegate = self
        view.addSubview(backgroundScrollView)
        
        // autolayout方式
        backgroundScrollView.mas_makeConstraints { (make) -> Void in
            make.left.equalTo()(self.view)
            make.right.equalTo()(self.view)
            make.top.equalTo()(self.view).offset()(Constant.NavigationH)
            make.bottom.equalTo()(self.view).offset()(-Constant.tabBarHeight!)
        }
        backgroundScrollView.layoutIfNeeded()
    }
    
    private func initContentViewForSV(){
        backgroundScrollView.addSubview(contentViewForSV)
        contentViewForSV.mas_makeConstraints { (make) -> Void in
            make.edges.equalTo()(self.backgroundScrollView)
            make.centerY.equalTo()(self.backgroundScrollView)
            make.width.equalTo()(self.backgroundScrollView).multipliedBy()(CGFloat(self.categoryInfoArr.count))
        }
    }
    
    private func fillChildren(){
        let view1 = UIView()
        view1.backgroundColor = UIColor.redColor()
        contentViewForSV.addSubview(view1)
        view1.mas_makeConstraints { (make) -> Void in
            make.left.equalTo()(self.contentViewForSV)
            make.top.equalTo()(self.contentViewForSV)
            make.bottom.equalTo()(self.contentViewForSV)
            make.width.equalTo()(self.backgroundScrollView)
        }
        
        let view2 = UIView()
        contentViewForSV.addSubview(view2)
        view2.backgroundColor = UIColor.greenColor()
        view2.mas_makeConstraints { (make) -> Void in
            make.left.equalTo()(view1.mas_right)
            make.top.equalTo()(self.contentViewForSV)
            make.bottom.equalTo()(self.contentViewForSV)
            make.width.equalTo()(self.backgroundScrollView)
        }
    }
    
    private func initChildViewController(){
        for info in categoryInfoArr{
            fillChildViewController(info)
        }
    }
    
    private func fillChildViewController(categoryInfo:CategoryInfo){
        let categoryVC = CategoryTableViewController()
        vcArr.append(categoryVC)
        categoryVC.setCategoryInfo(categoryInfo)
        categoryVC.setViewControllerJumpDelegate(self)
        
        // frame方式
//        let frame = CGRectMake(Constant.APP_WIDTH * index , 0, Constant.APP_WIDTH, backgroundScrollView.frame.height)
//        categoryVC.view.frame = frame
//        backgroundScrollView.addSubview(categoryVC.view)
        
        // autolayout方式
        contentViewForSV.addSubview(categoryVC.view)
        let currentIndex:Int = Int(index)
        categoryVC.view.mas_makeConstraints { (make) -> Void in
            make.top.equalTo()(self.contentViewForSV)
            make.bottom.equalTo()(self.contentViewForSV)
            make.width.equalTo()(self.backgroundScrollView)
            if currentIndex == 0{
                make.left.equalTo()(self.contentViewForSV)
            }else{
                let preView = self.vcArr[currentIndex - 1].view
                make.left.equalTo()(preView.mas_right)
            }
        }
        
        if index < 2{
            // 默认初始化前2个vc tableview数据，其它vc懒加载
            categoryInfo.isAdd = true
            categoryVC.initViews()
        }
        index += 1
    }
}

// MARK: - ViewControllerJumpDelegate
extension DiscoverViewController : ViewControllerJumpDelegate{
    
    func jump(vc:UIViewController){
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DoubleTextViewDelegate
extension DiscoverViewController : DoubleTextViewDelegate{
    
    func switchViewController(index: Int){
        if index > 0 && index < categoryInfoArr.count{
            let info = categoryInfoArr[index]
            if !info.isAdd{
                info.isAdd = true
                if index < vcArr.count{
                    vcArr[index].initViews()
                }
            }
        }
    }
    
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int){
        // 初始化当前index及前后tableview数据
        switchViewController(index)
        switchViewController(index - 1)
        switchViewController(index + 1)

        let screenWidth = UIScreen.mainScreen().bounds.size.width
        backgroundScrollView.setContentOffset(CGPointMake(screenWidth * CGFloat(index), 0), animated: true)
        lastIndex = index
    }
}

/// MARK: - UIScrollViewDelegate
extension DiscoverViewController: UIScrollViewDelegate {
    
    // 监听scrollView的滚动事件
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView === backgroundScrollView {
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            let index = Int(scrollView.contentOffset.x / screenWidth)
            doubleTextView.clickBtnToIndex(index)
        }
    }
}

