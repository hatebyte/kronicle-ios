//
//  ManagedContextController.h
//  Kronicle
//
//  Created by Scott on 8/20/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Kronicle.h"
#import "Step.h"
#import "CategoryType.h"
#import "Item.h"

@interface ManagedContextController : NSObject

+ (ManagedContextController *)current;

- (void)saveContext;

- (CategoryType *)getNewCategory;
- (Item *)getNewItem;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
