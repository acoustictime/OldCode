//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by James Small on 7/29/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite,nonatomic) int score;
@property (readwrite, strong ,nonatomic) Deck *deck;

@end


@implementation CardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (BOOL)deckEmpty
{
    return [self.deck deckEmpty];
}

- (NSInteger)addCardToGame;
{
    NSInteger indexValue = -1;
    Card * card = [self.deck drawRandomCard];
        
    if (card) {
        [self.cards addObject:card];
        indexValue = [self.cards indexOfObject:card];
    }
    else {
 
    }
    return indexValue;
}

- (NSArray *)results
{
    if (!_results)
        _results = [[NSMutableArray alloc] init];
    return _results;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    [self.results removeAllObjects];
    Card *card = [self cardAtIndex:index];
    
       if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
             [self.results addObject:[card contents]];
            for (Card * otherCard in self.cards) {
               
             
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    [self.results addObject:[otherCard contents]];
                    if (matchScore) {
                        card.unplayable = YES;
                        otherCard.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                       
                        [self.results addObject:@(1)];
                        [self.results addObject:@(matchScore * MATCH_BONUS)];
                        
                        
                    } else {
                        otherCard.faceUp = NO;
                        card.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        [self.results addObject:@(0)];
                        [self.results addObject:@(MISMATCH_PENALTY)];
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
        }    
        card.faceUp = !card.isFaceUp;
    }
}

- (NSMutableArray *)cards
{
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;

}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for(int i = 0;i < count;i++)
        {
            Card * card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    self.deck = deck;

    }
    return self;
}




@end
