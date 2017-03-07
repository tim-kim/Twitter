//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Tim Kim on 2/27/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshDelegate {
    
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 0.217, green: 0.658, blue: 1.000, alpha: 0.5)
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshTable()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            print("yes tweets?")
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func refreshTable() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
        refreshControl.endRefreshing()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TwitterCell
        let tweet = tweets[indexPath.row]
        cell.textInfoLabel.text = tweet.text as String?
        
        var screenName = "@"
        screenName.append((tweet.screenName as String?)!)
        
        cell.userIDLabel.text = screenName
        cell.userNameLabel.text = tweet.userName as String?
        cell.favoriteNum.text = String(tweet.favoritesCount)
        cell.retweetNum.text = String(tweet.retweetCount)

        let time = Int(Date().timeIntervalSince(tweet.timestamp! as Date))
        let ago = convertTimeAgo(seconds: time)
        cell.tweet = tweet
        cell.dateLabel.text = ago
        cell.tweetID = tweet.tweetID

        let profileUrl = URL(string: tweet.profileUrl as String!)
        cell.profileImageView.setImageWith(profileUrl!)
        cell.profiledelegate = self
        
        return cell
    }
    
    func convertTimeAgo(seconds: Int) -> String {
        var result: String?
        if(seconds/60 <= 59) {
            result = "\(seconds/60) m"
        } else if (seconds/3600 <= 23) {
            result = "\(seconds/3600) h"
        } else {
            result = "\(seconds/216000) d"
        }
        return result!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectCellSegue") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let sentTweet = tweets[indexPath!.row]
            let vc = segue.destination as! TweetDetailViewController
            vc.tweet = sentTweet
            vc.delegate = self
        }
        if (segue.identifier == "postTweetSegue"){
            let vc = segue.destination.childViewControllers[0] as! EditTweetViewController
            vc.delegate = self
            vc.isReply = 0
        }
        if (segue.identifier == "replyFromCell") {
            let button = sender as! UIButton
            let cell = button.superview?.superview as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let sentTweet = tweets[indexPath!.row]
            let vc = segue.destination.childViewControllers[0] as! EditTweetViewController
            vc.delegate = self
            vc.isReply = 1
            vc.replyID = sentTweet.tweetID
            vc.replyToUser = sentTweet.screenName
        }
    }
    
    func didChangeHome() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
}

extension TweetsViewController: TweetCellDelegate{
    func profileImageTapped(cell: TwitterCell, user: NSDictionary) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
            profileVC.user = user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
