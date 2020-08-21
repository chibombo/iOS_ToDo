//
//  WebViewController.swift
//  iOS_ToDo
//
//  Created by Genaro Arvizu on 19/08/20.
//  Copyright © 2020 Genaro Arvizu. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webView: WKWebView!
    
    override func loadView() {
//        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.apple.com")!
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
        
        
        
        // Do any additional setup after loading the view.
    }

}
extension WebViewController: WKNavigationDelegate {
    
}
