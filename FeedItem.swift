//
//  FeedItem.swift
//  Whats Next 1
//
//  Created by Computer on 5/8/15.
//  Copyright (c) 2015 Computer. All rights reserved.
//

import UIKit

class FeedItem: PFObject, PFSubclassing {
    @NSManaged var venueName: String
    @NSManaged var imageFile: PFFile
    @NSManaged var userName: String
    @NSManaged var location: PFGeoPoint
    
    
    override class func initialize() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "FeedItem"
    }
}

