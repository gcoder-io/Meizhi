//
//  MainViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/16.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit
import PageMenu
import SnapKit

class MainViewController: UIViewController ,CAPSPageMenuDelegate{
    
    private var pageMenu : CAPSPageMenu?
    private var currentViewController:UIViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        println("MainViewController=====")
        
        self.title = "Meizhi"
        initViews()
    }
    
    private func initCategoryInfos() -> [CategoryInfo]{
        var categoryInfos = [CategoryInfo]()
        
        var iosCategoryInfo = CategoryInfo(title: "iOS", url: Constant.URL_IOS)
        var androidCategoryInfo = CategoryInfo(title: "Android", url: Constant.URL_ANDROID)
        var webCategoryInfo = CategoryInfo(title: "前端", url: Constant.URL_WEB)
        var readCategoryInfo = CategoryInfo(title: "阅读", url: Constant.URL_READ)
        var resetCategoryInfo = CategoryInfo(title: "片刻", url: Constant.URL_RESET)
        //var dayCategoryInfo = CategoryInfo(title: "每日一弹", url: Constant.URL_DAY_LIST)

        categoryInfos.append(iosCategoryInfo)
        categoryInfos.append(androidCategoryInfo)
        categoryInfos.append(webCategoryInfo)
        categoryInfos.append(readCategoryInfo)
        categoryInfos.append(resetCategoryInfo)
        //categoryInfos.append(dayCategoryInfo)
        
        return categoryInfos
    }
    
    private func initViews(){
        
        var controllerArray : [UIViewController] = []
        
        // daylist
        let daylistViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DayListViewController") as! DayListViewController
        var daylistCategoryInfo = CategoryInfo(title: "每日一弹", url: Constant.URL_DAY_LIST)
        daylistViewController.title = daylistCategoryInfo.title
        daylistViewController.setCategoryInfo(daylistCategoryInfo)
        controllerArray.append(daylistViewController)

        // categoryInfos
        var categoryInfos:[CategoryInfo] = initCategoryInfos()
        for info in categoryInfos{
            let cateViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryViewController") as! CategoryViewController
            cateViewController.title = info.title
            cateViewController.setCategoryInfo(info)
            controllerArray.append(cateViewController)
        }

        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // init parentView
        var parentView:UIView = UIView()
        self.view.addSubview(parentView)
        parentView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide)
            make.top.equalTo((self.topLayoutGuide as! UIView).snp_bottom)
        }
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, parentView.frame.width, parentView.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        parentView.addSubview(pageMenu!.view)
        
        currentViewController = controllerArray[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didMoveToPage(controller: UIViewController, index: Int){
        currentViewController = controller
    }

    // 处理旋转屏幕，回调child controller
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        println("MainViewController=====================viewWillTransitionToSize")
        currentViewController?.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        super.viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
