//
//  SettingViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    
    var settingsInArabic = "الاعدادات"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgViewLoading: UIImageView!
    
    @IBOutlet weak var btnAboutUs: UILabel!
    @IBOutlet weak var btnContactUs: UILabel!
    @IBOutlet weak var btnAds: UILabel!
    @IBOutlet weak var btnSubscribe: UILabel!
    @IBOutlet weak var btnRateUs: UILabel!
    @IBOutlet weak var btnTermsAndConditions: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        self.navigationController?.navigationBarHidden = true
      lblTitle.text = settingsInArabic
        firstView.layer.borderWidth = 1
        firstView.layer.borderColor = UIColor(red:225/255.0, green:225/255.0, blue:225/255.0, alpha: 1.0).CGColor
        secondView.layer.borderWidth = 1
        secondView.layer.borderColor = UIColor(red:225/255.0, green:225/255.0, blue:225/255.0, alpha: 1.0).CGColor
        
        btnLogin.layer.cornerRadius = 5;
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
            btnAboutUs.font = UIFont(name: btnAboutUs.font.fontName, size: 20)
            btnContactUs.font = UIFont(name: btnContactUs.font.fontName, size: 20)
            btnAds.font = UIFont(name: btnAds.font.fontName, size: 20)
            btnSubscribe.font = UIFont(name: btnSubscribe.font.fontName, size: 20)
            btnRateUs.font = UIFont(name: btnRateUs.font.fontName, size: 20)
            btnTermsAndConditions.font = UIFont(name: btnTermsAndConditions.font.fontName, size: 20)
            lblEmail.font = UIFont(name: lblEmail.font.fontName, size: 16)
            lbl1.font = UIFont(name: lbl1.font.fontName, size: 20)
            lbl2.font = UIFont(name: lbl2.font.fontName, size: 20)
        }
                imgViewLoading.hidden = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-SettingView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Setting Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func menuButtonClick(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
    
    //MARK: Button Click actions
    
    @IBAction func btnCloseAction(sender: AnyObject) {
        
        lblTitle.text = settingsInArabic
        
        btnClose.hidden = true
        webView.hidden = true
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
        btnMenu.hidden = false
    }
   
    func googleAnalyticsEvent(category: String, action: String, label: String, value: NSNumber)
    {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder =  GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func btnAboutUsAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Aboutus_press", label: "About Us", value: 0)
        loadUrl("http://www.alayam.com/pages/aboutus")
    }
    
    @IBAction func btnContactUsAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Contactus_press", label: "Contact Us", value: 0)
        loadUrl("http://www.alayam.com/pages/contactus")
    }
    
    @IBAction func btnAdsAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Ads_press", label: "Ads", value: 0)
        loadUrl("http://www.alayam.com/pages/ads")
    }
    
    @IBAction func btnSubscribeAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Subscribe_press", label: "Subscribe", value: 0)
        loadUrl("http://www.alayam.com/pages/subscribe")
    }
    
    @IBAction func btnRateUsAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Feedback_press", label: "Feedback", value: 0)
        loadUrl("http://www.alayam.com/pages/feedback")
    }
    
    @IBAction func btnTermsAndconditions(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Terms_press", label: "Terms & Conditions", value: 0)
        loadUrl("http://www.alayam.com/pages/terms")
    }
    
    @IBOutlet weak var sendreport: UIButton!
    
    @IBAction func sendReportAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "SendReport_press", label: "Send Report", value: 0)
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    @IBAction func btnFaceBookAction(sender: AnyObject) {
         googleAnalyticsEvent("UI_Action", action: "FB_press", label: "Facebook", value: 0)
        loadUrl("https://www.facebook.com/ALAYAM")
    }

    @IBAction func btnTwitterAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "twitter_press", label: "Twitter", value: 0)
        loadUrl("https://twitter.com/ALAYAM")
    }
    
    @IBAction func btnGooglePlusAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Google_press", label: "GooglePlus", value: 0)
        loadUrl("https://plus.google.com/101241609565283220398")
    }
    
    @IBAction func btnYoutubeAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Youtube Button", label: "Youtube", value: 0)
        loadUrl("http://www.alayam.com/pages/contactus")
    }
    
    @IBAction func btnWifiAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Wifi Buton", label: "Youtube", value: 0)
        loadUrl("https://www.youtube.com/user/alayamnet")
    }
    @IBAction func btnInstagramAction(sender: AnyObject) {
        googleAnalyticsEvent("UI_Action", action: "Instagram Button", label: "Instagram", value: 0)
        loadUrl("https://instagram.com/alayamnewspaper/")
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        mailComposerVC.setToRecipients(["support@alayam.com"])
        mailComposerVC.setSubject("Feed back")
        mailComposerVC.setMessageBody("App version : 1.0, iOS version : \(systemVersion)", isHTML: false)
        
        return mailComposerVC
    }
    
    func loadUrl(urlString : String)
    {
     
        
        
//        webView.loadRequest(nil)
        btnMenu.hidden = true
        btnClose.hidden = false
        webView.hidden = false
        
        let requestURL = NSURL(string: urlString)
        let request = NSURLRequest(URL:requestURL!)
        webView.loadRequest(request)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func webViewDidStartLoad(webView: UIWebView) {
        imgViewLoading.hidden = false
        //            CodeSnippets.rotateLayer(imgViewLoading.layer)
        
        var arrayofimages = [UIImage]()
        
        for (var k = 1; k<=42 ; k++)
        {
            arrayofimages.append(UIImage(named: "tmp-\(k).png")!)
        }
        
        imgViewLoading.animationImages = arrayofimages
        imgViewLoading.animationDuration = 4
        
        imgViewLoading.startAnimating()

    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        imgViewLoading.hidden = true
        imgViewLoading.layer.removeAllAnimations()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        imgViewLoading.hidden = true
        imgViewLoading.layer.removeAllAnimations()
    }

}

extension SettingViewController : MFMailComposeViewControllerDelegate
{
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}