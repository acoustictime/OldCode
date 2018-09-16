//
//  SmashTweetTableViewController.swift
//  SmashTag
//
//  Created by James Small on 4/11/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    override func insertTweets(_ newTweets: [Twitter.Tweet], with searchTerm: String) {
        super.insertTweets(newTweets, with: searchTerm)
        updateDatabase(with: newTweets, and: searchTerm)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet], and searchTerm: String) {
        container?.performBackgroundTask { [weak self] context in
            
            // insert search term
            
            let term = try? SearchTerm.findOrCreateSearchTerm(matching: searchTerm, in: context)
 
            for twitterInfo in tweets {
                // add tweet
                let _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, with: term, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
        
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count {
                    print("\(tweetCount) tweets")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter Users")
                }
                if let searchTerm = try? context.count(for: SearchTerm.fetchRequest()) {
                    print("\(searchTerm) Search Terms")
                }
                if let searchMention = try? context.count(for: SearchMention.fetchRequest()) {
                    print("\(searchMention) Search Mentions")
                }
            }
        }
    }
}
