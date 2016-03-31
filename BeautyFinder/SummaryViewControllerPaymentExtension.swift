//
//  SummaryViewControllerPaymentExtension.swift
//  BeautyFinder
//
//  Created by Bader Alrshaid on 3/27/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import SWXMLHash
import SwiftSpinner

extension SummaryViewController: BAWebViewDelegate
{
    func fetchMyfatoorahLinkWith(withName name: String!, email: String!, phone: String!, service: String!, price: Double!)
    {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://www.myfatoorah.com/pg/PayGatewayService.asmx" as String)!
        
        
        let xmlStr: String? = "<?xml version=\"1.0\" encoding=\"windows-1256\"?>" +
            "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " +
            "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" " +
            "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">" +
            "<soap12:Body>" +
            "<PaymentRequest xmlns=\"http://tempuri.org/\">" +
            "<req>" +
            // here the customer data
            "<CustomerDC>" +
            "<Name>\(name)</Name>" +
            "<Email>\(email)</Email>" +
            "<Mobile>\(phone)</Mobile>" +
            "</CustomerDC>" +
            "<MerchantDC>" +
            "<merchant_code>70404519</merchant_code>" +
            "<merchant_username>hy.alkandari@knpc.com</merchant_username>" +
            "<merchant_password>123456</merchant_password>" +
            "<merchant_ReferenceID>123456789</merchant_ReferenceID>" +
            "<ReturnURL>http://beautyfinders.com/operation=success</ReturnURL>" +
            "<merchant_error_url>http://beautyfinders.com/operation=error</merchant_error_url>" +
            "</MerchantDC>" +
            "<lstProductDC>" +
            // this is the list of the products
            "<ProductDC>" +
            "<product_name>\(service)</product_name>" +
            "<unitPrice>\(price)</unitPrice>" +
            "<qty>1</qty>" +
            "</ProductDC>" +
            "</lstProductDC>" +
            "</req>" +
            "</PaymentRequest>" +
            "</soap12:Body>" +
        "</soap12:Envelope>"
        
        
        let request = NSMutableURLRequest(URL: url)
        let post:NSString = xmlStr!
        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.setValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            
            /*Parse data here */
            let xml = SWXMLHash.parse(data!)
            let paymenturl = xml["soap:Envelope"]["soap:Body"]["PaymentRequestResponse"]["PaymentRequestResult"]["paymentURL"].element?.text!
            
            print(paymenturl)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.showWebView(paymenturl!)
            })
            
            
        }) // var task
        
        task.resume()
    }
    
    func showWebView(address: String!)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webView = storyboard.instantiateViewControllerWithIdentifier("BAWebViewController") as! BAWebViewController
        
        webView.address = address
        webView.delegate = self
        
        
        SwiftSpinner.hide()
        
        presentViewController(webView, animated: true, completion: nil)
    }
    
    func webViewIsLoadingNewURL(url: NSURL!)
    {
        if url.absoluteString.rangeOfString("http://beautyfinders.com/operation=error") != nil
        {
            print("ERRROOOOORRRR")
            dismissViewControllerAnimated(true, completion: {
                // TODO: show the user that his booking has failed
                dispatch_async(dispatch_get_main_queue(), { 
                    self.showAlertView("Payment Failed!", message: "Please, check your payment card and try again!")
                })
            })
            
        }
        else if url.absoluteString.rangeOfString("http://beautyfinders.com/operation=success") != nil
        {
            let token = NSUserDefaults.standardUserDefaults().stringForKey("token")!
            orderBooking(token)
            
            SwiftSpinner.show("Please Wait...")
            
            dismissViewControllerAnimated(true, completion:nil)
        }
    }
    
    func webViewDidLoadNewURL(url: NSURL!)
    {
        print("DID LOAD: \(url.absoluteString)")
    }
    
    func webViewCancelButtonIsTapped()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlertView(title:String = "Something's wrong", message: String = "Please check your email address and phone number and make sure they are valid")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}
