//
//  SetCardView.h
//  SuperCard
//
//  Created by James Small on 8/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSNumber *number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) BOOL faceUp;

@end

