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
        
        [self initializeCoreDataStack];
        
    }
    return self;
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

- (void)contextInitialzed {
    DLog(@"contextInitialized");
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(documentStateChanged:)
                   name:UIDocumentStateChangedNotification
                 object:[self managedObjectContext]];
    
    [center addObserver:self
               selector:@selector(mergePersistantStoreCoordinatorChanges:)
                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                 object:[self managedObjectContext]];
    
}

- (void)documentStateChanged:(NSNotification *)note {
    switch ([[note object] documentState]) {
        case UIDocumentStateNormal:
            DLog(@"UIDocumentStateNormal");
            break;
        case UIDocumentStateClosed:
            DLog(@"UIDocumentStateClosed : %@", note);
            break;
        case UIDocumentStateInConflict:
            DLog(@"UIDocumentStateInConflict : %@", note);
            break;
        case UIDocumentStateSavingError:
            DLog(@"UIDocumentStateSavingError : %@", note);
            break;
        case UIDocumentStateEditingDisabled:
            DLog(@"UIDocumentStateEditingDisabled : %@", note);
            break;
    }
}

- (void)mergePersistantStoreCoordinatorChanges:(NSNotification *)note {
    NSManagedObjectContext *moc = [self managedObjectContext];
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:note];
    }];
}

- (void)initializeCoreDataStack {
    NSURL *modelURL                                 = [[NSBundle mainBundle] URLForResource:@"KronicleModel" withExtension:@"momd"];
    ZAssert(modelURL, @"Failed to find model URL");
    
    NSManagedObjectModel *mom                       = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    ZAssert(mom, @"Failed to initialize model");
    
    NSPersistentStoreCoordinator *psc               = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    ZAssert(psc, @"Failed to initialize persistent store coordinator");
    
    NSManagedObjectContext *manObjContext           = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [manObjContext setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:manObjContext];
    
    dispatch_queue_t queue                          = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    
        NSMutableDictionary *options                = [[NSMutableDictionary alloc] init];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];

        NSFileManager *fileManager                  = [NSFileManager defaultManager];
        NSURL *cloudURL                             = [fileManager URLForUbiquityContainerIdentifier:nil];
        
        if (cloudURL) {
            DLog(@"iCloud is enabled: %@", cloudURL);
            cloudURL                                = [cloudURL URLByAppendingPathComponent:@"KronicleModel"];
            [options setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setValue:cloudURL forKey:NSPersistentStoreUbiquitousContentURLKey];
            
        } else {
            DLog(@"iCloud is not enabled");
        }
        
        NSURL *storeURL = nil;
        storeURL                                    = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL                                    = [storeURL URLByAppendingPathComponent:@"KronicleModel.iCloud.sqlite"];
        
        NSError *error;
        NSPersistentStoreCoordinator *coordinator   = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store                    = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                configuration:nil
                                                                                          URL:storeURL
                                                                                      options:options
                                                                                        error:&error];
        if (!store) {
            ALog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self contextInitialzed];
        });
        
    });
}

- (CategoryType *)getNewCategory{
    return [NSEntityDescription insertNewObjectForEntityForName:@"CategoryType" inManagedObjectContext:self.managedObjectContext];
}

- (Item *)getNewItem{
    return [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
}


//#pragma mark Core Data stack
//
//- (NSManagedObjectContext *)managedObjectContext {
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managedObjectContext;
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KronicleModel" withExtension:@"momd"];
//
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self supportingFilesDirectory] URLByAppendingPathComponent:@"KronicleModel.sqlite"];
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//                                [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
//    
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    return _persistentStoreCoordinator;
//}
//
//- (NSURL *)supportingFilesDirectory {
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}

@end






















