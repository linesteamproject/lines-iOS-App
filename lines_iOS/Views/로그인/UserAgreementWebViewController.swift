//
//  UserAgreementWebViewController.swift
//  lines_iOS
//
//  Created by mun on 2022/09/10.
//

import UIKit
import WebKit

class UserAgreementWebViewController: ViewController {
    internal var urlStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: self.view.frame)
        self.view.addSubviews(webView)
        
        guard let url = URL(string: urlStr)
        else { return }
        
        webView.load(URLRequest(url: url))
    }
}
