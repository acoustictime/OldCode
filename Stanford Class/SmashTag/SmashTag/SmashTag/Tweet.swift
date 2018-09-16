//
//  Tweet.swift
//  SmashTag
//
//  Created by James Small on 4/11/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject
{
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, with searchTerm: SearchTerm?, in context: NSManagedObjectContext) throws -> Tweet {

        // loop through all mentions and add if needed, increase count
        
        // Hashtags section
        for hashTagsItem in twitterInfo.hashtags {
            // create request & predicate
            let request: NSFetchRequest<SearchMention> = SearchMention.fetchRequest()
            request.predicate = NSPredicate(format: "mentionText = [c] %@",hashTagsItem.keyword)

            do {
                let matches = try context.fetch(request)
                if matches.count > 0 {
                    // found - increase count
                   matches[0].count += 1
                
                } else {
                    // not found - create new
                    let _ = try? SearchMention.findOrCreateSearchMention(matching: hashTagsItem.keyword, in: context, with: searchTerm!)
                }
            } catch {
                throw error
            }
        }
        
        // Users section
        for users in twitterInfo.userMentions {
            // create request & predicate
            
            let request: NSFetchRequest<SearchMention> = SearchMention.fetchRequest()
            request.predicate = NSPredicate(format: "mentionText = [c] %@",users.keyword)
            
            do {
                let matches = try context.fetch(request)
                if matches.count > 0 {
                    // found - increase count
                    matches[0].count += 1
                    
                } else {
                    // not found - create new
                    let _ = try? SearchMention.findOrCreateSearchMention(matching: users.keyword, in: context, with: searchTerm!)
                }
            } catch {
                throw error
            }
            
        }
        
        
        
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)

        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findorcreateTweet - database problem")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.tweeter = try? TwitterUser.findOrCreateTweeterUser(matching: twitterInfo.user, in: context)
        
        return tweet
        
    }
    
    

}
