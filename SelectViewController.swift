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
        var nextPushed = "fromSelectVC"
        defaults.setObject("nextPushed", forKey: "nextPushed")
        
        // Create FeedItem
        var feedItem = FeedItem()
        if let currentVenue = currentVenue {
            feedItem.venueName = currentVenue.venueName
            feedItem.imageFile = currentVenue.lgImg
            feedItem.location = currentVenue.venueLocation
            println(feedItem.location)
            feedItem.userName = PFUser.currentUser()!.username!
            feedItem.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: NavBar Styling
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        // MARK: Navigation Image Setup
        let navImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        navImageView.contentMode = .ScaleAspectFit
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


