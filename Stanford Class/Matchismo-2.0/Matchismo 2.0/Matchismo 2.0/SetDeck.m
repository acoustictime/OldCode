//
//  SetDeck.m
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "SetDeck.h"

@implementation SetDeck

- (id) init
{
    self = [super init];
    
    if (self) {
        
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *shade in [SetCard validShadings]) {
                    for (NSNumber *number in [SetCard validNumbers]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shade;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }          
            }
        }
    }
    return self;
}

@end


