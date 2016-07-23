//
//  ShareNewsViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class ShareNewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var webView: UIWebView!
    
    var menuTitle = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblViewArticle: UITableView!
    var categoryList = ""
    
//    let articleAPI = "http://mobile.alayam.com/api/Content?MobileRequest=GetCategoryNews&PageNo=1&RowsPerPage=10&Category=%@&IssueID=0&Type=article"
    
    var tableViewList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = menuTitle
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        tblViewArticle.delegate = self
        tblViewArticle.dataSource = self
//        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.alayam.com/writers")!))
        
        
        let url : NSString = "http://mobile.alayam.com/api/Content?MobileRequest=GetCategoryNews&PageNo=1&RowsPerPage=10&Category=\(categoryList)&IssueID=0&Type=article"
        
        WebServiceHandler().getMethod(true, url: url as String, header: ["authorization" : ""], body: nil) { (responseDict, error) -> Void in
            
            if let responseValue = responseDict
            {
               let response = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(responseDict)
                self.tableViewList = response.Data.Articles
                self.tblViewArticle.reloadData()
                
            }
            else
            {
                
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "iOS-Share News Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])

    }

    @IBAction func btnMenuAction(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK:- TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return tableViewList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ArticleListCell
        let news = tableViewList.objectAtIndex(indexPath.row) as! ArticlesDTO
        
        cell.lblArticleTitle.text = news.ArticleTitle
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            cell.lblArticleTitle.font = UIFont(name: cell.lblArticleTitle.font.fontName, size: 20)
        }
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: news.WriterImageURL_S)!)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        cell.imgViewArticleimage.setImageWithUrlRequest(request, placeHolderImage: UIImage(named: "tumbnailplaceholder"), success: { (request, response, image, fromCache) -> Void in
            cell.imgViewArticleimage.image = image
            
            }, failure: { (request, response, error) -> Void in
                
        })
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 91
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailsViewController = getViewControllerInstance("Main", storyboardId: "ArticleDetailsViewControllerID") as! ArticleDetailsViewController
        detailsViewController.articleDetails = tableViewList.objectAtIndex(indexPath.row) as! ArticlesDTO
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    

}
