//
//  FlickrPhotoTVC.h
//  ShutterBug
//
//  Created by James Small on 8/26/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController

@property (strong, nonatomic) NSArray *photos; // of NSDictionary

- (NSArray *) photosArrayToPassToSegue :(NSIndexPath *)index; //abstract
- (void)addPhotoToNSDefaults:(NSDictionary *)photo; // abstract
- (NSArray *)loadRecentPicFromNSDefaults;
+ (void) clearNSDefaultPics;

@end
