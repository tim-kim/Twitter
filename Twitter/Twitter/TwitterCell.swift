//
//  TwitterCell.swift
//  Twitter
//
//  Created by Tim Kim on 2/27/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {
    
    var user: User!
    var tweet: Tweet!
    var tweetID: Int = 0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onRetweet(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.retweet(success: { (tweet: Tweet) in
            print(tweet.retweetCount)
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
            self.retweetCountLabel.textColor = UIColor.green
        }, failure: { (error: Error) in
            self.onUnretweet()
        }, tweetID: tweetID)
    }
    
    func onUnretweet() {
        TwitterClient.sharedInstance?.unretweet(success: { (tweet: Tweet) in
            print("unretweet")
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            self.retweetCountLabel.textColor = UIColor.black
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("unretweet failed. Error code: \(error.localizedDescription)")
        }, tweetID: tweetID)
    }

    @IBAction func onFavorite(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.favorite(success: { (tweet: Tweet) in
            print(tweet.favoritesCount)
            self.favoriteCountLabel.text = "\(tweet.favoritesCount)"
            self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
            self.favoriteCountLabel.textColor = UIColor.red
            
        }, failure: { (error: Error) in
            self.onUnfavorite()
        }, tweetID: tweetID)
    }
    
    func onUnfavorite() {
        TwitterClient.sharedInstance?.unfavorite(success: { (tweet: Tweet) in
            self.favoriteCountLabel.text = "\(tweet.favoritesCount)"
            self.favoriteCountLabel.textColor = UIColor.black
            self.favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("unfavorite failed. Error code: \(error.localizedDescription)")
        }, tweetID: tweetID)
    }
    
    
}
