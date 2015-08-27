
//  FeedViewController.swift


import UIKit
import CoreLocation
import MapKit

class FeedViewController: UITableViewController, CLLocationManagerDelegate {
    var feedItems: [FeedItem] = []
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var pickupLocation: CLLocationCoordinate2D?
    var dropoffLocation: CLLocationCoordinate2D?
    
    func getAndShowFeedItems() {
        feedItems.removeAll(keepCapacity: false)
        
        let getFeedItems = FeedItem.query()
        getFeedItems!.orderByDescending("createdAt")
        
        getFeedItems!.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    self.feedItems.append(object as! FeedItem)
                    if self.feedItems.count == 35 {
                        break
                    }
                }
            } else {
                println("Error with getAndShowFeedItems query")
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.resetUserDefaults()
        }
    }
    
    func resetUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "nextPushed")
        defaults.synchronize()
    }
    
    func uberButtonPressed(sender: UIButton!) {
        let senderButton = sender
        println(sender.tag)
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        callUber()
    }
    
    func callUber() {
        println("started function callUber")
        //Create an Uber Deep Link instance

        var uber = Uber(pickupLocation: self.pickupLocation!)
        uber.pickupNickname = "Current Location"
        uber.dropoffLocation = dropoffLocation
        println("Dropoff Latitude: \(uber.dropoffLocation?.latitude)")
        println("Dropoff Longitude: \(uber.dropoffLocation?.longitude)")
        uber.dropoffNickname = "Next Place"
        uber.deepLink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("Latitiude: \(self.dropoffLocation?.latitude)")
        
        // MARK: Set up Pull-To-Refresh
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("getAndShowFeedItems"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // MARK: NavBar Styling
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        tableView.allowsSelection = false
        
        // MARK: Navigation Image Setup
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 45))
        imageView.contentMode = .ScaleAspectFill
        let image = UIImage(named: "navlogo")
        imageView.image = image
        navigationItem.titleView = imageView
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getAndShowFeedItems()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    
    // MARK: TableView Delegate Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height - 112 // explanation needed
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedCell", forIndexPath: indexPath) as! FeedViewCell
        let currentItem = feedItems[indexPath.row]
        
        let date = currentItem.createdAt
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        let dateString = formatter.stringFromDate(date!)
        dropoffLocation = currentItem.location.iosLocation
        println("dropoff cell latitude \(dropoffLocation?.latitude)")
        println("dropoff cell longitude \(dropoffLocation?.longitude)")

        
        cell.userName?.text = currentItem.userName
        cell.venueName?.text = currentItem.venueName
        cell.timeStamp?.text = dateString
        
        // MARK: Setup image for cell
        cell.venueImage?.image = UIImage(named: "1.png")
        var image = currentItem.imageFile
        image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if !(error != nil) {
                cell.venueImage?.image = UIImage(data: imageData!)
                cell.imageView?.contentMode = .ScaleAspectFit
                cell.imageView?.clipsToBounds = true
            }
        }
    
        // MARK: Set up Uber Button
        cell.uberButton.tag = indexPath.row
        cell.uberButton.addTarget(self, action: "uberButtonPressed:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    //MARK: Delegate methods for CLLocationManager
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("location manager didUpdateLocations")
        let newLocation = locations.last as! CLLocation
        self.location = newLocation as CLLocation?
        self.pickupLocation = self.location!.coordinate as CLLocationCoordinate2D!
        
        if (self.pickupLocation != nil) {
            println("FeedView stoppedUpdatingLocations")
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error: \(error)")
    }
}

extension PFGeoPoint {
    public var iosLocation: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

