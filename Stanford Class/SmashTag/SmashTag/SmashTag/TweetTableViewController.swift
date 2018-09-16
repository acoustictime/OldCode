//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by James Small on 3/19/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    private var tweets = [Array<Twitter.Tweet>]()
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            loadTableView()
        }
    }
    
    func insertTweets(_ newTweets: [Twitter.Tweet], with searchTerm: String) {
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    
    private func loadTableView() {
        tweets.removeAll()
        tableView.reloadData()
        searchForTweets()
        self.navigationItem.title = searchText
        let tweetSearchResultSaver = TweetSearchResults()
        tweetSearchResultSaver.addTweetSearch(searchText)
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets, with: (self?.searchText)!)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
        
    }
    
   
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

//        let refreshControl = UIRefreshControl()
//        let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
//        refreshControl.attributedTitle = NSAttributedString(string: title)
//        refreshControl.addTarget(self,
//                                 action: #selector(refreshTable(sender:)),
//                                 for: .valueChanged)
//        tableView.refreshControl = refreshControl
     
    }
    
//    @objc private func refreshTable(sender: UIRefreshControl) {
//        
//        self.loadTableView()
//        
//        sender.endRefreshing()
//    }

    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            if searchTextField.text != "" {                
                searchText = searchTextField.text
            }
            searchTextField.resignFirstResponder()
            
        }
        return true
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        // Configure the cell...
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
            
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // make it a little clearer when each pull from Twitter
        // occurs in the table by setting section header titles
        return "\(tweets.count-section)"
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination
        
        if let tweetDetailTableViewController = destinationViewController as? TweetDetailTableViewController,
            let identifier = segue.identifier {
            if identifier == "tweetDetail" {
                if (sender as? UITableViewCell) != nil {
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        let tweet = tweets[indexPath.section][indexPath.row]
                        tweetDetailTableViewController.navigationItem.title = tweet.user.name
                        tweetDetailTableViewController.tweet = tweet                       
                    }
                
                }
                
                
            }
        }
        
        if let imageCollectionViewController = destinationViewController as? ImageCollectionViewController,
            let identifier = segue.identifier {
            if identifier == "collectionSegue" {
                imageCollectionViewController.navigationItem.title = "Images for: \(self.navigationItem.title!)"
                // loop through all tweets and add their image URLs to list
                for tweetArray in tweets {
                    for currentTweet in tweetArray {
                        for mediaItem in currentTweet.media {
                            imageCollectionViewController.imageURLS.append(mediaItem.url)
                        }
                    }
                    
                }
                
                
                
                
               
                
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "collectionSegue" {
            if tweets.count == 0 {
                return false
            }
        }
        
        return true
    }
   
}

