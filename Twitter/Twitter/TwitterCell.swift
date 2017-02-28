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

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(_ sender: AnyObject) {
        self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.normal)
        self.retweetCountLabel.textColor = UIColor.green
        
        TwitterClient.sharedInstance?.retweet(success: { (tweet: Tweet) in
            print(tweet.retweetCount)
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            }, tweetID: tweetID)
    }

    @IBAction func onFavorite(_ sender: AnyObject) {
        self.favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.normal)
        self.favoriteCountLabel.textColor = UIColor.red
        
        TwitterClient.sharedInstance?.favorite(success: { (tweet: Tweet) in
            print(tweet.favoritesCount)
            self.favoriteCountLabel.text = "\(tweet.favoritesCount)"
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            }, tweetID: tweetID)
    }
    
    
}
