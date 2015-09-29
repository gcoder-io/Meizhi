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
    private lazy var webView:UIWebView = {
        let webView = UIWebView()
        self.view.addSubview(webView)
        webView.mas_makeConstraints { (make) -> Void in
            make.edges.equalTo()(self.view)
        }
        webView.delegate = self
        
        // webView配置
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = UIDataDetectorTypes.PhoneNumber
        
        //
        for view in webView.subviews{
            if view is UIImageView{
                
            }
        }
        return webView
    }()
    
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
    
    deinit{
        SVProgressHUD.dismiss()
    }
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate{
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        SVProgressHUD.dismiss()
        SVProgressHUD.showErrorWithStatus("加载出错，请重试！")
    }

}
