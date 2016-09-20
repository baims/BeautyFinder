//
//  CartViewControllerPaymentExtension.swift
//  BeautyFinder
//
//  Created by Macbook on 5/25/16.
//  Copyright © 2016 Baims. All rights reserved.
//

import UIKit
import SwiftSpinner
import SWXMLHash

extension BACartViewController: BAWebViewDelegate
{
    func fetchMyfatoorahLinkWith(withName name: String!, email: String!, phone: String!, orders: [BAOrderData]!)
    {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://www.myfatoorah.com/pg/PayGatewayService.asmx" as String)!
        
        
        var xmlStr : String! = "<?xml version=\"1.0\" encoding=\"windows-1256\"?>" +
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
            "<lstProductDC>" //+
            // this is the list of the products
            for order in orders
            {
                xmlStr = xmlStr +
                    "<ProductDC>" +
                    "<product_name>\(order.subcategoryName)</product_name>" +
                    "<unitPrice>\(order.subcategoryPrice)</unitPrice>" +
                    "<qty>1</qty>" +
                    "</ProductDC>"
            }
        
            xmlStr = xmlStr +
                "<ProductDC>" +
                "<product_name>Application Fees</product_name>" +
                "<unitPrice>0.5</unitPrice>" +
                "<qty>\(orders.count)</qty>" +
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
        
        self.navigationController?.pushViewController(webView, animated: true)// presentViewController(webView, animated: true, completion: nil)
        //delegate.showWebViewController(webView)
    }
    
    func webViewIsLoadingNewURL(url: NSURL!)
    {
        print(url)
        if url.absoluteString!.rangeOfString("http://beautyfinders.com/operation=error") != nil
        {
            print("ERRROOOOORRRR")
            
            self.navigationController?.popViewControllerAnimated(true)
            dispatch_async(dispatch_get_main_queue(), {
                BAAlertView.showAlertView(self, title: "Payment Failed!", message: "Please, check your payment card and try again!")
            })
        }
        else if url.absoluteString!.rangeOfString("http://beautyfinders.com/operation=success") != nil
        {
            let token = NSUserDefaults.standardUserDefaults().stringForKey("token")!
            orderBooking(token)
            
            SwiftSpinner.show("Please Wait...")
            
            //self.dismissViewControllerAnimated(true, completion:nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func webViewDidLoadNewURL(url: NSURL!)
    {
        print("DID LOAD: \(url.absoluteString)")
    }
    
    func webViewCancelButtonIsTapped()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func paymentTimeOut()
    {
        self.navigationController?.popViewControllerAnimated(true)
        
        BAAlertView.showAlertView(self, title: "Time out!", message: "There is a limit of 5 minutes to stay on the payment page. Please try to book again.")
    }
}
