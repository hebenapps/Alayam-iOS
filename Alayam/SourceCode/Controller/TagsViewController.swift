//
//  TagsViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController, TagsViewControllerModelDelegate,DWTagListDelegate, UIWebViewDelegate {
    
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewShowTags: UIView!
    var sphereView : DBSphereView!
    //var squareView : DKTagCloudView!
    var squareView : DWTagList!
    
    var model = TagsViewControllerModel()
    
    var isNavigateFromMenu = false
    var isSphere : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        model.delegate = self
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        
        sphereView = DBSphereView(frame: CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width))
//        squareView = DKTagCloudView(frame:CGRectMake(0, 0,
//            self.view.frame.size.width,
//            self.view.frame.size.height-100));
        squareView = DWTagList(frame:CGRectMake(0, 0,
            self.view.frame.size.width,
            self.view.frame.size.height-100));
        
        model.getTags()
        
        if isNavigateFromMenu
        {
            btnBack.hidden = true
            btnMenu.hidden = false
        }
        else
        {
            btnBack.hidden = false
            btnMenu.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2

        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-TagsView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "Tags Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    
    func tagsSelected(btn: UIButton)
    {
        
        sphereView.timerStop()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
//            var rect = btn.frame
//            rect.origin.x -= 200
//            rect.size.width = 300
//            btn.frame = rect
            
        })
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
        }) { (completed) -> Void in
            
            btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }
        
        print("\(btn.tag)", terminator: "")
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TagDetailViewController") as! TagDetailViewController
        secondViewController.tag = btn.tag
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func btnMenuAction(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)

    }
    //MARK: TagsViewControllerModelDelegate methods
    
    func refreshTagsList() {
        
        let array = NSMutableArray(capacity: 0)
        
        let limit = model.tagsList.count > 20 ? 20 : model.tagsList.count
        
        for (var i = 0; i < limit; i++ ) {
            let btn: UIButton = UIButton(type: UIButtonType.System)// [UIButton buttonWithType:UIButtonTypeSystem];
            
            let title = model.tagsList.objectAtIndex(i) as! TagsDTO
            
            btn.setTitle(title.Name, forState: UIControlState.Normal)
            btn.tag = title.TagID as Int
            btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad{
                 btn.titleLabel?.font = UIFont.systemFontOfSize(34)// [UIFont systemFontOfSize:12.];
            }else{
                btn.titleLabel?.font = UIFont.systemFontOfSize(20)// [UIFont systemFontOfSize:12.];
            }
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            btn.frame = CGRectMake(0, 0, 100, 20);
            btn.addTarget(self, action: Selector("tagsSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
            btn.sizeToFit()
            array.addObject(btn)
            sphereView.addSubview(btn as UIView)
            
        }
        
        sphereView.setCloudTags(array as [AnyObject])
        
//                sphereView.backgroundColor = UIColor.greenColor()
        self.viewShowTags.addSubview(sphereView)
        
    }
    
    @IBAction func btnSquareClicked(sender: AnyObject) {
        
//        if(isSphere == true){
//            isSphere = false
//        sphereView.removeFromSuperview()
//        self.viewShowTags.addSubview(squareView)
//        squareView.maxFontSize = 10
//        
//        var array = NSMutableArray(capacity: 0)
//        
//        var limit = model.tagsList.count > 40 ? 40 : model.tagsList.count
//        
//        for (var i = 0; i < limit; i++ ) {
//             var title = model.tagsList.objectAtIndex(i) as! TagsDTO
//            var tagName = title.Name
//            array.addObject(tagName)
//        }
//        squareView.titls = array as [AnyObject]
//        squareView.generate()
//        }
        
        
        if(isSphere == true)
        {
            isSphere = false
            sphereView.removeFromSuperview()
            self.viewShowTags.addSubview(squareView)
            let array = NSMutableArray(capacity: 0)
    
            let limit = model.tagsList.count > 40 ? 40 : model.tagsList.count
    
            for (var i = 0; i < limit; i++ ) {
                 let title = model.tagsList.objectAtIndex(i) as! TagsDTO
                let tagName = title.Name
                array.addObject(tagName)
            }
            
            squareView.automaticResize = true
            squareView.setTags(array as [AnyObject])
            squareView.tagDelegate = self

        }
    }
    
    func selectedTag(tagName: String!, tagIndex: Int) {
        let alert = UIAlertController(title: "Message", message: "You tapped tag \(tagName) at index \(tagIndex)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSphereClicked(sender: AnyObject) {
        if(isSphere == false){
            isSphere = true
        squareView.removeFromSuperview()
         sphereView = DBSphereView(frame: CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width))
        refreshTagsList()
        }
    }
    

}
