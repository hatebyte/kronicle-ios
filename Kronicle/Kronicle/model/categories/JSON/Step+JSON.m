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
    NSLog(@"dict : %@", dict);
    Step *step                              = [Step newStep];
    step.uuid                               = ([dict objectForKey:@"uuid"]) ? [dict objectForKey:@"uuid"] : [dict objectForKey:@"_id"];
    step.title                              = [dict objectForKey:@"title"];
    step.desc                               = [dict objectForKey:@"description"];
    step.mediaUrl                           = [dict objectForKey:@"imageUrl"];
    step.parentKronicle                     = [dict objectForKey:@"parentKronicleId"];
    step.isFinishedNumber                   = [NSNumber numberWithInt:1];

    step.timeNumber                         = [NSNumber numberWithFloat:[[dict objectForKey:@"time"] floatValue]];
    step.indexInKronicleNumber              = [NSNumber numberWithFloat:[[dict objectForKey:@"indexInKronicle"] floatValue]];
    return step;
}

+ (NSDictionary *)toDictionary:(Step *)step {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          step.uuid,                        @"uuid"
                          ,step.title,                      @"title"
                          ,step.desc,                       @"description"
//                          ,[step fullMediaURL],             @"imageUrl"
                          ,[NSNumber numberWithInteger:step.indexInKronicle],        @"indexInKronicle"
                          ,[NSNumber numberWithInteger:step.time],                  @"time"
                          , nil];
    return dict;
}

@end
