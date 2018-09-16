//
//  Photo+MKAnnotation.h
//  Photomania
//
//  Created by James Small on 9/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnail; //currently blocks main thread

@end
