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
    private let webView = UIWebView()
    private lazy var progressbar:NJKWebViewProgressView = {
        let progressbar:NJKWebViewProgressView = NJKWebViewProgressView()
        let progressBarHeight:CGFloat = 2.0
        let navigaitonBarBounds = self.navigationController?.navigationBar.bounds
        
        var barFrame = CGRectMake(0, (navigaitonBarBounds?.size.height)! - progressBarHeight
            , (navigaitonBarBounds?.size.width)!, progressBarHeight);
        progressbar.frame = barFrame
        //
        progressbar.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        UIViewAutoresizing.FlexibleTopMargin
        return progressbar
    }()
    
    private let cancelActionSheetJS = "document.documentElement.style.webkitTouchCallout = 'none';"
    
    func setUrl(url:String?){
        self.url = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController===\(url)")
        
        initWebView()
        configWebView(webView)
        configLoadingProgress()
        if url != nil{
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(progressbar)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressbar.removeFromSuperview()
    }
    
    // 清除指定domain的cookies
    private func clearCookie(domain:String){
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies{
            for cookie in cookies{
                if cookie.domain == domain{
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                }
            }
        }
    }
    
    
    private func initWebView() -> UIWebView{
        webView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(webView)
        webView.mas_makeConstraints { (make) -> Void in
            make.edges.equalTo()(self.view)
        }
        return webView
    }
    
    private func configWebView(webView:UIWebView){
        webView.scalesPageToFit = true
        webView.dataDetectorTypes = UIDataDetectorTypes.PhoneNumber
    }
    
    private func configLoadingProgress(){
//        let _progressProxy = NJKWebViewProgress()
//        webView.delegate = _progressProxy
//        _progressProxy.webViewProxyDelegate = self
//        _progressProxy.progressDelegate = self
        webView.delegate = self
    }
    
    deinit{
        webView.stopLoading()
        SVProgressHUD.dismiss()
    }
}

// MARK: - NJKWebViewProgressDelegate
extension WebViewController: NJKWebViewProgressDelegate{
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
//        progressbar.progress = progress
        print(progress)
    }
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate{
    
    // 使用flashScrollIndicators方法显示滚动标识然后消失，告知用户此页面可以滚动，后面还有更多内容
    func handleFlashScrollIndicators(){
        for view in webView.subviews{
            if view.respondsToSelector("flashScrollIndicators"){
                view.performSelector("flashScrollIndicators")
            }
        }
    }
    
    // 取消长按webView上的链接弹出actionSheet的问题
    func cancelActionSheetWhenLinkClick(){
        webView.stringByEvaluatingJavaScriptFromString(cancelActionSheetJS)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView){
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        cancelActionSheetWhenLinkClick()
        handleFlashScrollIndicators()
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        SVProgressHUD.dismiss()
        SVProgressHUD.showErrorWithStatus("加载出错，请重试！")
    }

}
