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
#import "Category.h"
#import "Item.h"

@interface ManagedContextController : NSObject

+ (ManagedContextController *)current;

- (void)saveContext;

- (Category *)getNewCategory;
- (Item *)getNewItem;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
