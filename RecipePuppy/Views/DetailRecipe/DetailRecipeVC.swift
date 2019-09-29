//
//  DetailRecipeVC.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 29/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import UIKit
import WebKit

class DetailRecipeVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    
    var url: String = "www.allrecipes.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatorView()
        webView.navigationDelegate = self
        webView.load(url)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    
    func startIndicatorView() {
        viewLoading.isHidden = false
        indicatorView.startAnimating()
    }
}


//     MARK: WKWebView function

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}


//     MARK: WKNavigation functions

extension DetailRecipeVC: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {            
            if webView.estimatedProgress == 1 {
                viewLoading.isHidden = true
                indicatorView.stopAnimating()
            }
        }
    }
    
}
