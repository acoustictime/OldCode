//
//  Photographer+Create.h
//  Photomania
//
//  Created by James Small on 9/9/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
