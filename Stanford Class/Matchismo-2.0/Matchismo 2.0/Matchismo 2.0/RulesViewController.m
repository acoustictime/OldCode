//
//  RulesViewController.m
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "RulesViewController.h"
#import "GameResult.h"

@interface RulesViewController ()

@end

@implementation RulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)resetAllScores {
    [GameResult eraseGameResults];
}

@end
