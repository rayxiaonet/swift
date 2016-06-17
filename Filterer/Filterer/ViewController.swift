//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var filteredImage: UIImage? {
        didSet{
            compareButton.enabled = true
            adjustButton.enabled = true
        }
    }
    var showingOriginal = true
    let originalImage = UIImage(named:"scenery")!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet var secondaryMenu: UIView!
    
    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet var thirdMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet weak var adjustButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var redFilterButton: UIButton!
    @IBOutlet weak var greenFilterButton: UIButton!
    @IBOutlet weak var blueFilterButton: UIButton!
    @IBOutlet weak var yellowFilterButton: UIButton!
    @IBOutlet weak var purpleFilterButton: UIButton!
    @IBOutlet weak var originalLabel: UILabel!
    
    let redFilter = RGBAImageFilter(filterRed:true)
    let greenFilter = RGBAImageFilter(filterGreen:true)
    let blueFilter = RGBAImageFilter(filterBlue:true)
    let yellowFilter = RGBAImageFilter(filterRed:true,filterGreen:true)
    let purpleFilter = RGBAImageFilter(filterBlue:true,filterRed:true)
    
    var currentFilter:RGBAImageFilter?
    
    func switchImage() {
        
        if (filteredImage != nil) {
            originalLabel.hidden = (imageView!.image == originalImage)
            
            if (imageView!.image==originalImage){
                animateNewImage(filteredImage!)
                
            }else{
                animateNewImage(originalImage)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        compareButton.enabled = (filteredImage != nil)
        
        let tapGestureRecognizer = UILongPressGestureRecognizer(target:self, action:Selector("imageTapped:"))
        tapGestureRecognizer.minimumPressDuration = 0
        
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        coverImage.alpha=0
        filterSlider.hidden=true
        adjustButton.enabled=false
        
    }
    
    
    func imageTapped(recognizer: UILongPressGestureRecognizer)
    {
        if recognizer.state == .Began{
            switchImage()
        } else if  recognizer.state == .Ended {
            switchImage()
        }
    }
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView!.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView!.image = image
        }
    }
    func animateNewImage(newImage:UIImage!) {
        originalLabel.hidden = (newImage != originalImage)
        coverImage.image=imageView!.image
        imageView!.image=newImage
        self.coverImage.alpha = 1
        
        UIView.animateWithDuration(1.5,
                                   animations: {
                                    self.coverImage.alpha = 0.0
            }
        )
        
    }
    
    @IBAction func redFilterButtonClick(sender: AnyObject) {
        currentFilter=redFilter
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        animateNewImage(filteredImage)
        
    }
    @IBAction func greenFilterButtonClick(sender: AnyObject) {
        currentFilter=greenFilter
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        animateNewImage(filteredImage)
    }
    @IBAction func blueFilterButtonClick(sender: AnyObject) {
        currentFilter=blueFilter
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        animateNewImage(filteredImage)
    }
    @IBAction func yellowFilterButtonClick(sender: AnyObject) {
        currentFilter=yellowFilter
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        animateNewImage(filteredImage)
    }
    @IBAction func purpleFilterButtonClick(sender: AnyObject) {
        currentFilter=purpleFilter
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        animateNewImage(filteredImage)
    }
    @IBAction func compareButtonClick(sender: AnyObject) {
        switchImage()
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
            
            filterSlider.hidden=true
            adjustButton.selected = false
        }
    }
    
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }
    
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    @IBAction func filterSliderChange(sender: UISlider) {
        filteredImage = currentFilter!.apply(originalImage,val:Int(filterSlider.value))
        imageView!.image=filteredImage
        
    }
    @IBAction func onAdjustClick(sender: UIButton) {
        if (sender.selected) {
            filterSlider.hidden=true
            sender.selected = false
            
        } else {
            filterSlider.hidden=false
            sender.selected = true
            
            filterButton.selected = false
            hideSecondaryMenu()
        }
        
    }
    
}

