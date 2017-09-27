//
//  DetailViewController.swift
//  RSS Reader
//
//  Created by Vitaly Shpinyov on 18/05/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var webView: UIWebView!
    var linkToLoad:String?
    

    // MARK: - Inherited class methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load link selected in the main view controller
        loadLink()
    }

    
    // MARK: - Navigation methods
    func loadLink() {
    
        // Check if link was initialized before the web view is loaded
        if let activeLink = linkToLoad {
        
            // Create a URL object instance
            if let myURL = URL(string: activeLink) {
                // Create a request instance
                let url = URLRequest(url: myURL)
                // Load the request url
                webView.loadRequest(url)
            }
    
        }
    
    }

}
