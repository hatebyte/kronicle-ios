//
//  Kronicle.h
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, ListItem, Step, User;

@interface Kronicle : NSManagedObject

@property (nonatomic, retain) NSString * coverUrl;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSDate * lastDateChanged;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * stepCount;
@property (nonatomic, retain) NSNumber * timesCompleted;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * totalTime;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) User *creator;
@property (nonatomic, retain) NSSet *steps;
@property (nonatomic, retain) ListItem *items;
@end

@interface Kronicle (CoreDataGeneratedAccessors)

- (void)addStepsObject:(Step *)value;
- (void)removeStepsObject:(Step *)value;
- (void)addSteps:(NSSet *)values;
- (void)removeSteps:(NSSet *)values;

@end
