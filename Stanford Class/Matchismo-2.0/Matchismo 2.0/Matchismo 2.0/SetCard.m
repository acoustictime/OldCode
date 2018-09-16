//
//  SetCard.m
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "SetCard.h"

#define MATCH_SCORE 4
#define MODULUS_COUNT 3

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2)
    {
        SetCard *one = self;
        
        int numbers = [[SetCard validNumbers] indexOfObject:[one number]];
        int symbols = [[SetCard validSymbols] indexOfObject:[one symbol]];
        int shadings = [[SetCard validShadings] indexOfObject:[one shading]];
        int colors = [[SetCard validColors] indexOfObject:[one color]];
        
        for (SetCard *card in otherCards)
        {
            numbers += [[SetCard validNumbers] indexOfObject:[card number]];
            symbols += [[SetCard validSymbols] indexOfObject:[card symbol]];
            shadings += [[SetCard validShadings] indexOfObject:[card shading]];
            colors += [[SetCard validColors] indexOfObject:[card color]];
        }
        
        if (!(numbers % MODULUS_COUNT + symbols % MODULUS_COUNT + shadings % MODULUS_COUNT + colors % MODULUS_COUNT)) 
            score = MATCH_SCORE;
            
    }

    return score;
}

- (NSString *)contents
{
    NSString *returnString = [[NSString alloc] init];

    for (int i = 0;i < [self.number integerValue];i++)
    {
        returnString = [returnString stringByAppendingString:self.symbol];
    }
    
    return returnString;
}

+ (NSArray *) validNumbers
{
    return @[@1,@2,@3];
}

+ (NSArray *) validSymbols
{
    return @[@"1",@"2",@"3"];
      
}

+ (NSArray *) validShadings
{
    return @[@"1",@"2",@"3"];
}

+ (NSArray *) validColors
{
    return @[@"1",@"2",@"3"];
}

+ (NSUInteger)maxRank
{
    return [[SetCard validNumbers] count];
}


@end
