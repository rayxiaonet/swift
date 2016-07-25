//
//  GalleryController.swift
//  Filterer
//
//  Created by Ray Xiao on 7/23/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation
import UIKit

class GalleryTableViewController: UITableViewController {
    
    
    @IBAction func closeGallerySegue(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {});
        
        
    }
    var mainController:ViewController?
    @IBOutlet weak var galleryImageStackView: UIStackView!
    var loadMoreButton: UIButton!
    
    @IBOutlet var imageItemView: UIView!
    
    var urlSession: NSURLSession!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        return appDelegate.images.items.count+1 ?? 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (indexPath.row==0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("GalleryTableViewTopBar", forIndexPath: indexPath) as! GalleryTopViewCell
            loadMoreButton = cell.loadMoreButton
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("GalleryTableViewCell", forIndexPath: indexPath) as! GalleryTableViewCell
            let item = appDelegate.images.items[indexPath.row-1]
            cell.itemTitle.text=item.title
            
            
            let request = NSURLRequest(URL: NSURL(string: item.url)!)
            
            cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if error == nil && data != nil {
                        let image = UIImage(data: data!)
                        cell.itemImageView.image = image
                    }
                })
                
            }
            cell.dataTask?.resume()
            
            return cell
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? GalleryTableViewCell {
            cell.dataTask?.cancel()
        }
    }
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        print("tableview delete ")
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.images.items.removeAtIndex(indexPath.row-1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (row>0) {
            print("did select row at indexpath"+String(row))
            
            self.dismissViewControllerAnimated(true, completion: {});
            dispatch_async(dispatch_get_main_queue(), {
                
                self.mainController!.changeImage(((tableView.cellForRowAtIndexPath(indexPath) as! GalleryTableViewCell).itemImageView?.image)!)
            })
        }
        
    }
    
    @IBAction func closeGallery(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction{
        case UISwipeGestureRecognizerDirection.Right :
            print("Swipe right detected")
        case UISwipeGestureRecognizerDirection.Left :
            print("Swipe left detected")
        default:
            break
        }
    }
    
    @IBAction func onLoadMorePictures(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        loadMoreButton.setTitle("Loading images...",forState:UIControlState.Disabled)
        
        for i in 1...3 {
            let d = appDelegate.images.loadedDate.dateByAddingTimeInterval(Double(-1*60*60*24*i))
            appDelegate.addImage(d, completion: { (image) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    print("add a new image:"+String(image!.title))
                    appDelegate.images.items.append(image!)
                    self.tableView.reloadData()
                    self.loadMoreButton.enabled=true
                })
            })
            appDelegate.images.loadedDate=d
            
            
            
        }
        loadMoreButton.enabled=false
        
    }
    
    
}

class GalleryTopViewCell:UITableViewCell{
    @IBOutlet weak var loadMoreButton: UIButton!
    
}

class GalleryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemTitle: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

