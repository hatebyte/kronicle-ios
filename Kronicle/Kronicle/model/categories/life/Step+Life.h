//
//  Step+Life.h
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step.h"

@interface Step (Life)

+ (Step *)newStep;
+ (Step *)newUnfinishedStep;
+ (void)deleteStep:(Step *)step;
+ (void)deleteStepWithUUID:(NSString *)uuid;
- (void)deleteMedia;

@end
