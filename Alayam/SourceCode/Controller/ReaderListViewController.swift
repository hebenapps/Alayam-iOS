//
//  ReaderListViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class ReaderListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReadersListModelDelegate, UIWebViewDelegate {
    
    var model = ReadersListModel()

    @IBOutlet weak var tblViewReadersList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        model.delegate = self
        self.edgesForExtendedLayout = UIRectEdge.None
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        model.refreshReadersList()
        
        //Tracker 1 & 2

        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-ReaderListView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
        
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Reader List Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenuAction(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

    //MARK:- TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if model.readersList == nil
        {
            return 0
        }
        
        return model.readersList!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeRegularNewsTableViewCellID", forIndexPath: indexPath) as! HomeRegularNewsTableViewCell
        let news = model.readersList!.objectAtIndex(indexPath.row) as! ReadersEntity
        cell.configureWithData(news.categoryNewsDTO)
        cell.setfontSize()
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 91
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailsViewController = getViewControllerInstance("Main", storyboardId: "HomeDetailViewControllerID") as! HomeDetailViewController
        detailsViewController.sliderNewsDetails = (model.readersList!.objectAtIndex(indexPath.row) as! ReadersEntity).categoryNewsDTO
        detailsViewController.detailsTitle = "قائمة القراءة"
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    //MARK:- Model Delegate
    
    func refreshTableView()
    {
        tblViewReadersList.reloadData()
        
    }


}
