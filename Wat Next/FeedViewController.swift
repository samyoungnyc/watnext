
//  FeedViewController.swift


import UIKit

class FeedViewController: UITableViewController {
    var feedItems: [FeedItem] = []
    
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
            } else if error!.code == 100 {
                getFeedItems?.cancel()
                "print no network"
            } else  {
                print("Error with getAndShowFeedItems query")
            }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.resetUserDefaults()
            self.scrollToFirstRow()
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    func resetUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "nextPushed")
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Set up Pull-To-Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("getAndShowFeedItems"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        // MARK: NavBar Styling
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.BlackTranslucent
        
        // Turn off TableView Selection
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
        
        cell.userName?.text = currentItem.userName
        cell.venueName?.text = currentItem.venueName
        cell.timeStamp?.text = dateString
        
        // MARK: Setup image for cell
        cell.venueImage?.image = UIImage(named: "1.png")
        let image = currentItem.imageFile
        image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
            if !(error != nil) {
                cell.venueImage?.image = UIImage(data: imageData!)
                cell.imageView?.contentMode = .ScaleAspectFit
                cell.imageView?.clipsToBounds = true
            }
        }
        return cell
    }
}