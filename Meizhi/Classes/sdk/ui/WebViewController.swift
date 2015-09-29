//
//  WebViewController.swift
//  Meizhi
//
//  Created by snowleft on 15/9/24.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

// 公共WebViewController
class WebViewController: UIViewController {
    private var url:String?
    
    func setUrl(url:String?){
        self.url = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController===\(url)")
        
        let webView = UIWebView()
        view.addSubview(webView)
        webView.mas_makeConstraints { (make) -> Void in
            make.edges.equalTo()(self.view)
        }

        webView.layoutIfNeeded()
        
        if url != nil{
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        }
    }

}
