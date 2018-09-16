//
//  GameResult.m
//  Matchismo
//
//  Created by James Small on 7/31/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "GameResult.h"

@interface GameResult ()

@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;


@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResult_ALL"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"
#define TYPE_KEY @"Type"

+ (NSArray *) allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    return allGameResults;      
}

+ (void) eraseGameResults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    
    if(self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            _type = resultDictionary[TYPE_KEY];
            if (!_start || !_end)
                self = nil;
        }
    }
    return self;
}

- (void) synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if (!mutableGameResultsFromUserDefaults)
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
  
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id)asPropertyList
{
    return @{ START_KEY: self.start, END_KEY :self.end, SCORE_KEY : @(self.score), TYPE_KEY : self.type};
}

- (id) init
{
    self = [super init];
    if (self) {
        _start =  [NSDate date];
        _end = _start;
    }
    return self;       
}

-(NSTimeInterval) duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

-(NSString *)type
{
    if(!_type)
        _type = [[NSString alloc] init];
    return _type;
}

- (NSComparisonResult)dateCompare:(GameResult *)aGameResult {

    return ([self.end compare:aGameResult.end]);
}

- (NSComparisonResult)scoreCompare:(GameResult *)aGameResult {
   
    return ([@(self.score) compare:@(aGameResult.score)]);
}

- (NSComparisonResult)durationCompare:(GameResult *)aGameResult {
    
    return ([@(self.duration) compare:@(aGameResult.duration)]);
}

@end
