//
//  WebViewController.swift
//  SearchApp
//
//  Created by Анастасия on 06.12.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
