//
//  CardGameViewController.h
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; //abstract

-(Deck *) createDeck; //abstract
- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; //abstract
- (NSString *)cellIdentifierString; //abstract
- (NSString *)gameType; //abstract
- (void)updateSelectedCardViewWithCard:(Card *)card andIndex:(NSInteger)index; // abstract
- (void)clearAllSelectedCardViews; // abstract
- (void)clearSelectedCardAtIndex:(NSInteger)index; // abstract
- (void)cardNeedsToFlip:(Card *)card; //abstract



@end
