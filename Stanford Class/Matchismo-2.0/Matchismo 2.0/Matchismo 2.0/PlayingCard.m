//
//  PlayingCard.m
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards
{
    
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if(otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        
        PlayingCard *otherCard1 = [otherCards objectAtIndex:0];
        PlayingCard *otherCard2 = [otherCards objectAtIndex:1];
        
        if ([self.suit isEqualToString:otherCard1.suit] && [self.suit isEqualToString:otherCard2.suit] && [otherCard2.suit isEqualToString:otherCard1.suit]) {
            score = 8;
        } else if(otherCard1.rank == self.rank && otherCard2.rank == self.rank && otherCard1.rank == otherCard2.rank) {
            score = 16;
        }    
    }
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *) validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *) rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger) maxRank
{
    return [PlayingCard rankStrings].count - 1;
}

- (void)setRank: (NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
