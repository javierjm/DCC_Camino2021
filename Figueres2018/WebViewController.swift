//
//  WebViewController.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/8/16.
//  Copyright © 2016 Data Center Consultores. All rights reserved.
//

import UIKit

import WebKit

class WebViewController: UIViewController, WKNavigationDelegate  {

    @IBOutlet weak var closeButton: UIBarButtonItem!
    var url:String!
    @IBOutlet weak var acitivyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webContainerView: UIView!
    var webView : WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        acitivyIndicator.hidesWhenStopped = true
        acitivyIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        // Do any additional setup after loading the view.
        openWebView(url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    // MARK: WKWebView
    
    func openWebView(_ urlString: String) {
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url! as URL)
        // init and load request in webview.
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        webView.load(request)
        self.webContainerView.addSubview(webView)
//        self.view.sendSubview(toBack: webView)
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        acitivyIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        acitivyIndicator.stopAnimating()
//        self.dismiss(animated: true, completion: nil)
    }

}
