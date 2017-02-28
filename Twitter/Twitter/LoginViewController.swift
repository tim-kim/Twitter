//
//  LoginViewController.swift
//  Twitter
//
//  Created by Tim Kim on 2/26/17.
//  Copyright © 2017 Tim Kim. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.image = #imageLiteral(resourceName: "TwitterLogo")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }, failure: { (error) in
                print("error: error.localizedDescription")
        })
    }
    
    
    
    
    
    
    
    
    
    

}

