//
//  Card.m
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int) match:(NSArray *)othercards
{
    int score = 0;
    for (Card *card in othercards)
    {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

- (NSString *)description
{
    return self.contents;
}


@end
