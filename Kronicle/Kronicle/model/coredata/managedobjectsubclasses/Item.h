//
//  Item.h
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * acquired;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Kronicle *parentKronicle;

@end
