//
//  PDFDetailViewController.swift
//  Alayam
//
//  Created by Mala on 10/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PDFDetailViewController: UIViewController, UIWebViewDelegate {
    
    var pdfURL = ""
    var lblTitle = ""
    @IBOutlet weak var webViewDetails: UIWebView!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var lblPageTitle : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        lblPageTitle.text = lblTitle
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblPageTitle.font = UIFont(name: lblPageTitle.font.fontName, size: 25)
        }
        let url : NSURL! = NSURL(string: pdfURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        webViewDetails.loadRequest(NSURLRequest(URL: url))
      
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-PDFDetailView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])

//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "PDF Detil Screen")
//        //tracker.send(GAIDictionaryBuilder.createScreenView().build())
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onClicksharePDFButton(sender: UIButton)
    {
        let textToShare = "Alayam PDF File"
        
        if let myWebsite = NSURL(string: pdfURL)
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                // Change Rect to position Popover
                let popup = UIPopoverController(contentViewController: activityVC)
                popup.presentPopoverFromRect(CGRectMake(sender.frame.origin.x , 92, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Up, animated: true)
                
                
            }
                //if iPad
            else {
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            
            
        }
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- WEBVIEW DELEGATE
    func webViewDidStartLoad(webView: UIWebView) {
        indicator.hidden = false
        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
    }

}
