//
//  Step+Life.m
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step+Life.h"
#import "ManagedContextController.h"

@implementation Step (Life)

+ (Step *)newStep {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Step" inManagedObjectContext:[ManagedContextController current].managedObjectContext];
}

+ (void)deleteStepWithUUID:(NSString *)uuid {
    
}

@end
