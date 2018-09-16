//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by James Small on 7/29/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly,nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *cards; // Of Card
@property (readonly, strong ,nonatomic) Deck *deck;


- (NSInteger)addCardToGame;

// Designated Initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (BOOL)deckEmpty;

@end
