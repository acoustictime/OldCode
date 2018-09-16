//
//  Photo+Flickr.h
//  Photomania
//
//  Created by James Small on 9/9/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
         inManagedObjectConext:(NSManagedObjectContext *)context;

@end
