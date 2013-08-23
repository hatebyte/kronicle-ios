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
    self.circleUrl         = [dict objectForKey:@"dialImageUrl"];
    self.parentKronicleId  = [dict objectForKey:@"parentKronicleId"];
    self.time              = [[dict objectForKey:@"time"] floatValue];
    self.indexInKronicle   = [[dict objectForKey:@"indexInKronicle"]floatValue];
}

- (NSData *)writeToJSONData {
    NSDictionary *stepDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [stepDict setValue:self.title forKey:@"title"];
    [stepDict setValue:self.description forKey:@"description"];
    [stepDict setValue:[NSNumber numberWithFloat:self.time] forKey:@"time"];
    [stepDict setValue:[NSNumber numberWithFloat:self.indexInKronicle] forKey:@"indexInKronicle"];
    return [NSJSONSerialization dataWithJSONObject:stepDict options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)stringTime {
    int minutes = floor(self.time / 60);
    int seconds = floor(self.time - (minutes*60));
    NSString *s;
    NSString *m = [NSString stringWithFormat:@"%d", minutes];
    if (seconds < 10) {
        s = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        s = [NSString stringWithFormat:@"%d", seconds];
    }
    return [NSString stringWithFormat:@"%@:%@", m, s];
}

@end
