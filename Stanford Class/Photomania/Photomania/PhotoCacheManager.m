//
//  PhotoCacheManager.m
//  SPoT
//
//  Created by James Small on 9/5/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "PhotoCacheManager.h"

#define MAX_CACHED_IPAD_PICTURES 8
#define MAX_CACHED_IPHONE_PICTURES 8
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation PhotoCacheManager

+ (void)addPhotoToCacheFor:(NSURL *)url andPhotoData:(NSData *)photoData;
{
    if (url) {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSArray *baseURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSURL *fileURLPath = [baseURL[0] URLByAppendingPathComponent:[[url pathComponents] lastObject]];
        
        if ([fileURLPath isFileURL]) {
            
            if ([fileManager fileExistsAtPath:[fileURLPath path]]) {
             
                [fileManager removeItemAtURL:fileURLPath error:nil];
            }
      
            [photoData writeToFile:[fileURLPath path] atomically:YES];
            [self adjustCachedPhotosCountBasedOnCacheLimit];
            
        }
    }
}

+ (NSData *)getPhotoFromCacheFor:(NSURL *)url;
{
   
    NSData *photoData = nil;
    
    if (url) {
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        NSArray *baseURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSURL *fileURLPath = [baseURL[0] URLByAppendingPathComponent:[[url pathComponents] lastObject]];
        
        if ([fileURLPath isFileURL]) {
            
            if ([fileManager fileExistsAtPath:[fileURLPath path]]) {
                photoData = [NSData dataWithContentsOfURL:fileURLPath];
            }
        }
    } 
    return photoData;
}


+ (void)adjustCachedPhotosCountBasedOnCacheLimit
{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *baseURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSArray *photoCount = [fileManager contentsOfDirectoryAtPath:[baseURL[0] path] error:nil];
    
    NSLog(@"photoCount = %d",[photoCount count]);
    
    BOOL deleteLeastUsedPhoto = NO;
    
    if (IPAD) {
        
     if ([photoCount count] > MAX_CACHED_IPAD_PICTURES)
         deleteLeastUsedPhoto = YES;
        
    } else {
        
        if ([photoCount count] > MAX_CACHED_IPHONE_PICTURES)
            deleteLeastUsedPhoto = YES;
    }
  
    if (deleteLeastUsedPhoto) {
       
        NSArray *propertiesArray = [[NSArray alloc] initWithObjects:NSURLAttributeModificationDateKey, nil];
    
        NSArray *photoURLS = [fileManager contentsOfDirectoryAtURL:baseURL[0] includingPropertiesForKeys:propertiesArray options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
        NSURL *oldestURL = photoURLS[0];
        
        for (NSURL *url in photoURLS) {
            
            NSDate *oldestDate = [[oldestURL resourceValuesForKeys:propertiesArray error:nil] objectForKey:NSURLAttributeModificationDateKey];
            NSDate *newDate = [[url resourceValuesForKeys:propertiesArray error:nil] objectForKey:NSURLAttributeModificationDateKey];
            
            NSDate *result = [oldestDate earlierDate:newDate];
            
            if (![result isEqualToDate:oldestDate]) {
                oldestURL = url;
            }        
        }
        
        [fileManager removeItemAtURL:oldestURL error:nil];
    }
}



@end
