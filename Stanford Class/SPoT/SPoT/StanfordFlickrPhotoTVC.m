//
//  StanfordFlickrPhotoTVC.m
//  SPoT
//
//  Created by James Small on 8/30/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "StanfordFlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface StanfordFlickrPhotoTVC ()

@property (strong, nonatomic) NSMutableDictionary *photosDictionary;
@property (strong, nonatomic) NSMutableArray *tagsArray;


@end

@implementation StanfordFlickrPhotoTVC

- (NSMutableArray *)tagsArray
{
    if (!_tagsArray)
        _tagsArray = [[NSMutableArray alloc] init];
    return _tagsArray;
}

- (NSMutableDictionary *)photosDictionary
{
    if (!_photosDictionary)
        _photosDictionary = [[NSMutableDictionary alloc] init];
    return _photosDictionary;
}

- (void)updateTags
{
    // loop through all photos' tags.
        // if tag not in photosDictionary && not one of ignored tags
            //add it as key for NSArray
                //add current photo to that array
        // else
            //add current photo to that array

    NSArray *ignoredTags = [[NSArray alloc] initWithObjects:@"landscape",@"portrait",@"cs193pspot", nil];
    
    for (NSDictionary *photo in self.photos) {
        
        for (NSString * tag in [[photo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "]) {
            
            if (![ignoredTags containsObject:tag]) {
                
                if (![[self.photosDictionary allKeys] containsObject:tag]) {
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    [array addObject:photo];
                    
                    [self.photosDictionary setObject:array forKey:tag];
                    [self.tagsArray addObject:tag];
                    
                } else {
                    
                    [[self.photosDictionary objectForKey:tag] addObject:photo];
                }
                
                
            }
            
        }
        
    }
    [self.tagsArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];	
    [self loadLatestStanfordPhotosFromFlickr];
    [self.refreshControl addTarget:self action:@selector(loadLatestStanfordPhotosFromFlickr) forControlEvents:UIControlEventValueChanged];    
}

- (void)loadLatestStanfordPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQueue = dispatch_queue_create("flickr stanford loader", NULL);
    dispatch_async(loaderQueue, ^{
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
            self.photosDictionary = nil;
            self.tagsArray = nil;
            [self updateTags];
            [self.tableView reloadData];
        
        });
    });
}

- (NSArray *)photosArrayToPassToSegue:(NSIndexPath *)index
{
    return [self.photosDictionary objectForKey:[self tagForRow:index.row]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self.photosDictionary allKeys] count];
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
    
    return [[self tagForRow:row] capitalizedString];
}

- (NSString *) subtitleForRow:(NSUInteger)row
{
    NSInteger count = [[self.photosDictionary objectForKey:[self tagForRow:row]] count];
    
    return [NSString stringWithFormat:@"%d Photo%@",count,count > 1 ? @"s":@""];
}

- (NSString *)tagForRow:(NSUInteger)row
{
    return self.tagsArray[row];
}




@end
