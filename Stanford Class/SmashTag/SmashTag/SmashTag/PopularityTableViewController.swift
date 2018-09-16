//
//  PopularityTableViewController.swift
//  SmashTag
//
//  Created by James Small on 4/25/17.
//  Copyright © 2017 SmallJames. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: FetchedResultsTableViewController
{
    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<SearchMention>?
    
    var container:  NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController?.delegate = self
    }
    
    private func updateUI() {
        
        if let context = container?.viewContext, mention != nil {
            
            let request: NSFetchRequest<SearchMention> = SearchMention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false), NSSortDescriptor(key: "mentionText", ascending: true)]
            request.predicate = NSPredicate(format: "any searchTerm.searchText contains[c] %@", mention!)
            
            fetchedResultsController = NSFetchedResultsController<SearchMention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularityCell", for: indexPath)
        
        if let searchMention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = searchMention.mentionText
            cell.detailTextLabel?.text = String(searchMention.count)

        }
        
        
        
        return cell
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination
        
        if let tweetTableViewController = destinationViewController as? TweetTableViewController,
            let identifier = segue.identifier {
            if identifier == "popularityToTwitterSearch" {
                if let searchTerm = sender as? UITableViewCell {
                    if let actualSearch = searchTerm.textLabel?.text  {
                        tweetTableViewController.searchText = actualSearch
                        
                    }
                }
            }
        }
    }
   
}
