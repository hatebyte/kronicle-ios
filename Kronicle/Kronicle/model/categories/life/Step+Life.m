//
//  Step+Life.m
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step+Life.h"
#import "Step+Helper.h"
#import "Kronicle+Helper.h"
#import "ManagedContextController.h"

@implementation Step (Life)

+ (Step *)newStep {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:[ManagedContextController current].managedObjectContext];
}

+ (Step *)newUnfinishedStep {
    Step *s = [Step newStep];
    s.uuid = [Kronicle makeUUID];
    s.dateCreated = [NSDate date];
    s.lastDateChanged = [NSDate date];
    return s;
}

+ (void)deleteStepWithUUID:(NSString *)uuid {
    
}

- (void)deleteMedia {
    if (self.mediaUrl.length > 0) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self fullMediaURL]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self fullMediaURL] error: &error];
            if (error != nil) {
                NSLog(@"Tried to remove step fullMediaURL %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}

+ (void)deleteStep:(Step *)step {
    [step deleteMedia];
    [[ManagedContextController current].managedObjectContext deleteObject:step];
    [[ManagedContextController current] saveContext];
}

@end
