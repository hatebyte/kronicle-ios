//
//  Step.h
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * indexInKronicle;
@property (nonatomic, retain) NSDate * lastDateChanged;
@property (nonatomic, retain) NSNumber * mediaType;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) Kronicle *parentKronicle;

@end
