//
//  Photographer+MKAnnotation.m
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Photographer+MKAnnotation.h"
#import "Photo+MKAnnotation.h"

@implementation Photographer (MKAnnotation)

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%d Photo%@",[self.photos count], [self.photos count] > 1 ? @"s" : @""];
}

- (CLLocationCoordinate2D)coordinate
{
    return [[self.photos anyObject] coordinate];
}

- (UIImage *)thumbnail
{
    return [[self.photos anyObject] thumbnail];
}
@end
