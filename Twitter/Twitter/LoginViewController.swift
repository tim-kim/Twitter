//
//  LoginViewController.swift
//  Twitter
//
//  Created by Tim Kim on 2/26/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "GlAZ62XdikrWIsdT25bYfKjuH", consumerSecret: "JAhMmEJ4A4nQF9XXsRcrS34OmRCM3IP4BQb5J7SpwykvnCHT2P")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclone://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("request: \((requestToken?.token)!)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?=oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url)
            
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
        })
    }
    
    
    
    
    
    
    
    
    

}

