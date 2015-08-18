//
//  SelectViewController.swift
//  Wat Next
//
//  Created by computer on 8/13/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {

    @IBOutlet weak var venueName: UILabel!
    
    @IBOutlet weak var imageView: PFImageView!
    
    @IBAction func backTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        println("backbuttonpress")
    }
    var currentVenue: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
