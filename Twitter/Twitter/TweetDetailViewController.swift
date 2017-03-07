//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Tim Kim on 3/6/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    var tweet: Tweet!
    weak var delegate: refreshDelegate?
    
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var retweetNumLabel: UILabel!
    @IBOutlet weak var favoritesNumLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInformation()
    }
    
    func setInformation() {
        self.userID.text = "@" + (tweet.screenName as! String)
        self.userName.text = tweet.userName as? String
        self.favoritesNumLabel.text = String(tweet.favoritesCount)
        self.retweetNumLabel.text = String(tweet.retweetCount)
        let timeAgo = Int(Date().timeIntervalSince(tweet.timestamp! as Date))
        let ago = convertTimeAgo(seconds: timeAgo)
        self.tweetTimeLabel.text = ago
        self.tweetContentLabel.text = tweet.text as? String
        let profileUrl = URL(string: tweet.profileUrl as String!)
        self.profileImageView.setImageWith(profileUrl!)
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
        TwitterClient.sharedInstance?.retweet(success: { (newtweet: Tweet) in
            self.retweetNumLabel.text = "\(newtweet.retweetCount)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        }, tweetID: tweet.tweetID as! String)
        self.delegate?.didChangeHome()
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
        TwitterClient.sharedInstance?.favorite(success: { (newtweet: Tweet) in
            self.favoritesNumLabel.text = "\(newtweet.favoritesCount)"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        }, tweetID: tweet.tweetID as! String)
        self.delegate?.didChangeHome()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination.childViewControllers[0] as! EditTweetViewController
        vc.delegate = self.delegate
        vc.isReply = 1
        vc.replyID = self.tweet.tweetID
        vc.replyToUser = self.tweet.screenName
    }
}
