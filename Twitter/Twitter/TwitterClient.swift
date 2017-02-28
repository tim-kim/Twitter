//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tim Kim on 2/27/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//


import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "1gRRuJzINoOIYPdiFYbcnjm2D", consumerSecret: "mrZ5eT1UhwkgJc9Mp4rHiQfLbW79yld7k217CNZP2QM0tQrBoU")
    //static is the same as class, but you can't create a class stored property yet
    //static just means it can't be overriden (difference with class)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    //asynchronous. Success: I will get an array of Tweets and then do nothing. () = nothing.
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries) //class function
            //print(tweets)
            
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    //declaring closure error
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        //logout and clear stuff
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET",
                                                        callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                                            let url = URL(string: "https://api.twitter.com/oauth/authorize?=oauth_token=\((requestToken?.token)!)")!//? is a query parameter
                                                            print("request: \((requestToken?.token)!)")
                                                            //UIApplication.shared.open(url, options: [:], completionHandler: nil) // <- learn how to deal with completion handler
                                                            UIApplication.shared.open(url)
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessTOken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user) in
                User.currentUser = user //trigger a cal to setter and then save it
                self.loginSuccess?()
                }, failure: { (error) in
                    print("error: \(error.localizedDescription)")
                    self.loginFailure?(error)
            })
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func retweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: Int) {
        post("1.1/statuses/retweet/\(tweetID).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("retweet")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetID: Int) {
        post("1.1/favorites/create.json", parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("favorite")
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
}
