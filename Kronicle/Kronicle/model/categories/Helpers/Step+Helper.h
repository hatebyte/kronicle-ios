//
//  Step+Helper.h
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step.h"
#import "Kronicle+Helper.h"

@interface Step (Helper)

@property(nonatomic, assign) NSInteger indexInKronicle;
@property(nonatomic, assign) NSInteger mediaType;
@property(nonatomic, assign) NSInteger time;

+ (NSString *)createCoverImageName;
- (NSString *)fullMediaURL;

@end
