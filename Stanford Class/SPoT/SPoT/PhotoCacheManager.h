//
//  PhotoCacheManager.h
//  SPoT
//
//  Created by James Small on 9/5/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCacheManager : NSObject

+ (NSData *)getPhotoFromCacheFor:(NSURL *)url;
+ (void)addPhotoToCacheFor:(NSURL *)url andPhotoData:(NSData *)photoData;

@end
