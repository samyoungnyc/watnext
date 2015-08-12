//
//  FeedViewCell.swift
//  Wat Next
//
//  Created by computer on 8/12/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueImage: PFImageView!
    @IBOutlet weak var uberButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //change label fonts to bold
        userName.font = UIFont.boldSystemFontOfSize(17.0)
        timeStamp.font = UIFont.boldSystemFontOfSize(17.0)
        venueName.font = UIFont.boldSystemFontOfSize(17.0)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}