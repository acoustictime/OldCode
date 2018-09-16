//
//  SetCard.h
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSNumber *number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;
+ (NSUInteger)maxRank;

@end
