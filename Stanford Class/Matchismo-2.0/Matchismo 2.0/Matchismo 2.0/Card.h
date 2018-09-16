//
//  Card.h
//  Matchismo
//
//  Created by James Small on 7/28/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;
@property (nonatomic, getter=inPlay) BOOL inPlay;
@property (nonatomic) BOOL dontFlipCard;


- (int) match: (NSArray *) othercards;

@end
