//
//  Deck.h
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

- (BOOL)deckEmpty;

@end
