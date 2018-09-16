//
//  PlayingCard.h
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL needsToFlip;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;

@end
