//
//  CategoryType.h
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface CategoryType : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *kroniclesSet;
@end

@interface CategoryType (CoreDataGeneratedAccessors)

- (void)addKroniclesSetObject:(Kronicle *)value;
- (void)removeKroniclesSetObject:(Kronicle *)value;
- (void)addKroniclesSet:(NSSet *)values;
- (void)removeKroniclesSet:(NSSet *)values;

@end
