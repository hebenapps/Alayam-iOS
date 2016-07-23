//
//  WeatherViewController.swift
//  Alayam
//
//  Created by Mala on 7/20/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController,CLLocationManagerDelegate {

     @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var imgWeater: UIImageView!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //appDelegate.mm_drawerController setopenDrawerGestureModeMask = MMOpenDrawerGestureMode.None

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
   
    }
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "iOS-Weather Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])

    }
    @IBAction func menuButtonClick(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation:CLLocation = locations[0] 
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        //Do What ever you want with it
        //--- CLGeocode to get address of current location ---//
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks != nil && placemarks!.count > 0
            {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
       
    }
    
    
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            print(locality)
            print(postalCode)
            print(administrativeArea)
            print(country)
            
            lblCurrentLocation.text = locality
           let locationAddress = (locality ?? "") + "," + (country ?? "" ) + "," + (postalCode ?? "")
            downloadData(locationAddress)
        }
        
    }
    
    func downloadData(addr:String) {
        // Data
        var results = []
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        let json = JSON(url:"http://api.openweathermap.org/data/2.5/find?q=/(addr)&mode=json&units=metric")
        //static
       // let json = JSON(url:"http://api.openweathermap.org/data/2.5/find?q=Velachery,chennai,India&mode=json&units=metric")
        
        if let days = json["list"].asArray {
            var i:Int = 0
            for day in days {
              //  var temperature:Double = day["temp"]["day"].asDouble!
                let date:Double = day["dt"].asDouble!// get unix time
                let currentDate = NSDate(timeIntervalSince1970: date)//convert unix time to Date
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = dateFormatter.stringFromDate(currentDate)
                print(dateString) //prints out 10:12
                
                lblDate.text = dateString
                
                let temperature:Double = day["main"]["temp"].asDouble!
                let temp = String(format:"%.2f", temperature)
                lblCurrentTemp.text = temp + "\u{00B0}"
                let mintemp:Double = day["main"]["temp_min"].asDouble!
                lblMinTemp.text = String(format:"%.2f", mintemp) + "\u{00B0}"
                let maxtemp:Double = day["main"]["temp_max"].asDouble!
                lblMaxTemp.text = String(format:"%.2f", maxtemp) + "\u{00B0}"
               // var weather:Array = day["weather"].asArray!
                
                if let weatherArray = day["weather"].asArray{
                    if let aStatus = weatherArray[0].asDictionary{
                    let description:String = aStatus["description"]!.asString!
                        lblDescription.text = description
                        
                        var icon:String = aStatus["icon"]!.asString!
                        icon = "http://openweathermap.org/img/w/"+icon+".png"
                        if let url = NSURL(string: icon) {
                            if let data = NSData(contentsOfURL: url){
                                imgWeater.contentMode = UIViewContentMode.ScaleAspectFit
                                imgWeater.image = UIImage(data: data)
                            }
                        }
                        
                        
                    }
                }
                
                
                
               
                let pressure:Double = day["main"]["pressure"].asDouble!
                lblPressure.text = String(format:"%.2f", pressure)
                let humidity:Double = day["main"]["humidity"].asDouble!
                lblHumidity.text = String(format:"%.2f", humidity)
                let windspeed:Double = day["wind"]["speed"].asDouble!
                lblWindSpeed.text = String(format:"%.2f", windspeed)
                
                
            }
           
            
        }
    }

    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onClickSearchButton(sender: AnyObject) {
        let locationSearchViewController = getViewControllerInstance("Main", storyboardId: "LocationSearchViewController") as! LocationSearchViewController
        self.navigationController?.pushViewController(locationSearchViewController, animated: true)
    }

    @IBAction func onClickDoneButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- BusinessLogic methods

}
