//
//  Step+Helper.m
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step+Helper.h"

@implementation Step (Helper)


- (NSInteger)indexInKronicle {
    return [self.indexInKronicleNumber integerValue];
}

- (NSInteger)mediaType {
    return [self.mediaTypeNumber integerValue];
}

- (NSInteger)time {
    return [self.timeNumber integerValue];
}

@end
