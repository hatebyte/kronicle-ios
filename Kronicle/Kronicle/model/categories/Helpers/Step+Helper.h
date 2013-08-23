//
//  Step+Helper.h
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step.h"

@interface Step (Helper)

@property(nonatomic, readonly) NSInteger indexInKronicle;
@property(nonatomic, readonly) NSInteger mediaType;
@property(nonatomic, readonly) NSInteger time;

@end
