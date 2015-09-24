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
    @IBOutlet weak var webView: UIWebView!
    private var url:String?
    
    func setUrl(url:String?){
        self.url = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController===\(url)")
        
        if url != nil{
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        }
    }

}
