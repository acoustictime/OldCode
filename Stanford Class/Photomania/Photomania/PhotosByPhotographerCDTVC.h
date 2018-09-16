//
//  PhotosByPhotographerCDTVC.h
//  Photomania
//
//  Created by James Small on 9/11/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Photographer *photographer;

@end
