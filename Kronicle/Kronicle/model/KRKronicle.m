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
    int tt = 0;
    for (NSDictionary *step in stepsDict) {
        KRStep *s = [[KRStep alloc] init];
        [s readFromJSONDictionary:step];
        [steps addObject:s];
        tt += s.time;
    }
    self.totalTime         = tt;
    self.steps = steps;
    self.stepCount = self.steps.count;
}

- (void)kronicleShortFromJSONDictionary:(NSDictionary *)dict {
    self.uuid              = [dict objectForKey:@"_id"];
    self.title             = [dict objectForKey:@"title"];
    self.description       = [dict objectForKey:@"description"];
    self.category          = [dict objectForKey:@"category"];
    self.imageUrl          = [dict objectForKey:@"imageUrl"];
    //self.timesCompleted    = [[dict objectForKey:@"timesCompleted"] floatValue];
    NSArray *stepsDict     = [dict objectForKey:@"steps"];
    int tt = 0;
    for (NSDictionary *step in stepsDict) {
        KRStep *s = [[KRStep alloc] init];
        tt += s.time;
    }
    self.totalTime         = tt;
    self.stepCount = stepsDict.count;
}

- (NSString *)stringTime {
    int minutes = floor(self.totalTime / 60);
    int seconds = floor(self.totalTime - (minutes*60));
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
