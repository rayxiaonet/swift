//
//  AppDelegate.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let images: GalleryImage = GalleryImage(items: [GalleryImageItem](),toDate:NSDate())
    let DATE_FORMAT = NSDateFormatter()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSUserDefaults.standardUserDefaults().registerDefaults(["BaseImageURLString": "https://api.nasa.gov/planetary/apod"])
        //?api_key=\(apiKey)&date=\(dateString)
        NSUserDefaults.standardUserDefaults().registerDefaults(["ApiKey": "g6pZMgcGZJ2cAUpaoy1taxfpSUXEopS8tcn5pgeH"])
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        DATE_FORMAT.dateFormat = "yyyy-MM-dd"
        let CALENDAR = NSCalendar.currentCalendar()
        
        for i in 0..<3 {
            let d = CALENDAR.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: [])
            
            
            self.addImage(d!, completion: { (image) -> Void in
                print("add a new image:"+String(image!.title))
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

                    self.images.items.append(image!)
                }
            })
        }
        
        let toDate = CALENDAR.dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
        self.images.loadedDate=toDate!
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is aboutw to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func addImage(date:NSDate,completion: (imageItem: GalleryImageItem?) -> Void) {
        let baseUrlString = NSUserDefaults.standardUserDefaults().stringForKey("BaseImageURLString")
        let apiKey = NSUserDefaults.standardUserDefaults().stringForKey("ApiKey")
        

        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let serviceGroup = dispatch_group_create();
        
        dispatch_group_enter(serviceGroup)
        
        let dateString = DATE_FORMAT.stringFromDate(date)
        let imageUrlString = baseUrlString!+"?api_key="+apiKey!+"&date="+dateString
        
        print(imageUrlString)
        let imageUrl =  NSURL(string: imageUrlString)
        let dataTask: NSURLSessionDataTask = defaultSession.dataTaskWithURL(imageUrl!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print(data)
                    var jsonObject:Dictionary<String,AnyObject>?
                    
                    do {
                        jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue:0)) as? Dictionary<String,AnyObject>
                        if let url = jsonObject!["url"] as? String{
                           let date = self.DATE_FORMAT.dateFromString((jsonObject!["date"] as? String)!)
                            print("url is :"+url)
                            let title = jsonObject!["title"] as? String
                            let item = GalleryImageItem(url:url,title: title!,  date:date!)
                            completion(imageItem:item )
                        }
                    }catch{
                        print("failed to load image")
                        completion(imageItem: GalleryImageItem(url:"",title: "",  date:date) )
                        
                        
                    }
                    
                }
                
            }
        }
        dataTask.resume()
        
    }
    
    
}





