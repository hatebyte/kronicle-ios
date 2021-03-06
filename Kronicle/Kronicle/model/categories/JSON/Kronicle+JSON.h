//
//  Kronicle+JSON.h
//  Kronicle
//
//  Created by Scott on 8/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle.h"

@interface Kronicle (JSON)


+ (Kronicle *)readFromJSONDictionary:(NSDictionary *)dict;
+ (Kronicle *)kronicleShortFromJSONDictionary:(NSDictionary *)dict;
- (NSArray *)addStepsFromArray:(NSArray *)stepsArray;

@end
