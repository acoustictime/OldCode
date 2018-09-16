//
//  TweetSearchResults.swift
//  SmashTag
//
//  Created by James Small on 3/23/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import Foundation

class TweetSearchResults
{
    
    public var tweetSearchResultsArray: [[String: String]] {
        get {
            return UserDefaults.standard.value(forKey: "tweetSearchResults") as? [[String: String]] ?? [[String: String]]()
        }
    }
    
    public func updateRecentTweetSearchesArray(_ newTweetArray: [[String: String]]) {
        
        UserDefaults.standard.set(newTweetArray, forKey: "tweetSearchResults")
    }
    
    public func clearRecentTweetSearches() {
        UserDefaults.standard.set([[String: String]](), forKey: "tweetSearchResults")
    }
    
    public func addTweetSearch(_ searchTerm: String?) {

        if let searchTermToAdd = searchTerm {
            
            var tweetsSearchArray = tweetSearchResultsArray
            
            for (index, searches) in tweetsSearchArray.enumerated() {
                if searches[searchTermToAdd] != nil {
                    tweetsSearchArray.remove(at: index)
                    break
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
            
            let searchDateTime = dateFormatter.string(from: Date())
            
            tweetsSearchArray.insert([searchTermToAdd: searchDateTime], at: 0)
            
            if tweetsSearchArray.count > 100 {
                tweetsSearchArray.removeLast()
            }
            
            UserDefaults.standard.set(tweetsSearchArray, forKey: "tweetSearchResults")

        }
    }

}
