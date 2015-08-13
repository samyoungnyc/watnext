//
//  VenueCollectionViewController
//  Whats Next
//
//  Created by computer on 5/8/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit

class VenueViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var venueItems: [Venue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: NavBar Styling
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "navlogo1")
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Fetch Venues for Grid
        fetchItems()
    }
    
    func fetchItems() {
        venueItems.removeAll(keepCapacity: false)
        let prepItems = Venue.query()
        
        prepItems?.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error: NSError?) -> Void in
            if (error == nil) {
                for object in objects! {
                    self.venueItems.append(object as! Venue)
                }
            } else {
                println("Error %@ %@", error, error!.userInfo!)
            }
            self.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueItems.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexpath: NSIndexPath) -> CGSize {
        var screenWidth = CGRectGetWidth(collectionView.bounds)
        var cellWidth = screenWidth/3.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("venueCell", forIndexPath: indexPath) as! VenueItemCell
        let currentItem = venueItems[indexPath.row]
        let imageView = PFImageView()
        imageView.image = UIImage(named: "2.png")
        imageView.file = currentItem.thumbImg
        imageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
            cell.imageView!.image = image
            cell.imageView.contentMode = .ScaleAspectFit
        }
        return cell
    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        //              prepare data for SelectScreen. use temporary variables, store, then
//        //              use instantiateViewController
//        //              then assign var's from SelectView to temporary variables above
//        //              then presentViewController
//        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! VenueItemCell!
//        
//        let selectVC: SelectViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("selectVC") as! SelectViewController
//        selectVC.currentVenue = venueItems[indexPath.row]
//        
//        presentViewController(selectVC, animated: true, completion: nil)
//    }
    
}
