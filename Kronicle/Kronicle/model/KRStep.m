//
//  KRStep.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRStep.h"

@implementation KRStep

- (void)readFromJSONDictionary:(NSDictionary *)dict {
    self.uuid              = [dict objectForKey:@"_id"];
    self.title             = [dict objectForKey:@"title"];
    self.description       = [dict objectForKey:@"description"];
    self.imageUrl          = [dict objectForKey:@"imageUrl"];
    self.parentKronicleId  = [dict objectForKey:@"parentKronicleId"];
    self.time              = (int)[dict objectForKey:@"time"];
    self.indexInKronicle   = (int)[dict objectForKey:@"indexInKronicle"];
}

@end
