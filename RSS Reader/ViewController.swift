//
//  ViewController.swift
//  RSS Reader
//
//  Created by Vitaly Shpinyov on 16/05/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

import UIKit

// Array of web links to rss feeds for fetching content
let feedLinks = ["https://dni.ru/rss.xml", "https://www.vz.ru/rss.xml"]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedModelDelegate {
    
    // MARK: - Properties
    
    // Table view listing article headers
    @IBOutlet weak var tableView: UITableView!

    // Property to hold a selected link
    var activeLink:String?
 
    // Array of fetched articles
    var articles = [Article]()
    
    // A dictionary of feed models with feed Url as the key. Used for processing arrays of articles from particular feeds
    var feedDictionary = [String:FeedModel]()
    
    private let refreshControl = UIRefreshControl()

    // MARK: - Inherited class methods
    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Connect table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set up refresh control
        configureRefreshControl()
        
        // Retrieve articles from rss feed(s)
        loadData()
    }

    
    // MARK: - Data initalization
    func loadData() {

        // Call each link in array to fetch rss content
        for link in feedLinks {
            feedDictionary[link] = FeedModel(feedURLString: link)
            feedDictionary[link]?.delegate = self
            feedDictionary[link]?.getArticles()
        }
    }

    
    // Refresh data upon user's request
    func refreshData (_ sender:Any)
    {
        // Updating data here
        self.articles.removeAll()
        loadData()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    // Set up refresh control
    func configureRefreshControl() {
    
        // Add Refresh Control to table view
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление данных ...", attributes: nil)
        refreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)

    }
    
    
    // MARK: - Table view methods
    
    // Go to detail view of selected article
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        activeLink = articles[indexPath.row].link
        performSegue(withIdentifier: "segueShowDetail", sender: self)
        
    }
    
    
    // Set up a cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell")!
        let label = cell.viewWithTag(2) as! UILabel
        label.text = articles[indexPath.row].timestampShort + ": " + articles[indexPath.row].title
        return cell
    }

    
    // Return number of items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    // MARK: - Detail view loader
    // Load selected link to detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let actualLink = activeLink {
            // If link is selected load is as a property to destination view controller
            let detailVC = segue.destination as! DetailViewController
            detailVC.linkToLoad = actualLink
        }
    }
    
    
    // MARK: - Methods to process fetched articles
    
    // Callback function of FeedModelDelegate protocol
    func articlesReady(feedUrlString:String) {
        
        // Receive articles from URL = feedUrlString
        if let feed = feedDictionary[feedUrlString] {

            // Add the articles to articles already fetched from other sources
            self.articles += feed.articles
            
            // Sort the entire collection of articles in reverse chronological order
            self.articles = self.articles.sorted(by: { (a1: Article, a2: Article) -> Bool in
  
                return a1.timestampAsDate!.compare(a2.timestampAsDate!) == .orderedDescending
            })
            // Refresh table view
            tableView.reloadData()
        }
    }
        
}
