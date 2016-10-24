//
//  ViewController.swift
//  webViewHeight
//
//  Created by ZLY on 16/9/29.
//  Copyright © 2016年 petrel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView: UIWebView?
    var bottomView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView = UIWebView(frame: CGRect(x: 50, y: 100, width: 300, height: 600))
        let url = URL(string: "http://blog.csdn.net/yibuyibulai/article/details/43795095")
        let request = URLRequest(url: url!)
        webView?.loadRequest(request)
        webView?.scalesPageToFit = true
        webView?.delegate = self
        self.view.addSubview(webView!)
        
        bottomView = UIView(frame: CGRect(x: 0, y: 600, width: 300, height: 20))
        bottomView?.backgroundColor = UIColor.red
        webView?.scrollView.addSubview(bottomView!)
        
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

       let webViewH = CGFloat(Int(webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")!)!)
       let webViewW = CGFloat(Int(webView.stringByEvaluatingJavaScript(from: "document.body.scrollWidth")!)!)
        print(webViewH, webViewW, webViewH*300/webViewW)
        print(webView.scrollView.contentSize)
        bottomView?.frame.origin.y = webView.scrollView.contentSize.height
        webView.scrollView.contentSize = CGSize(width: 300, height: webView.scrollView.contentSize.height+20)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

