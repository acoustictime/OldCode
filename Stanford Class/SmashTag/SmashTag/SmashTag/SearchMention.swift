//
//  SearchMention.swift
//  SmashTag
//
//  Created by James Small on 4/20/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import CoreData


class SearchMention: NSManagedObject {
    
    class func findOrCreateSearchMention(matching keyword: String, in context: NSManagedObjectContext, with searchTerm: SearchTerm) throws -> SearchMention {
        
        let request: NSFetchRequest<SearchMention> = SearchMention.fetchRequest()
        request.predicate = NSPredicate(format: "mentionText = %@", keyword)

        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count <= 1, "SearchTerm.findOrCreateSearchMention - database problem")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = SearchMention(context: context)
        mention.mentionText = keyword
        mention.count = 1
        mention.searchTerm = searchTerm
 
        return mention
        
    }

}
