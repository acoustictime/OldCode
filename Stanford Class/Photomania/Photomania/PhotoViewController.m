//
//  PhotoViewController.m
//  Photomania
//
//  Created by James Small on 9/14/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotoViewController ()

@property (strong, nonatomic)MapViewController *mapvc;

@end

@implementation PhotoViewController

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = self.photo.title;
    self.imageURL = [NSURL URLWithString:self.photo.imageURL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EmbedMapOfPhoto"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            self.mapvc = segue.destinationViewController;
        }
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapvc.mapView addAnnotation:self.photo];
}

@end
