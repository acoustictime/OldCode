//
//  PlayingCardView.h
//  SuperCard
//
//  Created by James Small on 8/7/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

-(void)pinch:(UIPinchGestureRecognizer *) gesture;
@end
