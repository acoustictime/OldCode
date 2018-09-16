//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck

- (id) init
{
    self = [super init];
    
    if (self) {
        
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                card.needsToFlip = NO;
                [self addCard:card atTop:YES];
            }
        }      
    }
    return self;
}

@end
