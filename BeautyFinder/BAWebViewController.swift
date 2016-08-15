//
//  WebViewController.swift
//  MyFatoora
//
//  Created by Bader Alrshaid on 3/26/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit
import WebKit
import PureLayout

class BAWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    
    var delegate : BAWebViewDelegate?
    
    var address : String!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)!
    }
    
    convenience init(address: String!)
    {
        self.init(address:"")
        
        self.webView = WKWebView(frame: CGRectZero)
        self.address = address
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view.insertSubview(webView, belowSubview: progressView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(70, 0, 44, 0))
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)

        
        let url = NSURL(string: address)
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        
        backButton.enabled = false
        forwardButton.enabled = false
        
        self.performSelector(#selector(self.paymentDurationIsTimedOut), withObject: nil, afterDelay: 5 * 60)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        
        // Canceling the scheduled 5 minutes timeout
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    }
    
    
    func paymentDurationIsTimedOut()
    {
        delegate?.paymentTimeOut!()
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if (keyPath == "loading")
        {
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
            //print(webView.URL?.absoluteString)
        }
        else if (keyPath == "estimatedProgress")
        {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        else if (keyPath == "title")
        {
            self.title = webView.title
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: UIBarButtonItem)
    {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem)
    {
        webView.goForward()
    }
    
    @IBAction func reload(sender: UIBarButtonItem)
    {
        webView.reload()
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        delegate?.webViewCancelButtonIsTapped!()
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webViewIsLoadingNewURL!(webView.URL!)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webViewIsLoadingNewURL!(webView.URL!)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        progressView.setProgress(0.0, animated: false)
        
        delegate?.webViewDidLoadNewURL!(webView.URL!)
    }
}
