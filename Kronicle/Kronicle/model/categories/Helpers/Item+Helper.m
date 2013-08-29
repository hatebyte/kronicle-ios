//
//  Item+Helper.m
//  Kronicle
//
//  Created by Scott on 8/28/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Item+Helper.h"
#import "ManagedContextController.h"

@implementation Item (Helper)


- (BOOL)hasBeenAcquired {
    return [self.acquired boolValue];
}

- (void)setHasBeenAcquired:(BOOL)hasBeenAcquired {
    self.acquired = [NSNumber numberWithBool:hasBeenAcquired];
    
    [[ManagedContextController current] saveContext];
}

@end
