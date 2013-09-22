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
#import "CategoryType.h"
#import "Step+Helper.h"
#import "Kronicle+Life.h"

@implementation Kronicle (JSON)

+ (Kronicle *)readFromJSONDictionary:(NSDictionary *)dict {
    Kronicle *kronicle                      = [Kronicle kronicleShortFromJSONDictionary:dict];
    [kronicle addStepsFromArray:[dict objectForKey:@"steps"]];
    return kronicle;
}

+ (Kronicle *)kronicleShortFromJSONDictionary:(NSDictionary *)dict {
    Kronicle *kronicle                      = [Kronicle newKronicle];
    kronicle.uuid                           = [dict objectForKey:@"_id"];
    kronicle.title                          = [dict objectForKey:@"title"];
    kronicle.desc                           = [dict objectForKey:@"description"];
    kronicle.categoryType                       = [[ManagedContextController current] getNewCategory];
    kronicle.categoryType.name                  = [dict objectForKey:@"category"];
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
    kronicle.isFinishedNumber                     = [NSNumber numberWithInt:1];
//    kronicle.creator                              = @"Walter White";
    return kronicle;
}

+ (NSDictionary *)toDictionary:(Kronicle *)kronicle {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (Item *i in kronicle.items) {
        [items addObject:i];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          kronicle.uuid,            @"_id"
                          ,kronicle.title,          @"title"
                          ,kronicle.desc,           @"description"
                          ,kronicle.coverUrl,       @"imageUrl"
                          ,items,                   @"items"
                          ,[NSNumber numberWithInteger:kronicle.totalTime],   @"totalTime"
                          , nil];
    return dict;
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
