//
//  FlickrPhotoTVC.m
//  ShutterBug
//
//  Created by James Small on 8/26/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

#define MAX_RECENT_PHOTOS 8
#define RECENT_PHOTOS_KEY @"Recently_Accessed_Photos"
#define FLICKR_PHOTO_ID @"id"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sortPhotos];
}

#pragma mark - UISPlitViewController Delegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];    
}

- (void)sortPhotos
{
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    
    NSArray *sortedArray = [self.photos sortedArrayUsingDescriptors:sortDescriptors];
    self.photos = sortedArray;
    
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            
            if ([segue.identifier isEqualToString:@"ShowPlacesDetail"]) {
 
                [segue.destinationViewController setPhotos:[self photosArrayToPassToSegue:indexPath]];
                [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
   
                
            } else if ([segue.identifier isEqualToString:@"ShowImage"]) {
                
                NSURL *url = nil;
                
                if (IPAD) {
                    url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatOriginal];
                } else {
                    url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                }
       
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                [self addPhotoToNSDefaults:self.photos[indexPath.row]];                
            }
        }
    }
}

- (NSArray *)photosArrayToPassToSegue:(NSIndexPath *)index;
{
    return self.photos;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrPhotoPlaces";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

- (NSString *) titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *) subtitleForRow:(NSUInteger)row
{
    return self.photos[row][FLICKR_PHOTO_DESCRIPTION][@"_content"];
}

- (NSArray *)loadRecentPicFromNSDefaults
{
    NSArray *allRecentPhotos = [[NSUserDefaults standardUserDefaults] valueForKey:RECENT_PHOTOS_KEY];

    return allRecentPhotos;
}

- (void)addPhotoToNSDefaults:(NSDictionary *)photo
{
    NSMutableArray *photosArray = [[self loadRecentPicFromNSDefaults] mutableCopy];
    
    if (!photosArray)
        photosArray = [[NSMutableArray alloc] init];

    if ([photosArray containsObject:photo]) {
        [photosArray removeObject:photo];
    }
    
    
    if ([photosArray count] >= MAX_RECENT_PHOTOS)
        [photosArray removeObjectAtIndex:[photosArray count] -1];
    
    [photosArray insertObject:photo atIndex:0];
    
    [self savePhotosToNSDefaultsFromArray:photosArray];
}

- (void)savePhotosToNSDefaultsFromArray:(NSArray *)photoArray
{
    [[NSUserDefaults standardUserDefaults] setObject:[photoArray mutableCopy] forKey:RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) clearNSDefaultPics
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
