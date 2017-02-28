//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Tim Kim on 2/27/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        refreshTable()
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    func refreshTable() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error) in
                print("error: \(error.localizedDescription)")
        })
        self.isMoreDataLoading = false;
        self.loadingMoreView!.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TwitterCell
        let tweet = tweets[indexPath.row]

        cell.descriptionLabel.text = tweet.text!
        cell.retweetCountLabel.text = String(tweet.retweetCount)
        cell.favoriteCountLabel.text = String(tweet.favoritesCount)
        cell.nameLabel.text = tweet.name
        cell.handleLabel.text = tweet.screenname
        cell.profileImageView.setImageWith(tweet.profileUrl!)
        cell.tweetID = tweet.tweetID
        cell.dateLabel.text = tweet.timestampString
        
        return cell
    }
    
    @IBAction func onLogout(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                refreshTable()
            }
        }
    }

}
