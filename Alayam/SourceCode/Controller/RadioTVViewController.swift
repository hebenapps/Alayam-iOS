//
//  RadioTVViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class RadioTVViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet var webView: UIWebView!
    @IBOutlet var closebtn : UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var radio : UIButton!
    var webURl:String!
    var indicator:UIActivityIndicatorView!
    var arr = NSMutableArray()
    var moviePlayer:MPMoviePlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        viewVideoPlayer.hidden = true
        webView.hidden = true;
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad{
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        GetULLs()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-RadioTVView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Radio TV Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func googleAnalyticsEvent(category: String, action: String, label: String, value: NSNumber)
    {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder =  GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func menuButtonClick(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }

  
    @IBAction func btnCloseAction(sender: AnyObject) {
        viewVideoPlayer.hidden = true
        webView.hidden = true
        closebtn.hidden = true
//        moviePlayer.stop()
//        webView.removeFromSuperview()
       // indicator.removeFromSuperview()
    }
    
    @IBAction func btnTVAndRadio(sender: AnyObject) {
        var buttonTag:Int
        buttonTag = sender.tag
       
        switch buttonTag
        {
        case 1: //Radio
            
            for (var i=0;i<self.arr.count;i=i+1){
                let fullnews = self.arr.objectAtIndex(i) as! SliderNewsDTO
                if fullnews.StreamKey == "MobileRadioChannel1"{
                    webURl = fullnews.StreamURL
                }
            }
            googleAnalyticsEvent("UI_Action", action: "Radio", label: "", value: 0)
            loadVideo(webURl)
        case 2: //Alayam TV
         //MobileBahrainTV55URL
           UIAlertView(title: "Work inProgress!!!", message: "", delegate: nil, cancelButtonTitle: "Ok").show()
            
          

            
        case 3: //MobileBahrainTVSportsURL
            
            for (var i=0;i<self.arr.count;i=i+1){
                let fullnews = self.arr.objectAtIndex(i) as! SliderNewsDTO
                if fullnews.StreamKey == "MobileBahrainTV55URL"{
                    webURl = fullnews.StreamURL
                }
            }
            googleAnalyticsEvent("UI_Action", action: "Alayam TV", label: "", value: 0)
            loadVideo(webURl)
        case 4: //MobileBahrainTVArabicURL
            
            for (var i=0;i<self.arr.count;i=i+1){
                let fullnews = self.arr.objectAtIndex(i) as! SliderNewsDTO
                if fullnews.StreamKey == "MobileBahrainTVArabicURL"{
                    webURl = fullnews.StreamURL
                }
            }
            googleAnalyticsEvent("UI_Action", action: "TV Arabic", label: "", value: 0)
            loadVideo(webURl)
        case 5: //MobileRadioChannel1
            
            for (var i=0;i<self.arr.count;i=i+1){
                let fullnews = self.arr.objectAtIndex(i) as! SliderNewsDTO
                if fullnews.StreamKey == "MobileBahrainTVSportsURL"{
                    webURl = fullnews.StreamURL
                }
            }
            googleAnalyticsEvent("UI_Action", action: "TV Sports", label: "", value: 0)
            loadVideo(webURl)
        default:
            break
        }
        
    }
    
    func GetULLs() {
        
        
        WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/Content?MobileRequest=GetStreamURLS", header: nil, body: nil) { (dict, error) -> Void in
            
            if dict != nil
            {
                self.arr = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.StreamURLS
                
                print("\(self.arr)", terminator: "")
               
            }
            
        }
        
    }

    
    func loadVideo(videoURL : NSString?)
    {
//        viewVideoPlayer.hidden = false
        webView.hidden = false
        closebtn.hidden = false
        /*
        webView = UIWebView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        let requestURL = NSURL(string: webURl)
        let request = NSURLRequest(URL:requestURL!)
        webView.loadRequest(request)
        webView.delegate = self;
        webView.scalesPageToFit = true
        
        
        indicator = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 20.0, 20.0)
        indicator.center = viewVideoPlayer.center
        
        webView.addSubview(indicator)
        viewVideoPlayer.addSubview(webView)
*/
//        let requestURL = NSURL(string: webURl)
        var url = NSString()
        url = webURl
        let requestObj = NSURLRequest(URL: NSURL(string: url as String)!)
        webView.loadRequest(requestObj);
        
//        moviePlayer = MPMoviePlayerController(contentURL: requestURL)
//        moviePlayer.view.frame = CGRect(x: 0, y: 65, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 65)
//        
//        viewVideoPlayer.addSubview(moviePlayer.view)
//        moviePlayer.fullscreen = false
//        
//        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
//        moviePlayer.play()

        
    }
    
    //MARK:- WEBVIEW DELEGATE
    func webViewDidStartLoad(webView: UIWebView) {
//        indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
//        indicator.stopAnimating()
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
//        indicator.stopAnimating()
    }

}
