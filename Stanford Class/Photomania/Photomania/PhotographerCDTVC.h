//
//  PhotographerCDTVC.h
//  Photomania
//
//  Created by James Small on 9/9/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface PhotographerCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
