//
//  MainViewController.swift
//  Meizhi
//  应用程序主页面控制器
//  Created by lizhongwen@zaozuo.com on 15/9/24.
//  Copyright © 2015年 ancode. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 计算tabBar高度，为设置tableview contentInset做准备
        Constant.tabBarHeight = tabBar.frame.height
        print("tabBarHeight=====>\(Constant.tabBarHeight)")
        initChildViewControllers()
    }
    
    private func initChildViewControllers(){
        // 每日一弹
        let dayListVC = DayListTableViewController()
        setChildViewController(dayListVC,title: "每日一弹",
            image: "recommendation_1",selectedImage: "recommendation_2")
        setChildViewController(DiscoverViewController()
            ,title: "发现",image: "broadwood_1",selectedImage: "broadwood_2")
        setChildViewController(PhotoViewController()
            ,title: "美图",image: "classification_1",selectedImage: "classification_2")
        setChildViewController(MeViewController()
            ,title: "我的",image: "my_1",selectedImage: "my_2")
    }
    
    private func setChildViewController(vc:UIViewController, title:String, image:String, selectedImage:String){
        // 设置tabBarItem
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image),
            selectedImage: UIImage(named: selectedImage))
        vc.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName:UIColor.grayColor()],
            forState: UIControlState.Normal)
        vc.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName:UIColor.blackColor()],
            forState: UIControlState.Selected)
        
//        vc.view.backgroundColor = Constant.BACKGROUND_COLOR
        
        let nav = CustomNavigationController(rootViewController:vc)
        addChildViewController(nav)
    }
}


