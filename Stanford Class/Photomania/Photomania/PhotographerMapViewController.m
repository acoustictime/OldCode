//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import <CoreData/CoreData.h>
#import "Photographer+MKAnnotation.h"

@interface PhotographerMapViewController ()

@end

@implementation PhotographerMapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    if (self.view.window)
        [self reload];
}

- (void)reload
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"]; // tell you count of this set
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:NULL];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photographers];
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhotographer:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            
            MKAnnotationView *aView = sender;
            
            if ([aView.annotation isKindOfClass:[Photographer class]]) {
                Photographer *photographer = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]) {
                    [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
                }
                
            }
        }
    }
    
    
}

@end
