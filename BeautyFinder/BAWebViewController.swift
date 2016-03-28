//
//  WebViewController.swift
//  MyFatoora
//
//  Created by Bader Alrshaid on 3/26/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit
import WebKit

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
        
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)

        
        let url = NSURL(string: address)
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        
        backButton.enabled = false
        forwardButton.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
