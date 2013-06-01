//
//  KroniclesList.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRList.h"
#import "KRKronicle.h"

@implementation KRList

- (void)readFromJSONDictionary:(NSDictionary *)d {
    self.kronicles = [[NSMutableArray alloc] init];
    NSArray *list = (NSArray*)d;
    for (NSDictionary *kronicle in list) {
        KRKronicle *k = [[KRKronicle alloc] init];
        [k kronicleShortFromJSONDictionary:kronicle];
        [self.kronicles addObject:k];
    }
}

@end
