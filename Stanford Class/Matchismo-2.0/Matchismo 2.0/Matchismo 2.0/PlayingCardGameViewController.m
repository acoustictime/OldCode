//
//  PlayingCardGameViewController.m
//  Matchismo 2.0
//
//  Created by James Small on 8/9/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

#define STARTING_CARD_COUNT 22

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (NSUInteger) startingCardCount
{
    return STARTING_CARD_COUNT;
}

-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)cardNeedsToFlip:(Card *)card
{
    PlayingCard *playingCard = (PlayingCard *)card;
    
    
        playingCard.needsToFlip = YES;
    
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL) animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]])
    {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *) cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
            
            if (animate && playingCard.needsToFlip && !playingCard.dontFlipCard)
            {
                
                [UIView transitionWithView:playingCardView
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                              playingCardView.faceUp = playingCard.isFaceUp;
                                    
                                }completion:NULL];
                
                
                
                playingCard.needsToFlip = NO;
            } else {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
    
        }
    }  
}

- (NSString *)cellIdentifierString
{
    return @"PlayingCard";
}

- (NSString *)gameType
{
    return @"CardGame";
}



@end
