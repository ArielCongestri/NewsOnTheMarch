//
//  WebArticleViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 18/06/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import WebKit

class WebArticleViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    var url : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0.0
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let myUrl: URL = URL(string: url) else { return }
        let urlReq = URLRequest(url: myUrl)
        webView.load(urlReq)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar.isHidden = true
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the ne view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
