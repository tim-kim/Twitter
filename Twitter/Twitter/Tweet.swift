//
//  Tweet.swift
//  Twitter
//
//  Created by Tim Kim on 2/27/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: NSDictionary?
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var screenName: NSString?
    var userName: NSString?
    var profileUrl: NSString?
    var tweetID:NSString?
    
    init(dictionary: NSDictionary) {
        user = dictionary["user"] as? NSDictionary
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        tweetID = dictionary["id_str"] as? String as NSString?
        print(dictionary)
        print("assigned tweet ID: \(tweetID)")
        let userdictionary = dictionary["user"] as? NSDictionary
        
        if let _userdictionary = userdictionary {
            screenName = _userdictionary["screen_name"] as? String as NSString?
            userName = _userdictionary["name"] as? String as NSString?
            profileUrl = _userdictionary["profile_image_url_https"] as? NSString
        }
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            timestamp = formatter.date(from: timestampString) as NSDate?
            
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
        
    }
    
}
