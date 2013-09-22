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
#import "Step+Helper.h"

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

+ (NSDictionary *)toDictionary:(Step *)step {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          step.uuid,                        @"_id"
                          ,step.title,                      @"title"
                          ,step.desc,                       @"description"
                          ,step.parentKronicle,             @"parentKronicle"
                          ,[NSNumber numberWithInteger:step.indexInKronicle],        @"indexInKronicleNumber"
                          ,[NSNumber numberWithInteger:step.time],                  @"timeNumber"
                          , nil];
    return dict;
}

@end
