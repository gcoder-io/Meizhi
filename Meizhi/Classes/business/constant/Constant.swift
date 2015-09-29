//
//  Constant.swift
//  Meizhi
//
//  Created by snowleft on 15/9/17.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

public class Constant{
    public static let URL_IOS = "http://gank.avosapps.com/api/data/iOS/"
    public static let URL_ANDROID = "http://gank.avosapps.com/api/data/Android/"
    public static let URL_WEB = "http://gank.avosapps.com/api/data/前端/"
    public static let URL_READ = "http://gank.avosapps.com/api/data/拓展资源/"
    public static let URL_RESET = "http://gank.avosapps.com/api/data/休息视频/"
    public static let URL_DAY_LIST = "http://gank.avosapps.com/api/data/福利/"
    public static let URL_DAY_DETAIL = "http://gank.avosapps.com/api/day/"
    
    /// ViewController的背景颜色
    public static let BACKGROUND_COLOR: UIColor = UIColor.whiteColor()
    
    public static var tabBarHeight:CGFloat?
    //public static var topLayoutGuideHeight:CGFloat?
    
    public static let NavigationH: CGFloat = 64
    public static let FOOTER_HEIGHT: CGFloat = 44


    public static let APP_WIDTH: CGFloat = UIScreen.mainScreen().bounds.size.width
    public static let APP_HEIGHT: CGFloat = UIScreen.mainScreen().bounds.size.height
    public static let MAIN_BOUNDS: CGRect = UIScreen.mainScreen().bounds
    
    public static let NAV_TITLE_FONT: UIFont = UIFont.systemFontOfSize(18)
    public static let TITLE_FONT: UIFont = UIFont.systemFontOfSize(16)
    
    public static let SYSTEM_VERSION = Float.init(UIDevice.currentDevice().systemVersion)

}