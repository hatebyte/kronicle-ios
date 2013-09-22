//
//  APIRouter.m
//  Kronicle
//
//  Created by Scott on 7/8/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "APIRouter.h"
#import "KRGlobals.h"

@implementation APIRouter

+ (APIRouter *)current {
    static APIRouter *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] init];
    }
    return current;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self current];
}

- (id)init {
    if (self = [super init]) {
        self.baseURL = [[[NSBundle mainBundle] infoDictionary] objectForKey:kBaseUrl];
        
        self.kronicles            = self.baseURL;

    }
    return self;
}

-(NSString *)kronicleById:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@%@", self.kronicles, uuid];
}

-(NSString *)stepsForKronicleById:(NSString *)uuid {
    return [NSString stringWithFormat:@"%@%@/steps", self.kronicles, uuid];
}

@end
