//
//  SetGameViewController.m
//  Matchismo
//
//  Created by James Small on 8/3/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardMatchingGame.h"
#import "SetDeck.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()
@property (strong, nonatomic) SetCardMatchingGame * game;
@property (weak, nonatomic) IBOutlet SetCardView *selectedCardOne;
@property (weak, nonatomic) IBOutlet SetCardView *selectedCardTwo;
@property (weak, nonatomic) IBOutlet SetCardView *selectedCardThree;

@end

#define STARTING_CARD_COUNT 12
#define NUMBER_OF_CARDS_TO_REMOVE 3


@implementation SetGameViewController

@synthesize startingCardCount = _startingCardCount;

- (SetCardMatchingGame *)game
{
    if (!_game)
        _game = [[SetCardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

- (NSString *)gameType
{
    return @"SetGame";
}

- (NSUInteger) startingCardCount
{
    if(!_startingCardCount)
        _startingCardCount = STARTING_CARD_COUNT;
    
    return _startingCardCount;
}

-(Deck *) createDeck
{
    return [[SetDeck alloc] init];
    
}

- (void)clearSelectedCardAtIndex:(NSInteger)index
{
    if (index == 2)
    {
        self.selectedCardThree.number = nil;
        
    } else if (index == 1)
    {
        self.selectedCardTwo.number = nil;
        
    } else if (index == 0)
    {
        self.selectedCardOne.number = nil;
        
    } else {
        // problem
        
    }

}

- (void)clearAllSelectedCardViews
{
    self.selectedCardOne.number = nil;
    self.selectedCardTwo.number = nil;
    self.selectedCardThree.number = nil;
    
}

- (void)updateSelectedCardViewWithCard:(SetCard *)card andIndex:(NSInteger)index
{
    if (index == 0) {
        self.selectedCardOne.number = card.number;
        self.selectedCardOne.shading = card.shading;
        self.selectedCardOne.color = card.color;
        self.selectedCardOne.symbol = card.symbol;
    } else if (index == 1) {
        self.selectedCardTwo.number = card.number;
        self.selectedCardTwo.shading = card.shading;
        self.selectedCardTwo.color = card.color;
        self.selectedCardTwo.symbol = card.symbol;
    } else if (index == 2) {
        self.selectedCardThree.number = card.number;
        self.selectedCardThree.shading = card.shading;
        self.selectedCardThree.color = card.color;
        self.selectedCardThree.symbol = card.symbol;
    } else {
        //problem
    }


}



- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
       
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
            
            setCardView.alpha = !setCard.isUnplayable && setCard.isFaceUp ? 0.7 : 1.0;
            
            if (animate)
            {
                setCardView.faceUp = setCard.isFaceUp;
            } else {
                setCardView.faceUp = setCard.isFaceUp;
            }
            
        }
    }  

}

- (NSString *)cellIdentifierString
{
    return @"SetCard";
}


@end
