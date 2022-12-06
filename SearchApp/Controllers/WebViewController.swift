//
//  WebViewController.swift
//  SearchApp
//
//  Created by Анастасия on 06.12.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let urlString: String
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        guard let url = URL(string: urlString) else { return }
        
        webView.load(URLRequest(url: url)) // I traced a runtume Security warning to this line. It says "This method should not be called on the main thread as it may lead to UI unresponsiveness". Seems like there's no good solution for this right now. The SafariServices framework can be used instead of WebKit to resolve this issue. I did so in previous commits of the project (commit b38bf25 implements it).
        webView.allowsBackForwardNavigationGestures = true
    }
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
