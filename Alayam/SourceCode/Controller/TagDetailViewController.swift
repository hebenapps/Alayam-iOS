//
//  TagDetailViewController.swift
//  
//
//  Created by jayaraj on 24/11/15.
//
//

import UIKit

class TagDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var news : UILabel!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    var tag : NSInteger!
    var arr : NSMutableArray = NSMutableArray()
    var model = HomeNewsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-TagDetailView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Tag Detail Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
        
        loadTagDetails()
    }
    
    @IBAction func btnMenuAction(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

    
    func loadTagDetails() {
        
    
        WebServiceHandler().getMethod(true, url: "http://mobile.alayam.com/api/Content?MobileRequest=SearchByTag&PageNo=1&RowsPerPage=10&SearchTag=\(tag)", header: nil, body: nil) { (dict, error) -> Void in
            
            if dict != nil
            {
                self.arr = HomeSliderNewsResponseDTO().initWithJsonRootDictionary(dict).Data.RegularNews
                
                print("\(self.arr)", terminator: "")
//                var item: NSDictionary = dict.objectForKey("Data") as! NSDictionary
//                self.arr = item.objectForKey("RegularNews") as! NSMutableArray
////                print("\(self.arr)")

                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeRegularNewsTableViewCellID", forIndexPath: indexPath) as! HomeRegularNewsTableViewCell
        
        let fullnews = self.arr.objectAtIndex(indexPath.row) as! SliderNewsDTO
        cell.configureWithData(fullnews)
        cell.setfontSize()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            cell.imgViewNews.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraint(NSLayoutConstraint(
                item:cell.imgViewNews, attribute:NSLayoutAttribute.Width,
                relatedBy:NSLayoutRelation.Equal,
                toItem:nil, attribute:NSLayoutAttribute.NotAnAttribute,
                multiplier:0, constant:200))
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailsViewController = getViewControllerInstance("Main", storyboardId: "HomeDetailViewControllerID") as! HomeDetailViewController
        detailsViewController.detailsTitle = ""
        
        detailsViewController.sliderNewsDetails = self.arr.objectAtIndex(indexPath.row) as! SliderNewsDTO
        
        detailsViewController.detailsTitle = (self.arr.objectAtIndex(indexPath.row) as! SliderNewsDTO).SectionName
        
        LocalCacheDataHandler().addToReadNewsForCache("\(detailsViewController.sliderNewsDetails.NewsMainID)")
        
        //            if !readNewsIds.containsObject("\(detailsViewController.sliderNewsDetails.NewsMainID)")
        //            {
        //                readNewsIds.addObject("\(detailsViewController.sliderNewsDetails.NewsMainID)")
        //            }
        
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
            return 120
        }
        return 91
    }
}
