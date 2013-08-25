//
//  Kronicle+Life.m
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle+Life.h"
#import "ManagedContextController.h"

@implementation Kronicle (Life)

+ (Kronicle *)getKronicleWithUuid:(NSString *)uuid {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"matches : %@", matches);
    
    if ([matches count] == 0)
        return nil;
    return [matches lastObject];
}

+ (Kronicle *)newKronicle {
    return [NSEntityDescription insertNewObjectForEntityForName:@"Kronicle" inManagedObjectContext:[ManagedContextController current].managedObjectContext];
}

+ (void)deleteKronicleWithUUID:(NSString *)uuid {

}

@end
