//
//  ManagedContextController.m
//  Kronicle
//
//  Created by Scott on 8/20/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ManagedContextController.h"

@implementation ManagedContextController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (ManagedContextController *)current {
    static ManagedContextController *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] init];
    }
    return current;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self current];
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (BOOL)hasPreloaded {
    NSFetchRequest *f = [[NSFetchRequest alloc] initWithEntityName:@"Kronicle"];
    NSInteger count = [_managedObjectContext countForFetchRequest:f error:nil];
    return  count > 0;
}

- (void)saveContext {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (Category *)getNewCategory{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:self.managedObjectContext];
}

- (Item *)getNewItem{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
}

//- (NSArray *)getSaveKronicles {
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:self.managedObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDescription];
//
//    // Set example predicate and sort orderings...
//    NSNumber *minimumSalary = ...;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
//    [request setPredicate:predicate];
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"firstName" ascending:YES];
//    [request setSortDescriptors:@[sortDescriptor]];
//    
//    NSError *error;
//    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
//    if (array == nil)
//    {
//        // Deal with error...
//    }
//}

#pragma mark Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KronicleModel" withExtension:@"momd"];

    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self supportingFilesDirectory] URLByAppendingPathComponent:@"KronicleModel.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)supportingFilesDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end






















