//
//  ArticleDetailsViewController.swift
//  Alayam
//
//  Created by Jeyaraj on 15/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblArticleImage: UIImageView!
    
    @IBOutlet weak var constraintsScrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintsWebviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var webViewDetails: UIWebView!
    
    @IBOutlet weak var lblNaviTitle: UILabel!
    
    
    var articleDetails : ArticlesDTO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewDetails.delegate = self
        
        lblDate.text = articleDetails.ArticleDate
        lblTitle.text = articleDetails.ArticleTitle
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 20)
            lblDate.font = UIFont(name: lblDate.font.fontName, size: 20)
            lblNaviTitle.font = UIFont(name: lblNaviTitle.font.fontName, size: 25)
        }
        
        let bounds = UIScreen.mainScreen().bounds
        var width:Int = Int(bounds.size.width)
        width = width - 20
        let height: Int = width - 100
        
        let widthStr = NSString(format: "width=\"%d\" height=\"%d\"", width,height) as String
        
        let aString: String = articleDetails.ArticleDetails
        //        var newString = aString.stringByReplacingOccurrencesOfString("<p", withString: "<p dir=\"rtl\" lang=\"ar\" ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let newString = aString.stringByReplacingOccurrencesOfString("width=\"620\" height=\"350\"", withString: widthStr, options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        
//        var string = NSString(format: "<html><body style='color:#00183F' align='right' text=\"#FFFFFF\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"20\">%@</body></html>",articleDetails.ArticleDetails) as String // .stringWithFormat:@, justifiedString
        let string = NSString(format: "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><meta name=\"viewport\"content=\"width=device-width\" /><style type=\"text/css\">.newsdescription img{width:auto;display:block;align-content:center;max-height:4px;margin:0 auto;max-width:4px;height:auto}.newsdescription iframe{width:auto;display:block;align-content:center;max-height:4px;margin:0 auto;max-width:4px;height:auto}</style></head><body dir=\"rtl\" lang=\"ar\" style='color:#00183F' align='right' text=\"#FFFFFF\" face=\"DroidArabicKufi-Regular\" size=\"18\"><div class='newsdescription' align='right' dir='rtl' size=\"18\"> %@ </div></body></html>" ,newString) as String
        
//        var string = NSString(format: "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body dir=\"rtl\" lang=\"ar\" style='color:#00183F' align='justify' text=\"#FFFFFF\" face=\"DroidArabicKufi-Regular\" size=\"28\"><div align='justify' size=\"28\"> %@ ",articleDetails.ArticleDetails) as String // .stringWithFormat:@, justifiedString
//        string = string + "</p></div></body></html>"
        
        webViewDetails.scrollView.scrollEnabled = false
        self.view.layoutIfNeeded()
        webViewDetails.loadHTMLString(string, baseURL: nil)
        
        lblArticleImage.setImageWithUrl(NSURL(string: articleDetails.WriterImageURL_S)!, placeHolderImage: UIImage(named: "placeholder"))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-ArticleDetailsView+\(articleDetails.ArticleID)")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Articles Detail Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func webViewDidFinishLoad(webView: UIWebView) {
        resizeConstraints()
    }
    
    
    func resizeConstraints()
    {
        let height = webViewDetails.scrollView.contentSize.height
        constraintsScrollViewHeight.constant = height + 160
        constraintsWebviewHeight.constant = height + 80
        print(height)
        self.view.layoutIfNeeded()
    }
    
}
