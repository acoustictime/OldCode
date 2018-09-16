//
//  SearchTerm.swift
//  SmashTag
//
//  Created by James Small on 4/20/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import CoreData

class SearchTerm: NSManagedObject {

    
    class func findOrCreateSearchTerm(matching searchTerm: String, in context: NSManagedObjectContext) throws -> SearchTerm {
        
        let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
        request.predicate = NSPredicate(format: "searchText = %@", searchTerm)
        
        
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count <= 1, "SearchTerm.findOrCreateSearchTerm - database problem")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let term = SearchTerm(context: context)
        term.searchText = searchTerm
        
        return term
        
    }

}
