//
//  Step.h
//  Kronicle
//
//  Created by hatebyte on 9/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * indexInKronicleNumber;
@property (nonatomic, retain) NSDate * lastDateChanged;
@property (nonatomic, retain) NSNumber * mediaTypeNumber;
@property (nonatomic, retain) NSString * mediaUrl;
@property (nonatomic, retain) NSNumber * timeNumber;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * isFinishedNumber;
@property (nonatomic, retain) Kronicle *parentKronicle;

@end
