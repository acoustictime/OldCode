//
//  PhotosByPhotographerCDTVC.m
//  Photomania
//
//  Created by James Small on 9/11/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PhotosByPhotographerCDTVC.h"
#import "Photo.h"

@implementation PhotosByPhotographerCDTVC

- (void)setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    if (self.photographer.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@",self.photographer];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.photographer.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            
            if ([segue.identifier isEqualToString:@"showImage"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    
                    
                    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
                    NSURL *url = [[NSURL alloc] initWithString:photo.imageURL];
                    
                    
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    
        
                    
                    if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                        [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    }

                    
                }
                
            }
        }
    }
}


@end
