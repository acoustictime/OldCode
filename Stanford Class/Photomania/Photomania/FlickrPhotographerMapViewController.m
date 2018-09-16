//
//  FlickrPhotographerMapViewController.m
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "FlickrPhotographerMapViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"


@interface FlickrPhotographerMapViewController ()

@end

@implementation FlickrPhotographerMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.managedObjectContext)
        [self useDemoDocument];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)refresh
{

    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        
        NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
        // put the photos in CORE Data
        [self.managedObjectContext performBlock:^{
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectConext:self.managedObjectContext];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
               
            });
        }];
        
    });
}

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        //create it
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                if (!self.managedObjectContext)
                    NSLog(@"it's not set here");
                [self refresh];
            }
        }];
        
    } else if (document.documentState == UIDocumentStateClosed) {
        // open it
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                
            }
        }];
        
    } else {
        // try to use it
        self.managedObjectContext = document.managedObjectContext;
    }
}


@end
