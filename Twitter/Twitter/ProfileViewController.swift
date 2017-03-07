//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Tim Kim on 3/6/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    var user: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profilePictureUrlString = user?["profile_image_url_https"] as? String
        let profilePictureUrl = URL(string: profilePictureUrlString!)
        profilePicture.setImageWith(profilePictureUrl!)
        
        let profileBannerUrlString = user?["profile_banner_url"] as? String
        
        if profileBannerUrlString != nil {
            let profileBannerUrl = URL(string: profileBannerUrlString!)
            profileBanner.setImageWith(profileBannerUrl!)
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = profileBanner.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            profileBanner.addSubview(blurEffectView)
        }
        
        let screenName = user!["screen_name"] as! String
        self.screenName.text = "@\(screenName)"
        userName.text = user!["name"] as? String
        
        let status_count = user!["statuses_count"]!
        self.tweetsLabel.text = "\(status_count)"
        let follower_count = user!["followers_count"]!
        self.followingLabel.text = "\(follower_count)"
        let friend_count = user!["friends_count"]!
        self.followersLabel.text = "\(friend_count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
