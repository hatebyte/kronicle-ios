//
//  Kronicle+Life.m
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle+Life.h"
#import "ManagedContextController.h"
#import "Kronicle+Helper.h"
#import "Step+Helper.h"
#import "Step+Life.h"

@implementation Kronicle (Life)

+ (Kronicle *)getKronicleWithUuid:(NSString *)uuid {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@ && isFinishedNumber = YES", uuid];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] == 0)
        return nil;
    return [matches lastObject];
}

+ (Kronicle *)getUnfinishedKronicle {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"isFinishedNumber = NO"];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] == 0)
        return [Kronicle newUnfinishedKronicle];
    return [matches lastObject];
}

+ (Kronicle *)newUnfinishedKronicle {
    Kronicle *k = [Kronicle newKronicle];
    k.uuid = [Kronicle makeUUID];
    k.dateCreated = [NSDate date];
    k.lastDateChanged = [NSDate date];
    k.isFinished = NO;
    return k;
}

+ (Kronicle *)newKronicle {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Kronicle" inManagedObjectContext:[ManagedContextController current].managedObjectContext];
}


+ (void)saveContext {
    [[ManagedContextController current] saveContext];
}

+ (void)deleteKronicleWithUUID:(NSString *)uuid {
    
}

+ (void)deleteKronicle:(Kronicle *)kronicle {
    for (Step *s in kronicle.steps) {
        [s deleteMedia];
    }
    
    if (kronicle.coverUrl.length > 0) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[kronicle fullCoverURL]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[kronicle fullCoverURL] error: &error];
            if (error != nil) {
                NSLog(@"Tried to remove kronicle fullCoverURL %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    
    [[ManagedContextController current].managedObjectContext deleteObject:kronicle];
    [[ManagedContextController current] saveContext];
}




- (void)update {
    self.stepCount = [self.steps count];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexInKronicleNumber" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *orderedArray = [self.steps sortedArrayUsingDescriptors:sortDescriptors];
    self.steps = orderedArray;
    for (NSInteger i = 0; i < self.stepCount; i++) {
        Step *s = [self.steps objectAtIndex:i];
        s.indexInKronicle = i;
    }
    self.lastDateChanged = [NSDate date];
    [[ManagedContextController current] saveContext];
}


@end















