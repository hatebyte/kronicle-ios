//
//  Category.h
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Kronicle *kronicles;

@end
