//
//  PhotographerMapViewController.h
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "MapViewController.h"

@interface PhotographerMapViewController : MapViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)reload;

@end
