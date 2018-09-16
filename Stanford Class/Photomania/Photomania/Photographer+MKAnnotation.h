//
//  Photographer+MKAnnotation.h
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Photographer.h"
#import <MapKit/MapKit.h>

@interface Photographer (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnail; //blocks

@end
