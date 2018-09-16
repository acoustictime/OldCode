//
//  WebViewController.swift
//  SmashTag
//
//  Created by James Small on 4/4/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    public var url: URL?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlToDisplay = url {
            let requestObj = URLRequest(url: urlToDisplay)
            
            webView.loadRequest(requestObj)
        }
        
       
    }

    @IBAction func refreshPage(_ sender: UIBarButtonItem) {
        
        webView.reload()
    }
    
    
    @IBAction func forwardButton(_ sender: UIBarButtonItem) {
        
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
   }

}
