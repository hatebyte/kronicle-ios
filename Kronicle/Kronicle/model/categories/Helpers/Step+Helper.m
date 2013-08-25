//
//  Step+Helper.m
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step+Helper.h"

@implementation Step (Helper)

+ (NSString *)createCoverImageName {
    return [NSString stringWithFormat:@"stepimage_%@.png", [Kronicle makeUUID]];
}

- (NSInteger)indexInKronicle {
    return [self.indexInKronicleNumber integerValue];
}

- (void)setIndexInKronicle:(NSInteger)indexInKronicle {
    self.indexInKronicleNumber = [NSNumber numberWithInteger:indexInKronicle];
}

- (NSInteger)mediaType {
    return [self.mediaTypeNumber integerValue];
}

- (void)setMediaType:(NSInteger)mediaType {
    self.mediaTypeNumber = [NSNumber numberWithInteger:mediaType];
}

- (NSInteger)time {
    return [self.timeNumber integerValue];
}

- (void)setTime:(NSInteger)time {
    self.timeNumber = [NSNumber numberWithInteger:time];
}

- (NSString *)fullMediaURL {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", self.mediaUrl]];
}

@end
