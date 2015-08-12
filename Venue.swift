//
//  Venue.swift
//  Whats Next 1
//
//  Created by Computer on 5/8/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit

class Venue: PFObject, PFSubclassing {
    @NSManaged var venueName: String
    @NSManaged var thumbImg: PFFile
    @NSManaged var lgImg: PFFile
    @NSManaged var venueLocation: PFGeoPoint
    
    
    override class func initialize() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Venue"
    }
}

