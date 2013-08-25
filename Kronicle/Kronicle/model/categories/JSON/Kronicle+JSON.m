//
//  Kronicle+JSON.m
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle+JSON.h"
#import "ManagedContextController.h"
#import "Step+JSON.h"
#import "Item.h"
#import "Category.h"
#import "Step+Helper.h"
#import "Kronicle+Life.h"

@implementation Kronicle (JSON)

+ (Kronicle *)readFromJSONDictionary:(NSDictionary *)dict {
    Kronicle *kronicle                      = [Kronicle kronicleShortFromJSONDictionary:dict];
//    NSMutableArray *steps                   = [[NSMutableArray alloc] init];
    NSArray *stepsArray                     = [dict objectForKey:@"steps"];
//    for (NSDictionary *step in stepsArray) {
//        Step *s                             = [Step readFromJSONDictionary:step];
//        [steps addObject:s];
//    }
//    [kronicle setValue:[NSSet setWithArray:steps] forKey:@"stepsSet"];
    [kronicle addStepsFromArray:stepsArray];
    
    return kronicle;
}

+ (Kronicle *)kronicleShortFromJSONDictionary:(NSDictionary *)dict {
    Kronicle *kronicle                      = [Kronicle newKronicle];
    kronicle.uuid                           = [dict objectForKey:@"_id"];
    kronicle.title                          = [dict objectForKey:@"title"];
    kronicle.desc                           = [dict objectForKey:@"description"];
    kronicle.category                       = [[ManagedContextController current] getNewCategory];
    kronicle.category.name                  = [dict objectForKey:@"category"];
    kronicle.coverUrl                       = [dict objectForKey:@"imageUrl"];
    
    NSArray *stepsArray                      = [dict objectForKey:@"steps"];
    int tt = 0;
    for (NSDictionary *step in stepsArray) {
        Step *s                             = [Step readFromJSONDictionary:step];
        tt                                  += [s.timeNumber intValue];
    }
    kronicle.totalTimeNumber                = [NSNumber numberWithInt:tt];
    
    NSArray *dictItems                      = [dict objectForKey:@"items"];
    NSMutableArray *listItems               = [[NSMutableArray alloc] init];
    for (NSString *itemName in dictItems) {
        Item *item                          = [[ManagedContextController current] getNewItem];
        item.parentKronicle                 = kronicle;
        item.acquired                       = NO;
        item.name                           = itemName;
        [listItems addObject:item];
    }
    [kronicle setValue:[NSSet setWithArray:listItems] forKey:@"itemsSet"];

    kronicle.stepCountNumber                      = [NSNumber numberWithInt:stepsArray.count];
    kronicle.timesCompletedNumber                 = [NSNumber numberWithInt:0];
    return kronicle;
}

- (NSArray *)addStepsFromArray:(NSArray *)stepsArray {
    NSMutableArray *steps                   = [[NSMutableArray alloc] init];
    for (NSDictionary *step in stepsArray) {
        Step *s                             = [Step readFromJSONDictionary:step];
        [steps addObject:s];
    }
    [self setValue:[NSSet setWithArray:steps] forKey:@"stepsSet"];
    return steps;
}

@end
