//
//  VenueCollectionViewController
//  Whats Next
//
//  Created by computer on 5/8/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var venueItems: [Venue] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func fetchItems() {


        let prepItems = Venue.query()
        
        if searchBar.text != "" {
            prepItems?.whereKey("venueName", containsString: searchBar.text?.lowercaseString)
        }
        
        prepItems?.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error: NSError?) -> Void in
            self.venueItems.removeAll(keepCapacity: true)
            if (error == nil) {
                for object in objects! {
                    self.venueItems.append(object as! Venue)
                }
            } else {
                print("Error %@ %@", error, error!.userInfo)
            }
                self.collectionView?.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("search and found: \(venueItems.count) items")
        self.fetchItems()
        

    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // clear search criteria
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.fetchItems()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // MARK: NavBar Styling
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        imageView.contentMode = .ScaleAspectFill
        let image = UIImage(named: "navlogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        //serach bar delegate
        searchBar.delegate = self
        
        
                let cellWidth = ((UIScreen.mainScreen().bounds.width)) / 3
                print(cellWidth)
                let cellLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                cellLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        fetchItems()
        
        // Defaults for segueing
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("nextPushed") {
            performSegueWithIdentifier("tab0", sender: self)
        } else {
            print("default reset to nil in FeedView")
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venueItems.count
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexpath: NSIndexPath) -> CGSize {
//        let screenWidth = CGRectGetWidth(collectionView.bounds)
//        let cellWidth = screenWidth/3.0
//        return CGSize(width: cellWidth, height: cellWidth)
//    }
//    
    //
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
                return 0
        }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("venueCell", forIndexPath: indexPath) as! VenueItemCell
        let currentItem = venueItems[indexPath.row]
        let imageView = PFImageView()
        imageView.image = UIImage(named: "2.png")
        imageView.file = currentItem.thumbImg
        imageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
            cell.imageView!.image = image
            //cell.imageView.contentMode = .ScaleAspectFit
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("selectNavController") as! UINavigationController
        let selectVC = selectNavigationController.topViewController as! SelectViewController
        selectVC.currentVenue = venueItems[indexPath.row]
        
        presentViewController(selectNavigationController, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.frame.size.width/3.0;
        return CGSize(width: width, height: width);
    }
    
}
