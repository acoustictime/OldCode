//
//  RecentFlickrPhotoTVC.m
//  SPoT
//
//  Created by James Small on 8/31/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "RecentFlickrPhotoTVC.h"

@interface RecentFlickrPhotoTVC ()

@end

@implementation RecentFlickrPhotoTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.photos = [self loadRecentPicFromNSDefaults];
    [self.tableView reloadData];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];   
    
}

- (IBAction)clearRecentPics:(id)sender
{
    [FlickrPhotoTVC clearNSDefaultPics];
    self.photos = nil;
    [self.tableView reloadData];
}

@end
