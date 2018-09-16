//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by James Small on 7/31/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResult.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *cardGameResults;
@property (weak, nonatomic) IBOutlet UITextView *setGameResults;
@property (nonatomic) SEL sortSelector;


@end

@implementation GameResultsViewController

@synthesize sortSelector = _sortSelector;

- (void)updateUI
{
    NSString *cardGameDisplayText = @"";
    NSString *setGameDisplayText = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; // added after lecture
    [formatter setDateStyle:NSDateFormatterShortStyle];          // added after lecture
    [formatter setTimeStyle:NSDateFormatterShortStyle];          // added after lecture

    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:self.sortSelector];
    NSArray* sortedArray = [[GameResult allGameResults] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for (GameResult *result in sortedArray) {
        
        if ([result.type isEqualToString:@"CardGame"]) {
                cardGameDisplayText = [cardGameDisplayText stringByAppendingFormat:@"Score: %d (%@, %0gs)\n", result.score, [formatter stringFromDate:result.end], round(result.duration)];
        } else
        {
                setGameDisplayText = [setGameDisplayText stringByAppendingFormat:@"Score: %d (%@, %0gs)\n", result.score, [formatter stringFromDate:result.end], round(result.duration)];
        }
        
        
    }
    self.cardGameResults.text = cardGameDisplayText;
    self.setGameResults.text = setGameDisplayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)byDateSortSelector {
    
    self.sortSelector = @selector(dateCompare:);
    [self updateUI];
}

- (IBAction)byScoreSortSelector {
    
    self.sortSelector = @selector(scoreCompare:);
    [self updateUI];
    
}

- (IBAction)byDurationSortSelector {
    
    self.sortSelector = @selector(durationCompare:);
    [self updateUI];
}

- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(durationCompare:);
    return _sortSelector;
}

// update the UI when changing the sort selector

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}


@end
