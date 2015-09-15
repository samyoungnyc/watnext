
//  FeedViewController.swift


import UIKit

class FeedViewController: UITableViewController {
    var feedItems: [FeedItem] = []
    

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
        
        // TableView separator style (get's rid of black lines in tableview) 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        return self.view.frame.height - 112
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
        if let image = UIImage(data: currentItem.imageData)
        {
            cell.venueImage?.image = image
            cell.imageView?.contentMode = .ScaleAspectFit
            cell.imageView?.clipsToBounds = true
        } else {
            cell.venueImage?.image = UIImage(named: "1.png")
            
            
            let image = currentItem.imageFile
            image.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if !(error != nil) {
                    currentItem.imageData = imageData!
                    let index = self.feedItems.indexOf(currentItem)
                    if index != NSNotFound
                    {
                        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: .None)
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func getAndShowFeedItems() {

        self.tableView.reloadData()
        let getFeedItems = FeedItem.query()
        getFeedItems!.orderByDescending("createdAt")
        getFeedItems!.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            self.feedItems.removeAll(keepCapacity: false)
            if error == nil {
                for object in objects! {
                    self.feedItems.append(object as! FeedItem)
                    if self.feedItems.count == 35 {
                        break
                    }
                }
            } else if error!.code ==  PFErrorCode.ErrorConnectionFailed.rawValue {
                self.showNetworkAlert()
                print("there's a networking problem")
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
    
    func showNetworkAlert() {
        let networkAlert = UIAlertController(title: "Oops!", message: "You aren't connected, this will cause problems", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
        }
        networkAlert.addAction(OKAction)
        
        self.presentViewController(networkAlert, animated: true) {
            print("unreachable alert shown")
        }
    }
}