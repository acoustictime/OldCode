//
//  SetCardMatchingGame.h
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "CardMatchingGame.h"

@interface SetCardMatchingGame : CardMatchingGame
- (void)flipCardAtIndex:(NSUInteger)index;
- (NSNumber *)cardsInPlay;


@end
