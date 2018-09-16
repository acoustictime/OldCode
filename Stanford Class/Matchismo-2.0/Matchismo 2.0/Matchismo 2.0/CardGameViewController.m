//
//  CardGameViewController.m
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"


@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame * game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) NSMutableArray *selectedCards;
@property (weak, nonatomic) IBOutlet UITextView *gameStatusText;

@end

#define CARD_COUNT_TO_ADD 3

@implementation CardGameViewController

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierString] forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    
    [self updateCell:cell usingCard:card animate:NO];
    
    return cell;
}

- (NSString *)cellIdentifierString
{
    return nil; // abstract
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    //abstract
}

- (GameResult *)gameResult
{
    if (!_gameResult) 
        _gameResult = [[GameResult alloc] init];
    
    _gameResult.type = [self gameType];
    return _gameResult;
}

- (NSString *)gameType
{
    return nil; //abstract
}

- (CardMatchingGame *)game
{
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

-(Deck *) createDeck
{
    return nil; //abstract
}
                 
- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];

}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (void)clearSelectedCardAtIndex:(NSInteger)index
{
    //abstract
}

- (NSMutableArray *)selectedCards
{
    if (!_selectedCards)
        _selectedCards = [[NSMutableArray alloc] init];
    return _selectedCards;
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {

    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        
        Card *card = [self.game cardAtIndex:indexPath.item];
  
        if (card.isFaceUp)
        {
            [self.selectedCards removeObject:card];
          
        } else {
           
            [self.selectedCards addObject:card];
            
        }
        
        
        [self clearAllSelectedCardViews];
        
        for (Card * card in self.selectedCards) {
            
            [self updateSelectedCardViewWithCard:card andIndex:[self.selectedCards indexOfObject:card]];
            
        }
        
        if ([self.selectedCards count] == 3) {
            [self.selectedCards removeAllObjects];
        }
        
        int index = indexPath.item;
        [self.game flipCardAtIndex:index];
        self.flipCount++;
        
        self.gameResult.score = self.game.score;
        
     
        if ([[self gameType] isEqualToString:@"SetGame"] && [self.game.results count] > 1)
        {
            if ([self.game.results[4] integerValue])
            {
                NSMutableArray *indexesToDelete = [[NSMutableArray alloc] init];
                
                NSIndexPath *indexPath;
                
                for (int i = 0;i < CARD_COUNT_TO_ADD;i++)
                {
                    self.startingCardCount--;
                    
                    indexPath = [NSIndexPath indexPathForItem:[self.game.results[i] integerValue] inSection:0];
                    [indexesToDelete addObject:indexPath];

                }
                
                [self.cardCollectionView deleteItemsAtIndexPaths:indexesToDelete];
                [self.selectedCards removeAllObjects];
                
                self.gameStatusText.text = [NSString stringWithFormat:@"You matched the cards on the left for %ld points",(long)[self.game.results[3] integerValue]];
                
            }
            else {
                self.gameStatusText.text = [NSString stringWithFormat:@"Cards don't match. Lose %ld points",(long)[self.game.results[3] integerValue]];
            }
        }
        
        if ([[self gameType] isEqualToString:@"CardGame"]) {
            
            [self cardNeedsToFlip:card];
            
        }
        
        if (card.isUnplayable)
            card.dontFlipCard = YES;
        
        
        [self updateUI];
        
        
        
        
        if ([[self gameType] isEqualToString:@"CardGame"] && [self.game.results count] > 1) {
            
            if ([self.game.results[2] integerValue])
            {
                               
                self.gameStatusLabel.text = [NSString stringWithFormat:@"You matched %@ & %@ for %ld points",self.game.results[0],self.game.results[1],(long)[self.game.results[3] integerValue]];
                
            }
            else {
                self.gameStatusLabel.text = [NSString stringWithFormat:@"Cards %@ & %@ don't match. Lose %ld points",self.game.results[0],self.game.results[1],(long)[self.game.results[3] integerValue]];
            }
   
        } else {
            
            if (card.isFaceUp && !card.unplayable) {
            self.gameStatusLabel.text = [NSString stringWithFormat:@"You flipped over %@",self.game.results[0]];
            } else {
                self.gameStatusLabel.text = @"";
            }
            
        }
        
    }   
}

- (void)cardNeedsToFlip:(Card *)card
{
    //abstract
}

- (void)updateSelectedCardViewWithCard:(Card *)card andIndex:(NSInteger)index
{
    // abstract
}

- (void)clearAllSelectedCardViews
{
    //abstract
}

- (IBAction)dealCards:(UIButton *)sender {

    self.game = nil;
    self.gameResult = nil;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",0];
    self.flipCount = 0;
    self.gameStatusLabel.text = [NSString stringWithFormat:@"Tap a card to begin matching!"];
    self.gameStatusText.text = [NSString stringWithFormat:@"Tap a card to begin matching!"];
    self.startingCardCount = 0;
    [self.cardCollectionView reloadData];
    [self clearAllSelectedCardViews];
    [self.selectedCards removeAllObjects];
    [self updateUI];
}

- (IBAction)dealMoreCards:(UIButton *)sender {
    
    if ([self.game deckEmpty]) {
        NSIndexPath *indexPath = nil;
        
        for (int i = 0;i < CARD_COUNT_TO_ADD;i++) {
            self.startingCardCount++;
            
            NSInteger count = [self.game addCardToGame];
   
            indexPath = [NSIndexPath indexPathForItem:count inSection:0];
        
            [self.cardCollectionView insertItemsAtIndexPaths:@[indexPath]];
        }
        
        if (indexPath)
            [self.cardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    } 
}



@end
