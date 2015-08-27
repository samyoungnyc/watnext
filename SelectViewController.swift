//
//  SelectViewController.swift
//  Wat Next
//
//  Created by computer on 8/13/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit
import QuartzCore

class SelectViewController: UIViewController {
    
    
    
    @IBOutlet weak var venueName: UILabel!
    
    @IBOutlet weak var imageView: PFImageView!
    
    @IBOutlet weak var nextButton: GlowingButton!
    
    var currentVenue: Venue?
    
    @IBAction func backTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func nextTapped(sender: UIButton) {
        // Set defaults for segueing in next View
        let defaults = NSUserDefaults.standardUserDefaults()
        _ = "fromSelectVC"
        defaults.setObject("nextPushed", forKey: "nextPushed")
        
        
        
        // Create FeedItem
        let feedItem = FeedItem()
        if let currentVenue = currentVenue {
            let user = PFUser.currentUser()
            feedItem.venueName = currentVenue.venueName
            feedItem.imageFile = currentVenue.lgImg
            feedItem.location = currentVenue.venueLocation
            feedItem.userName = user!.username!
            // add user feedCHoice tracking
            user!.param.append(feedItem.venueName)
            user!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                print(user?.objectForKey("feedChoice"))
            })
            
        }
        feedItem.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: NavBar Styling
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        // MARK: Navigation Image Setup
        let navImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 165, height: 45))
        //        imageView.contentMode = .ScaleAspectFill
        let navImage = UIImage(named: "navlogo")
        navImageView.image = navImage
        navigationItem.titleView = navImageView
        
        // Set Glow Animation on Next Button
        
        nextButton.startGlowWithCGColor(UIColor.yellowColor().CGColor)
        
        // Set Fonts
        venueName.font = UIFont.boldSystemFontOfSize(17.0)
        
        if let currentVenue = currentVenue {
            venueName.text = currentVenue.venueName
            imageView.image = UIImage(named: "2.png")
            imageView.file = currentVenue.lgImg
            imageView.loadInBackground({ (image: UIImage?, error: NSError?) -> Void in
                self.imageView.image = image
                self.imageView.contentMode = .ScaleAspectFit
            })
        }
    }
}

// this extension makes it possible to cast 'feedChoice' either as a String or as an empty array, depending on if it is nil
extension PFUser {
    var param: [String] {
        get {
            if let x = self["feedChoice"] as? [String] {
                return x
            } else {
                return []
            }
        }
        set(val) {
            self["feedChoice"] = val
        }
    }
}


