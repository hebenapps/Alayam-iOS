//
//  PDFReaderViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PDFReaderViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,PDFModelDelegate {

    var aryPDFList:[String] = ["الصفحات الكاملة","صفحات الرياضة","صفحات الاقتصاد"]
    var model = PDFModel()
    var pdfURL_AllPath = ""
    var pdfURL_Sports = ""
    var pdfURL_Economic = ""
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        model.getPDFList()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 25)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "iOS-PDF Reader Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refreshPDF()
    {
        if model.PDFList.count > 0
        {
            let pdfDetails = model.PDFList.objectAtIndex(0) as! PDFDTO
            
            pdfURL_AllPath = pdfDetails.AllPath
            pdfURL_Sports = pdfDetails.SportPath
            pdfURL_Economic = pdfDetails.EconamicPath
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnMenuAction(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return aryPDFList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let mycell = tableView.dequeueReusableCellWithIdentifier("PDFListCell", forIndexPath: indexPath) as! PDFListTableViewCell
        mycell.lblPDFName.text = aryPDFList[indexPath.row]
        mycell.setFontSize()
        return mycell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {        
        switch(indexPath.row)
        {
        case 0:
            let pdfDetailsViewController = getViewControllerInstance("Main", storyboardId: "PDFDetailViewController") as! PDFDetailViewController
            pdfDetailsViewController.pdfURL = pdfURL_AllPath
            pdfDetailsViewController.lblTitle = aryPDFList[indexPath.row]
            googleAnalyticsEvent("All PDF Tapped", action: "All News PDF", label: "", value: 0)
            self.navigationController?.pushViewController(pdfDetailsViewController, animated: true)
            break;
        case 1:
            let pdfDetailsViewController = getViewControllerInstance("Main", storyboardId: "PDFDetailViewController") as! PDFDetailViewController
            pdfDetailsViewController.pdfURL = pdfURL_Sports
            pdfDetailsViewController.lblTitle = aryPDFList[indexPath.row]
            googleAnalyticsEvent("Sports PDF Tapped", action: "Sports PDF", label: "", value: 0)
            self.navigationController?.pushViewController(pdfDetailsViewController, animated: true)
            break;
        case 2:
            let pdfDetailsViewController = getViewControllerInstance("Main", storyboardId: "PDFDetailViewController") as! PDFDetailViewController
            pdfDetailsViewController.pdfURL = pdfURL_Economic
            pdfDetailsViewController.lblTitle = aryPDFList[indexPath.row]
            googleAnalyticsEvent("Economic PDF Tapped", action: "Economic PDF", label:"" , value: 0)
            self.navigationController?.pushViewController(pdfDetailsViewController, animated: true)
            break;
        default:
            break;
        }
    }
    
    func googleAnalyticsEvent(category: String, action: String, label: String, value: NSNumber)
    {
        let tracker = GAI.sharedInstance().defaultTracker
        let builder =  GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(builder.build() as [NSObject : AnyObject])
       
    }

}
