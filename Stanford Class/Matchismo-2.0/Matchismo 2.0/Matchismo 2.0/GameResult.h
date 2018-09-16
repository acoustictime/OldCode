//
//  GameResult.h
//  Matchismo
//
//  Created by James Small on 7/31/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *) allGameResults;
+ (void) eraseGameResults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;
@property (nonatomic) NSString *type;

- (NSComparisonResult)dateCompare:(GameResult *)aGameResult;
- (NSComparisonResult)scoreCompare:(GameResult *)aGameResult;
- (NSComparisonResult)durationCompare:(GameResult *)aGameResult;

@end
