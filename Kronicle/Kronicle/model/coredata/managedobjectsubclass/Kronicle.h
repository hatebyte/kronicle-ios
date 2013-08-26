//
//  Kronicle.h
//  Kronicle
//
//  Created by Scott on 8/25/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Item, Step, User;

@interface Kronicle : NSManagedObject

@property (nonatomic, retain) NSString * coverUrl;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * lastDateChanged;
@property (nonatomic, retain) NSNumber * ratingNumber;
@property (nonatomic, retain) NSNumber * stepCountNumber;
@property (nonatomic, retain) NSNumber * timesCompletedNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * totalTimeNumber;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * isFinishedNumber;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) NSSet *itemsSet;
@property (nonatomic, retain) NSSet *stepsSet;
@end

@interface Kronicle (CoreDataGeneratedAccessors)

- (void)addItemsSetObject:(Item *)value;
- (void)removeItemsSetObject:(Item *)value;
- (void)addItemsSet:(NSSet *)values;
- (void)removeItemsSet:(NSSet *)values;

- (void)addStepsSetObject:(Step *)value;
- (void)removeStepsSetObject:(Step *)value;
- (void)addStepsSet:(NSSet *)values;
- (void)removeStepsSet:(NSSet *)values;

@end
