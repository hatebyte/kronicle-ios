//
//  Step+JSON.m
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Step+JSON.h"
#import "ManagedContextController.h"
#import "Step+Life.h"

@implementation Step (JSON)

+ (Step *)readFromJSONDictionary:(NSDictionary *)dict {
    Step *step                              = [Step newStep];
    step.uuid                               = [dict objectForKey:@"_id"];
    step.title                              = [dict objectForKey:@"title"];
    step.desc                               = [dict objectForKey:@"description"];
    step.mediaUrl                           = [dict objectForKey:@"imageUrl"];
    step.parentKronicle                     = [dict objectForKey:@"parentKronicleId"];
    step.timeNumber                         = [NSNumber numberWithFloat:[[dict objectForKey:@"time"] floatValue]];
    step.indexInKronicleNumber              = [NSNumber numberWithFloat:[[dict objectForKey:@"indexInKronicle"] floatValue]];
    return step;
}

//- (NSData *)writeToJSONData {
//    NSDictionary *stepDict = [NSMutableDictionary dictionaryWithCapacity:4];
//    [stepDict setValue:self.title forKey:@"title"];
//    [stepDict setValue:self.description forKey:@"description"];
//    [stepDict setValue:[NSNumber numberWithFloat:self.time] forKey:@"time"];
//    [stepDict setValue:[NSNumber numberWithFloat:self.indexInKronicle] forKey:@"indexInKronicle"];
//    return [NSJSONSerialization dataWithJSONObject:stepDict options:NSJSONWritingPrettyPrinted error:nil];
//}

@end
