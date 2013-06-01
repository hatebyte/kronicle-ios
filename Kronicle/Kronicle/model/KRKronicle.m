//
//  KRKronicle.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicle.h"
#import "KRStep.h"

@implementation KRKronicle

- (void)readFromJSONDictionary:(NSDictionary *)d {
    [self kronicleShortFromJSONDictionary:d];
    
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    NSArray *stepsDict = [d objectForKey:@"steps"];
    for (NSDictionary *step in stepsDict) {
        KRStep *s = [[KRStep alloc] init];
        [s readFromJSONDictionary:step];
        [steps addObject:s];
    }
    self.steps = steps;
}

- (void)kronicleShortFromJSONDictionary:(NSDictionary *)dict {
    self.uuid              = [dict objectForKey:@"_id"];
    self.title             = [dict objectForKey:@"title"];
    self.description       = [dict objectForKey:@"description"];
    self.category          = [dict objectForKey:@"category"];
    self.imageUrl          = [dict objectForKey:@"imageUrl"];
    self.totalTime         = (int)[dict objectForKey:@"totalTime"];
    self.timesCompleted    = (int)[dict objectForKey:@"timesCompleted"];
}

@end
