//
//  SetCardMatchingGame.m
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "SetCardMatchingGame.h"

@interface SetCardMatchingGame ()

@property (readwrite,nonatomic) int score;
@property (readwrite, strong ,nonatomic) Deck *deck;

@end

@implementation SetCardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 3
#define FLIP_COST 2



- (NSNumber *)cardsInPlay
{
    return nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    [self.results removeAllObjects];
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            self.score -= FLIP_COST;
            [self.results addObject:@([self.cards indexOfObject:card])];
            int faceUpCount = 0;
            NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    faceUpCount++;
                    [faceUpCards addObject:otherCard];
                }
            }
            
            if (faceUpCount == 2) {
                int matchScore = [card match:faceUpCards];
                
                [self.results addObject:@([self.cards indexOfObject:faceUpCards[0]])];
                [self.results addObject:@([self.cards indexOfObject:faceUpCards[1]])];
                
                if (matchScore) {
                    card.unplayable = YES;
                    for (Card *otherCard in faceUpCards) {
                        otherCard.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    [self.results addObject:@(matchScore * MATCH_BONUS)];
                    [self.results addObject:@1];
                    
                    // remove three winning cards from Cards array of active cards
                    
                    [self.cards removeObject:card];
                    [self.cards removeObject:faceUpCards[0]];
                    [self.cards removeObject:faceUpCards[1]];
                    
                } else {
                    card.faceUp = !card.isFaceUp;
                    for (Card *otherCard in faceUpCards) {
                        otherCard.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                    
                    [self.results addObject:@(MISMATCH_PENALTY)];
                    [self.results addObject:@0];
                
                }
            }
     
        }
        card.faceUp = !card.isFaceUp;
        
        
    }

}

@end
