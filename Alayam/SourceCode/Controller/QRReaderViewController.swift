//
//  ORReaderViewController.swift
//  Alayam
//
//  Created by Mala on 7/30/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIWebViewDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    var alreadyLaunched = false
    //webview
    @IBOutlet weak var webview:UIWebView!
    @IBOutlet weak var btnClose:UIButton!
    @IBOutlet weak var viewWebPage:UIView!
    @IBOutlet weak var viewCamera:UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = AppDelegate()
        appdelegate.Loadwebview(self.view, target: self)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 23)
            lblTitle.font = UIFont(name: lblTitle.font.fontName, size: 23)
        }
        loadWebViewDesign()
        self.viewWebPage.hidden = true
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        self.view.layoutIfNeeded()
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = supportedBarCodes
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = viewCamera.layer.bounds
        viewCamera.layer.addSublayer(videoPreviewLayer!)
        viewCamera.layer.masksToBounds = true
        videoPreviewLayer?.masksToBounds = true
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
       view.bringSubviewToFront(messageLabel)
        
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        view.bringSubviewToFront(viewHeader)
    }
    override func viewWillAppear(animated: Bool) {
        
        //Tracker 1 & 2
        let tracker2 = GAI.sharedInstance().trackerWithTrackingId("UA-27381894-2")
        tracker2.set(kGAIScreenName, value: "iOS-QRReaderView")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker2.send(builder.build() as NSDictionary as! [NSObject : AnyObject])
//        var tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: "QR Reader Screen")
//        
//        var builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidDisappear(animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebViewDesign()
    {
        btnClose.layer.cornerRadius = 20
        btnClose.layer.borderColor = UIColor.whiteColor().CGColor
        btnClose.layer.borderWidth = 2
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.filter({ $0 == metadataObj.type }).count > 0 {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                launchApp(metadataObj.stringValue)
            }
        }
    }
    
    func launchApp(decodedURL: String) {
        
        if alreadyLaunched
        {
            return
        }
        
        self.alreadyLaunched = true
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .ActionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            if let url = NSURL(string: decodedURL) {
                self.captureSession?.stopRunning()
                self.viewWebPage.hidden = false
                self.viewCamera.hidden = true
                self.messageLabel.hidden = true
                self.webview.loadRequest(NSURLRequest(URL:url))
                self.qrCodeFrameView?.hidden = true
//                if UIApplication.sharedApplication().canOpenURL(url) {
//                    UIApplication.sharedApplication().openURL(url)
//                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: { (action) -> Void in
            self.alreadyLaunched = false
        })
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        self.presentViewController(alertPrompt, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Button Actions 
    @IBAction func btnMenuAction(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }
    
     @IBAction func btnCloseAction(sender: AnyObject) {
        alreadyLaunched = false
        self.viewWebPage.hidden = true
        self.viewCamera.hidden = false
        captureSession?.startRunning()
        self.messageLabel.hidden = false
        qrCodeFrameView?.hidden = false
    }
    
    //MARK:- WebView Delegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        
    }

    
}

