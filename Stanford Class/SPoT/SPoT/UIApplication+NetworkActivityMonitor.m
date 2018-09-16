//
//  UIApplication+NetworkActivityMonitor.m
//  SPoT
//
//  Created by James Small on 9/4/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "UIApplication+NetworkActivityMonitor.h"

@interface UIApplication (NetworkActivityIndicator)

- (void)toggleNetworkActivityIndicatorVisible:(BOOL)visible;

@end

@implementation UIApplication (NetworkActivityIndicator)

-(void)toggleNetworkActivityIndicatorVisible:(BOOL)visible
{
    static int activityCount = 0;
    @synchronized (self) {
        visible ? activityCount++ : activityCount--;
        self.networkActivityIndicatorVisible = activityCount > 0;
    }
}
@end